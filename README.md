# Astro Kovesh API

API publica de dados astrologicos do projeto Astro Kovesh.

O frontend foi separado para outro repositorio:

- `nitaigf/astro-kovesh-web`

## Stack

- Python 3.12+
- FastAPI
- Pydantic v2
- Uvicorn
- Geopy (Nominatim)
- TimezoneFinder
- Swiss Ephemeris (`pyswisseph`, opcional por ambiente)

## Estrutura

```text
.
├── api/
│   ├── app/
│   │   ├── api/routes/
│   │   ├── core/
│   │   ├── schemas/
│   │   ├── services/
│   │   └── utils/
│   ├── requirements.txt
│   ├── requirements-astro.txt
│   ├── requirements-dev.txt
│   └── .env.example
├── bruno/astro-kovesh/
├── docker-compose.yml
└── README.md
```

## Executar localmente

1. Ambiente e dependencias:

```bash
cd api
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements-dev.txt
cp .env.example .env
```

2. Subir API:

```bash
python3 -m app.run
```

Documentacao:

- Swagger UI: `http://localhost:8010/docs`
- ReDoc: `http://localhost:8010/redoc`

Endpoints principais:

- `GET /health`
- `POST /v1/chart`

## Testes

```bash
cd api
pytest -q
```

## Docker (API only)

```bash
docker compose up --build
```

## Deploy na Vercel

Este repositorio deve ser publicado como projeto da API.

Configuracao:

- Root Directory: `api`
- Entry point: `api/index.py`
- Configuracao: `api/vercel.json`

Observacao sobre engine astrologica:

- Quando o runtime nao suporta extensoes nativas C, a API continua de pe.
- Nessa situacao, `POST /v1/chart` retorna `503` com mensagem `astrology_engine_unavailable`.

Arquivos de dependencias:

- `api/requirements.txt`: runtime minimo
- `api/requirements-astro.txt`: dependencias astrologicas nativas
- `api/requirements-dev.txt`: runtime + astrologia + testes

## Makefile

Atalhos principais:

```bash
make install
make api-run
make test
make docker-up
```

## Git Flow

Fluxo adotado:

- `main`: producao
- `develop`: integracao
- `feature/*`, `release/*`, `hotfix/*`
