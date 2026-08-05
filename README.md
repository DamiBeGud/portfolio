# Editable Portfolio

Rails portfolio website with a password-protected admin panel, custom CSS animation, editable colors, PostgreSQL, and ActiveStorage project image uploads.

## Requirements

- Ruby `3.3.10`
- Docker for local PostgreSQL, or a local PostgreSQL install
- Rails dependencies from `bundle install`

## Setup

Run the full local stack with Docker:

```sh
ADMIN_PASSWORD="change-me" docker compose up --build
```

Open the public portfolio at `http://localhost:3000`.

Open the admin panel at `http://localhost:3000/admin` and sign in with `ADMIN_PASSWORD`.

Or run Rails on your host machine and only use Docker for PostgreSQL:

```sh
docker compose up -d postgres
bundle install
bin/rails db:prepare
bin/rails db:seed
ADMIN_PASSWORD="change-me" bin/rails server
```

The development database defaults are:

```sh
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_USER=portfolio
POSTGRES_PASSWORD=portfolio
POSTGRES_DB=portfolio_development
POSTGRES_TEST_DB=portfolio_test
```

## Editable Content

The admin panel manages:

- Site text, meta description, section titles, contact email, light/dark theme colors
- Work experience and education timeline entries
- Info cards, including comma-separated tag lists
- Projects, including comma-separated technologies and uploaded images
- Contact/social links

## Image Storage

Development uses local disk storage through ActiveStorage.

Production defaults to local storage unless you set:

```sh
ACTIVE_STORAGE_SERVICE=amazon
AWS_ACCESS_KEY_ID=...
AWS_SECRET_ACCESS_KEY=...
AWS_REGION=us-east-1
AWS_BUCKET=...
```

For S3-compatible providers such as Cloudflare R2, DigitalOcean Spaces, or MinIO, also set:

```sh
AWS_ENDPOINT=...
AWS_FORCE_PATH_STYLE=true
```
