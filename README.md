# BitGo Express ColdFusion Client

Simple ColdFusion client for interacting with the [BitGo platform](https://developers.bitgo.com/reference/), along with a Docker setup for running the BitGo Express service locally.

## Configuration

### Prerequisites

- Set up a BitGo account in the [testnet](https://app.bitgo-test.com/) or [production](https://app.bitgo.com/) environment.
- Create a long-lived access token.

### Docker

Create .env files for the Docker containers:

```bash
# In the docker/ folder
cp .env.example .env.dev
cp .env.example .env.prod
```

Edit the .env files:

```env
# https://github.com/BitGo/BitGoJS/blob/master/modules/express/.env.example
BITGO_PORT=3080
BITGO_ENV=dev
```

### ColdFusion

Create .env files for development and production:

```bash
# In the coldfusion/ folder
cp .env.example .env.dev
cp .env.example .env.prod
```

Edit the environment files with your configuration:

```env
BITGO_EXPRESS_HOST=127.0.0.1
BITGO_EXPRESS_PORT=3080
BITGO_ACCESS_TOKEN=your_bitgo_access_token
BITGO_PASSPHRASE=your_bitgo_wallet_or_account_passphrase
```

> [!NOTE]
> When you create the access token and the wallet, use the wallet passphrase to transact. Othwerwise, when you create the access token but someone else creates the wallet, use your BitGo-login passphrase to transact.

For local development, set the `request.ENVIRONMENT` to `dev` in `application.cfc`. In production, set it to `prod`.

## Running the app

### Start the BitGo Express server

```bash
# From the docker/ folder
cd docker

# Create and start the development container
docker compose -f docker-compose.yml -f docker-compose.dev.yml up -d
# or
npm run up:dev

# Create and start the production container (uses docker-compose.override.yml)
docker compose up -d
# or
npm run up

# Resume previously stopped container
docker compose start bitgo-express
# or
npm start

# Ensure the BitGo Express server is running
curl localhost:3080/api/v2/pingexpress
> {"status":"express server is ok!"}

# Check connection to bitgo.com
curl localhost:3080/api/v2/ping
> {"status":"service is ok!","environment":"BitGo Testnet","configEnv":"testnet"}

# Track dev logs of requests sent to BitGo
docker logs --tail 100 --follow --timestamps bitgo-express-dev
# or
npm run log:dev
```

> [!TIP]
> To update BitGo, pull the latest image from Docker Hub:
>
> ```bash
> # From the docker/ folder
> cd docker
>
> # Update
> npm run stop
> docker rm bitgo-express-[prod|dev]
> docker rmi bitgo/express
> npm run up[:dev]
>
> # Verify
> docker exec -it bitgo-express-[prod|dev] /bin/bash
> cat /var/bitgo-express/package.json | grep '"bitgo":'
> > "bitgo": "^50.15.0"
> # See change Log at https://github.com/BitGo/BitGoJS/blob/master/modules/bitgo/CHANGELOG.md
> ```

### Start the ColdFusion client

```bash
# From the coldfusion/ folder
cd coldfusion

# Start the ColdFusion server via CommandBox
box config set modules.commandbox-dotenv.checkEnvPreServerStart=false && box server start
# or
npm start
```

The ColdFusion client will open in the browser at `http://localhost:8080/usage.cfm` (this can be changed in `server.json`).

The `usage.cfm` file serves as an integration test and provides examples of how to:

1. List the wallets for a specific coin, i.e. `tBTC`
2. Create a new address on the first wallet
3. Send coins to this new address
4. Get the details of this transfer/transaction

### Code formatting

```bash
cd coldfusion
box cflint reportLevel=ERROR
# or
npm run lint

box cfformat run --cfm  --overwrite
# or
npm run format
```

## Troubleshooting

1. **Connection Issues** - Verify that the BitGo Express server is running and accessible at the configured host/port
2. **Authentication Errors** - Check that your BitGo access token is correct and has the necessary permissions
3. **Wallet/Account Passphrase** - Ensure the wallet or account passphrase is correct when sending transactions
4. **Environment Variables** - Make sure all required environment variables are set
