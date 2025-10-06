# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

Project summary
- Node.js Express API using ESM (type: module)
- Postgres via Drizzle ORM with Neon serverless driver
- Layered structure: routes → controllers → services → database models; zod for validation; JWT + cookies for auth; winston + morgan for logging

Prerequisites and environment
- Dependencies: npm install
- Required environment variables
  - DATABASE_URL: Postgres connection string used by Drizzle and Neon
  - Optional: PORT (defaults to 3000), JWT_SECRET (defaults to a placeholder), LOG_LEVEL, NODE_ENV
- Logs are written to logs/combined.log and logs/error.log (console output when NODE_ENV !== 'production')

Common commands
- Install dependencies
  - npm install
  - For CI: npm ci
- Run the API in watch mode (development)
  - npm run dev
- Run the API directly (production-like)
  - node src/index.js
- Lint
  - npm run lint
  - Auto-fix: npm run lint:fix
- Format with Prettier
  - Check: npm run format:check
  - Write: npm run format
- Database (Drizzle ORM)
  - Generate SQL from models (outputs to ./drizzle)
    - Ensure DATABASE_URL is set in your environment
    - npm run db:generate
  - Apply migrations to the database
    - Ensure DATABASE_URL is set
    - npm run db:migrate
  - Inspect database/schema in Drizzle Studio
    - Ensure DATABASE_URL is set
    - npm run db:studio
- Testing
  - Not configured yet. The test script is a placeholder and exits with an error. No test runner is set up.

High-level architecture
- Entry points
  - src/index.js: Loads dotenv and boots the HTTP server via src/server.js
  - src/server.js: Starts the Express app on PORT (default 3000)
  - src/app.js: Configures the Express application
    - Security: helmet, cors
    - Parsing: express.json(), express.urlencoded(), cookie-parser
    - Logging: morgan writes to winston logger
    - Health endpoints: / and /health; API root at /api
    - Routes: /api/auth mounted from src/routes/auth.routes.js
- Routing and controllers
  - src/routes/auth.routes.js defines auth endpoints (e.g., POST /api/auth/sign-up)
  - src/controllers/auth.controller.js handles request validation, calls services, sets cookies, and shapes responses
    - Validation via zod schemas in src/validations/auth.validation.js
    - Uses utilities in src/utils for formatting errors, JWT token creation, and cookie handling
- Services and data access
  - src/services/auth.service.js encapsulates business logic and DB calls
    - Password hashing with bcrypt
    - Drizzle ORM used to query/insert against Postgres models
  - src/models/user.model.js defines the users table using drizzle-orm/pg-core
- Database and migrations
  - src/config/database.js initializes Neon client and Drizzle instance (db, sql)
  - drizzle.config.js controls Drizzle CLI behavior
    - schema: ./src/models/*.js
    - out: ./drizzle
    - dialect: postgresql
    - dbCredentials.url: DATABASE_URL
  - Workflow
    - Model changes in src/models → npm run db:generate → review SQL in ./drizzle → npm run db:migrate
- Auth and security utilities
  - src/utils/jwt.js signs and verifies JWTs (JWT_SECRET, 1d expiry)
  - src/utils/cookies.js centralizes secure cookie defaults (httpOnly, sameSite strict; secure in production)
  - src/validations/auth.validation.js defines zod schemas for signup/signin
- Logging
  - src/config/logger.js configures winston
    - File transports: logs/error.log and logs/combined.log
    - Console transport enabled when not in production
  - app.js wires morgan to write into winston

Module resolution and imports
- ESM is enabled ("type": "module")
- package.json defines import specifiers for local modules (Node “imports” map)
  - #config/* → ./src/config/*
  - #controllers/* → ./src/controllers/*
  - #middleware/* → ./src/middleware/*
  - #models/* → ./src/models/*
  - #routes/* → ./src/routes/*
  - #services/* → ./src/services/*
  - #utils/* → ./src/utils/*
  - #validations/* → ./src/validations/*
- Use these specifiers when importing within the project (e.g., import logger from '#config/logger.js')

Linting and formatting
- ESLint flat config (eslint.config.js) with @eslint/js recommended rules and Prettier integration
- Test globals are preconfigured in ESLint for files under tests/**/*.js, but no tests exist yet
- Ignored: node_modules, coverage, logs, drizzle output

Operational notes for Warp
- Commands assume environment variables are set outside of the command invocation
  - Example (PowerShell): $env:DATABASE_URL = "{{DATABASE_URL}}"
- Prefer npm scripts defined in package.json for lint/format and database tasks
- For quick health checks during development:
  - GET / → "Hello from Acquisitions!"
  - GET /health → { status: 'OK', timestamp, uptime }
  - GET /api → { message: 'Acquisitions API is running!' }
