from unittest.mock import patch

from app.services.astrology import AstrologyEngineUnavailableError
from app.services.geocoding import GeocodingError


def test_chart_by_coordinates_success(client):
    payload = {
        "date": "2026-04-20",
        "time": "14:30:00",
        "location": {
            "lat": -23.5505,
            "lng": -46.6333,
            "name": "Sao Paulo, SP, Brasil",
            "timezone": "America/Sao_Paulo",
        },
        "zodiac_mode": "tropical",
        "house_system": "placidus",
    }

    response = client.post("/v1/chart", json=payload)

    assert response.status_code == 200
    data = response.json()
    assert data["normalized_input"]["timezone"] == "America/Sao_Paulo"
    assert len(data["planets"]) == 10
    assert data["ascendant"]["name"] == "Ascendant"


def test_chart_query_location_not_found(client):
    payload = {
        "date": "2026-04-20",
        "time": "14:30:00",
        "location": {"query": "Lugar Que Nao Existe 12345"},
        "zodiac_mode": "tropical",
        "house_system": "placidus",
    }

    with patch("app.services.chart_service.GeocodingService.geocode", side_effect=GeocodingError("Location not found")):
        response = client.post("/v1/chart", json=payload)

    assert response.status_code == 404
    assert response.json()["detail"] == {
        "code": "geocoding_failed",
        "message": "Location not found",
    }


def test_chart_invalid_time_returns_422(client):
    payload = {
        "date": "2026-04-20",
        "time": "99:99:99",
        "location": {
            "lat": -23.5505,
            "lng": -46.6333,
            "timezone": "America/Sao_Paulo",
        },
        "zodiac_mode": "tropical",
        "house_system": "placidus",
    }

    response = client.post("/v1/chart", json=payload)

    assert response.status_code == 422
    detail = response.json()["detail"]
    assert detail["code"] == "invalid_datetime"


def test_chart_external_service_failure_returns_422(client):
    payload = {
        "date": "2026-04-20",
        "time": "14:30:00",
        "location": {"query": "Sao Paulo, SP, Brasil"},
        "zodiac_mode": "tropical",
        "house_system": "placidus",
    }

    with patch("app.services.chart_service.GeocodingService.geocode", side_effect=RuntimeError("upstream unavailable")):
        response = client.post("/v1/chart", json=payload)

    assert response.status_code == 422
    detail = response.json()["detail"]
    assert detail["code"] == "external_service_failed"
    assert detail["message"] == "upstream unavailable"


def test_chart_engine_unavailable_returns_503(client):
    payload = {
        "date": "2026-04-20",
        "time": "14:30:00",
        "location": {
            "lat": -23.5505,
            "lng": -46.6333,
            "timezone": "America/Sao_Paulo",
        },
        "zodiac_mode": "tropical",
        "house_system": "placidus",
    }

    with patch(
        "app.services.chart_service.AstrologyService.calculate",
        side_effect=AstrologyEngineUnavailableError("engine unavailable"),
    ):
        response = client.post("/v1/chart", json=payload)

    assert response.status_code == 503
    detail = response.json()["detail"]
    assert detail["code"] == "astrology_engine_unavailable"
    assert detail["message"] == "engine unavailable"


def test_chart_rate_limit_returns_contract_error_shape(client):
    payload = {
        "date": "2026-04-20",
        "time": "14:30:00",
        "location": {
            "lat": -23.5505,
            "lng": -46.6333,
            "timezone": "America/Sao_Paulo",
        },
        "zodiac_mode": "tropical",
        "house_system": "placidus",
    }

    with patch("app.core.rate_limit.SimpleWindowLimiter.allow", return_value=False):
        response = client.post("/v1/chart", json=payload)

    assert response.status_code == 429
    assert response.json()["detail"] == {
        "code": "rate_limit_exceeded",
        "message": "Rate limit exceeded. Try again in a minute.",
    }
