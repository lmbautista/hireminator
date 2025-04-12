# Hiremitanor chatbot app

<p align="center">
  <img src="https://github.com/user-attachments/assets/83cb5264-f927-46e8-b3a3-74b8e2af9e72" alt="Hireminator" />
</p>

This project is a conversational AI agent built to act as an assistant capable of conducting multi-turn interviews and collecting structured data from users.

**Technical stack:**

- Simple and responsive chat UI using `Hotwire` (`Turbo` + `Stimulus`)
- `Tailwind` _CSS integration_
- OpenAI GPT-4 or GPT-3.5 support
- _Dockerized_ setup for local development
- `PostgreSQL` database

**Things we have covered:**

- build full API rest in Rails
- build full ERD:
  - `User` -> It will have access via any auth system and will generate sessions
  - `Session` -> User's activity tracking
  - `UseCase` -> Represet a given use case than an agent can adopt (adaptable per lang)
  - `Conversation` -> An instance of a given `UseCase` for an `User`. Only one `opened` conversation can exists per `User`
  - `Message` -> Any message we handle with AI agent that will be part of a `Conversation`
  - `AuditLog` -> Log system for WHAT was done by WHO and WHEN

  ERD Mapping:

  ```
                            `AuditLog`
  ··································································
    `Session` <-`User` -> `UseCase` -> `Conversation` -> `Message`
  ··································································
  ```

- build `Auditing` wrapper: by being used around all the actions done it allows external audit and further details for Stakeholders and Support
- build `ProviderManager`: abstraction of AI clients that can be configured for each `UseCase`
- build `Providers::OpenAi`: it simply handles the requests to that specific provider
- build `Json::Extractor`: it allows extracting JSON structures from conversations while archiving
- PII encryption to be law compliant is applied in any field related

**Things we didn't have time to cover:**

- Abandoned/closed conversations - quite straightforward solution by using Sidekiq jobs to finalize opened conversations with > x minutes of inactiviy
- Sentiments analysis - quite straightforward solution by adding a new prompt layer at `UseCase` level + drilling down the field till `Chat` entity
- RAG - I'm not an expert so, despite I fully understand the technical implications, I chose to finish the UI and bring other extras such as the audit, PII encryption and others.
- I had to sacrifice partially the test suite, so there's a big room for improvement (good thing is minimum viable was done)

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
  docker-compose run --rm rails db:prepare db:seed
```

5.**Access app in <http://localhost:3000>**

6.**Test suite execution**

```bash
  rails test
```
