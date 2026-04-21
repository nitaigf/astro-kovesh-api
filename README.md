# Astro Kovesh API

API publica de dados astrologicos do projeto Astro Kovesh.

Repositorio do frontend:

- `nitaigf/astro-kovesh-web`

Repositorio pai (orquestracao, contratos e docs compartilhadas):

- `nitaigf/astro-kovesh`

Documentacao operacional compartilhada (incluindo Git Flow) fica no repo pai.

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
├── .github/copilot-instructions.md
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
- em ambiente serverless, a importacao de `pyswisseph` pode falhar; a API deve continuar no ar e retornar `503` no endpoint de mapa quando a engine nativa nao estiver disponivel

Variaveis recomendadas na Vercel para a API:

- `APP_NAME=Astro Kovesh API`
- `APP_ENV=production`
- `FRONTEND_URL=https://astro-kovesh-web.vercel.app`
- `CORS_ORIGINS=https://astro-kovesh-web.vercel.app`
- `REQUEST_TIMEOUT_SECONDS=8`
- `DEFAULT_TIMEZONE=UTC`
- `GEOCODER_USER_AGENT=astro-kovesh/0.1`
- `GEOCODER_CALLS_PER_MINUTE=30`
- `GEOCODER_MIN_SECONDS_BETWEEN_CALLS=1`
- `IP_RATE_LIMIT_PER_MINUTE=60`

Observacoes para a Vercel:

- `APP_HOST` e `APP_PORT` nao sao necessarios no deploy serverless
- `VITE_API_BASE_URL` nao deve ser configurada no projeto da API; essa variavel pertence ao projeto do frontend

Contrato com o frontend:

- o frontend deve consumir somente endpoints versionados (`/v1/*`)
- a URL da API deve ser configurada externamente (`VITE_API_BASE_URL` no web)
- formato de erro deve permanecer estavel (`detail.code` e `detail.message`)
- `POST /v1/chart` pode retornar `404` para localizacao nao encontrada
- `POST /v1/chart` pode retornar `429` para rate limit ou quota de geocoding

Observacao sobre engine astrologica:

- Quando o runtime nao suporta extensoes nativas C, a API continua de pe.
- Nessa situacao, `POST /v1/chart` retorna `503` com `detail.code=astrology_engine_unavailable`.

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

Observacao:

- quando usado via repositorio pai com submodulos, manter branch do submodulo alinhada com a branch do pai (`main` com `main`, `develop` com `develop`).
