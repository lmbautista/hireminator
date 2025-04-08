# Hiremitanor chatbot app

<p align="center">
  <img src="https://github.com/user-attachments/assets/83cb5264-f927-46e8-b3a3-74b8e2af9e72" alt="Hireminator" />
</p>

This project is a conversational AI agent built to act as an assistant capable of conducting multi-turn interviews and collecting structured data from users.

Things we want to cover:

- build full API rest in Rails
- build tracker for actions audit -> `AuditLogger` (wrapper around all the actions done)
- build LLM integration layer -> `LLM::ProviderManager`
- build provider manager -> `LLM::Providers::OpenAI::Manager` (handles)
- build provider http client -> `LLM::Providers::OpenAI::HTTPClient` (handles connections to LLM)
- build `LLM::Transcriber` (handles transcription of summaries)
- build `LLM::Messages` (handles conversations)
- build `LLM::Summaries` (handles summaries of conversations)
- build `LLM::ArchivedMessages`
- more stuff to define

Technical stack:

- Simple and responsive chat UI using `Hotwire` (`Turbo` + `Stimulus`)
- `Tailwind` _CSS integration_
- OpenAI GPT-4 or GPT-3.5 support
- _Dockerized_ setup for local development
- `PostgreSQL` database

## Getting Started (Local without Docker)

1.**Clone the project**

```bash
git clone https://github.com/lmbautista/hireminator.git
cd hireminator
```

2.**Create file .env and provide the necessary environment variables for docker-compose to work properly:**

```text
  RAILS_ENV=
  DATABASE_USERNAME=
  DATABASE_PASSWORD=
  DATABASE_PORT=
  OPENAI_API_KEY=
  RAILS_ENCRYPTION_PRIMARY_KEY=
  RAILS_ENCRYPTION_DETERMINISTIC_KEY=
  RAILS_ENCRYPTION_KEY_DERIVATION_SALT=
```

3.**Run service**

```bash
  docker-compose down -v; docker-compose build; docker-compose up -d
```

4.**Database creation**

```bash
  docker-compose exec run --rm rails db:create db:migrate
```

5.**Database initialization**

```bash
  rails db:seeds
```

6.**Access app in <http://localhost:3000>**

7.**Test suite execution**

```bash
  rails test
```
