# iOS quickstart

The smallest complete integration: a scan button that opens the full member
experience. Three files — the app, the backend client, and the generated
project config.

| File | What it shows |
|------|---------------|
| `Sources/VisualizeQuickstartApp.swift` | Configure, gate on device support, pre-download the model, present the scanner |
| `Sources/PartnerBackend.swift` | Fetching a session token from your server — the app never holds a secret key |
| `project.yml` | The project, as readable text |

## Build and run

1. **Start the sample backend** (see `../backend-quickstart`) — the app fetches
   session tokens from it. It listens on `localhost:8080`, which the
   Simulator can reach.

2. **Set your publishable key.** In `project.yml`, replace
   `pk_test_replace_me` under `VZPublishableKey` with your key from the
   portal.

3. **Generate the project and open it:**

   ```bash
   brew install xcodegen      # once
   xcodegen                   # in this folder
   open VisualizeQuickstart.xcodeproj
   ```

4. **Run.** In the Simulator every screen works and the app builds; a real
   scan needs a Face ID iPhone. On a device, also point
   `PartnerBackend.baseURL` at your machine's LAN address instead of
   `localhost`.

## Pointing at an API

By default the SDK targets production (`api.visualizeme.ai`). To use another
API — a pilot base URL from your onboarding — set `VZAPIBaseURL` in
`project.yml` (under `settings.base` as `INFOPLIST_KEY_VZAPIBaseURL`) and
regenerate.

## Using this in your own app

You do not need XcodeGen. In your app: File → Add Package Dependencies, paste
the Visualize SDK package URL, then copy the two files in `Sources/` as a
starting point. `project.yml` exists only to make this sample runnable
without a checked-in Xcode project.
