# Mon PF App - Flutter

Flutter application for Yassmine Hajji's final-year restaurant ordering and delivery project.

The app is demo-ready by default: login, menu, cart, tracking, profile, driver dashboard and admin dashboard can be tested without a backend. A Laravel/MySQL REST API can be connected later through `--dart-define`.

## Run

```powershell
flutter pub get
flutter run
```

Run on Chrome for visual testing:

```powershell
flutter run -d chrome --web-port 57321
```

Run with a real API:

```powershell
flutter run --dart-define=DEMO_MODE=false --dart-define=API_BASE_URL=https://votre-domaine/api
```

## Verify

```powershell
dart analyze
flutter test
flutter build web --release --dart-define=DEMO_MODE=true
```

Android:

```powershell
flutter build apk --debug
flutter build apk --release
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

## Structure

```text
lib/
├── app/                 # App shell, theme, navigation and shared state
├── core/                # API config, secure storage, validators
├── data/                # Demo data
├── domain/models/       # User, menu item, cart item, order model
├── features/
│   ├── auth/            # Login/register + AuthService
│   ├── client/          # Home, menu, cart, tracking, orders, profile
│   └── operations/      # Driver and admin dashboards
└── shared/widgets/      # Reusable UI components
```

## Backend Contract

| Method | Endpoint | Notes |
|---|---|---|
| `POST` | `/register` | Public registration creates a `client` only |
| `POST` | `/login` | Returns `token` and `user` |
| `POST` | `/logout` | Uses `Authorization: Bearer <token>` |

Expected auth response:

```json
{
  "token": "server-token",
  "user": {
    "id": 1,
    "nom": "Yassmine Hajji",
    "email": "yassmine@monpf.fr",
    "role": "client"
  }
}
```

## Release Notes

- Android debug and signed release APK builds are working on this machine.
- Windows release is blocked until Visual Studio Build Tools includes **C++ ATL for latest v142 build tools**.
- Local signing files are intentionally ignored by Git: `android/key.properties`, `*.jks`, `*.keystore`.

More details are in:

- [Setup and release](docs/setup_and_release.md)
- [Testing guide](docs/testing_guide.md)
- [Architecture](docs/architecture.md)
- [Full tutorial PDF](../docs/tutorial/Mon_PF_App_Tutorial_Yassmine_Hajji.pdf)
