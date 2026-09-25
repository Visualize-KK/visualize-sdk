# Backend quickstart

One file, no dependencies. The three things a partner backend does:

| Route | Job |
|-------|-----|
| `POST /session` | Mints a session token your app hands the SDK |
| `POST /webhooks/visualize` | Receives signed scan events — verifies, dedupes, acts |
| `DELETE /members/{ref}/results` | Forwards a member's deletion request |

## Run it

One command, once you've filled in your keys:

```bash
cp .env.example .env      # then edit .env — your secret key from the portal
docker compose up
```

`.env` holds the configuration (and is gitignored, so your secret never
lands in version control):

| Variable | What |
|----------|------|
| `VISUALIZE_SECRET_KEY` | Your `sk_...` from the portal (Apps → your app → issue a key) |
| `VISUALIZE_WEBHOOK_SECRET` | The `whsec_...` shown when you set a webhook URL — leave blank until then |
| `VISUALIZE_API` | The API to talk to. Pilots: the base URL from your onboarding |
| `HOST_PORT` | Port to publish on; change if `8080` is taken |

## Try it

```bash
# Mint a session token — what your app calls before a scan
curl -X POST http://localhost:8080/session
# {"session_token":"vst_...","expires_at":"..."}

# Forward a deletion request (needs results delivery enabled)
curl -X DELETE http://localhost:8080/members/member_demo_1/results
```

## Webhooks

Visualize sends webhooks from the cloud, so it must reach your URL over the
internet — `localhost` and a LAN address won't receive deliveries. During
development, expose your local backend with a tunnel and use the tunnel's
URL as the webhook URL.

**1. Start the backend and a tunnel.** With the container running on
`HOST_PORT` (say 8080):

```bash
ngrok http 8080          # prints https://<name>.ngrok-free.app
```

(ngrok is the usual choice; a free account is needed once. No-account
alternative: `cloudflared tunnel --url http://localhost:8080`.)

**2. Set the webhook URL in the portal** to the tunnel URL **plus the
path**:

```
https://<name>.ngrok-free.app/webhooks/visualize
```

**3. Copy the signing secret** the portal shows into `.env` as
`VISUALIZE_WEBHOOK_SECRET`, and `docker compose up` again so the backend can
verify signatures.

Now a scan prints in the backend logs:

```
scan.completed  scan_…  member …
scan.results_available  member …:
{ ...the full result... }
```

`scan.results_available` only arrives if results delivery is enabled on the
app; without it you'll still see `scan.completed`. The free tunnel URL
changes each restart — re-paste it in the portal if you restart it.

## What to keep when you copy this

- The secret key stays in the environment, never in code or the app.
- Verify the signature over the **raw** bytes, before parsing, in constant
  time.
- Dedupe on `Visualize-Event-Id` — delivery is at-least-once. (This sample
  remembers events in process memory; use your database.)
- `host_user_ref` is whoever your session endpoint says it is — in
  production, derive it from your own authenticated member, never from
  client input.
