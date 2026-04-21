# Copilot Instructions - Astro Kovesh API

## Product Focus
- This repository owns the public astrology API.
- API stability, deterministic contracts, and clear error semantics are top priorities.
- Frontend concerns are out of scope unless they impact API contracts directly.

## Stack
- Python 3.12+
- FastAPI
- Pydantic v2
- Uvicorn
- Geopy (Nominatim)
- TimezoneFinder
- Swiss Ephemeris (`pyswisseph`, optional by runtime)

## Architecture Rules
- Keep clear layering:
  - `api/routes` for HTTP interface
  - `schemas` for request/response contracts
  - `services` for business logic
  - `core` for config/middleware
  - `utils` for shared helpers
- Keep business rules in services, not in routes.
- Preserve backward compatibility on `/v1/*` whenever possible.

## Contract Discipline
- Do not break response shape without documenting and versioning.
- Keep stable error payloads (`detail.code`, `detail.message`).
- Explicitly map external-provider errors (geocoding/timezone/engine availability).

## Runtime and Delivery
- `.env` is mandatory for local runtime.
- Dockerfile and docker-compose in this repo are API-only.
- Vercel deploy targets `api/` root with `api/index.py` entrypoint.
- If native C extension runtime is unavailable, fail gracefully with explicit `503 astrology_engine_unavailable` behavior.

## Quality Bar
- Add or update tests for any non-trivial behavior change.
- Validate inputs strictly.
- Keep external calls bounded by timeout and quota-aware limits.
- Prefer simple, explicit code over abstraction-heavy designs.
