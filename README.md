<p align="center">
  <img src="docs/tutorial/assets/screenshots/contact-sheet.png" alt="Mon PF App screen preview" width="920">
</p>

<h1 align="center">Mon PF App</h1>

<p align="center">
  Application Flutter + Laravel de commande restaurant, panier, livraison, espace livreur et administration.
</p>

<p align="center">
  <a href="docs/tutorial/Mon_PF_App_Tutorial_Yassmine_Hajji.pdf"><strong>Lire le tutoriel PDF</strong></a>
  ·
  <a href="docs/demo-prod-runbook.md"><strong>Lancer la demo-prod</strong></a>
  ·
  <a href="docs/specifications/requirements-summary.md"><strong>Exigences</strong></a>
  ·
  <a href="docs/design/french-restaurant-app-ui-mockup.png"><strong>Reference UI</strong></a>
</p>

<p align="center">
  <img alt="Flutter" src="https://img.shields.io/badge/Flutter-3.44.2-02569B?logo=flutter&logoColor=white">
  <img alt="Dart" src="https://img.shields.io/badge/Dart-3.12.2-0175C2?logo=dart&logoColor=white">
  <img alt="Android" src="https://img.shields.io/badge/Android-APK%20ready-3DDC84?logo=android&logoColor=white">
  <img alt="Tests" src="https://img.shields.io/badge/Tests-passing-43A047">
  <img alt="Laravel" src="https://img.shields.io/badge/Laravel-13-FF2D20?logo=laravel&logoColor=white">
  <img alt="Mode" src="https://img.shields.io/badge/Demo--prod-ready-E53935">
</p>

## Project Identity

| Field | Value |
|---|---|
| Student | Yassmine Hajji |
| Academic context | Final year project |
| Field | Application development technologies |
| Product | Restaurant ordering and delivery management app |
| Primary targets | Android and Windows |

## What The App Covers

| Actor | Main workflow |
|---|---|
| Client | Login, menu browsing, cart, checkout, order tracking, order history, profile |
| Driver | Delivery dashboard, delivery availability, accept/refuse simulation, delivery metrics |
| Admin | Sales overview, active clients, orders, driver availability, stock alert |
| Backend API | Laravel REST API with auth, roles, menu, orders, admin stats and driver queue |

## Architecture

```mermaid
flowchart LR
  U["User"] --> A["Flutter App"]
  A --> B["Feature Screens"]
  B --> C["API Services"]
  C -->|REST JSON| D["Laravel API"]
  D --> E[("SQLite demo DB")]
  C --> F["Secure Storage<br/>token + role"]
  A --> G["DemoData<br/>offline presentation mode"]
```

The app can run offline in demo mode or against the real Laravel API with `DEMO_MODE=false`.

## Repository Map

```text
.
├── docs/
│   ├── design/             # UI mockup reference and attribution
│   ├── specifications/     # Cahier de charge + analyse/conception
│   └── tutorial/           # PDF/DOCX guide, diagrams, screenshots
├── mon_pfapp/              # Flutter application
│   ├── lib/
│   │   ├── app/            # App shell, theme, navigation state
│   │   ├── core/           # API constants, secure storage, validators
│   │   ├── data/           # Demo data used without backend
│   │   ├── domain/models/  # User, menu item, cart item, order models
│   │   ├── features/       # Auth, client, driver/admin screens
│   │   └── shared/         # Reusable UI widgets
│   ├── test/               # Auth/navigation widget tests
│   └── docs/               # Technical project notes
├── mon_pfapi/              # Laravel REST API + SQLite demo database
└── tools/                  # Local runtime and tutorial tooling
```

## Current Status

| Area | Status |
|---|---|
| Flutter analysis | Passing |
| Flutter tests | Passing, 5 tests |
| Laravel API tests | Passing, 5 tests |
| Web release build | Passing |
| Android debug APK | Built |
| Android signed release APK | Built |
| Windows release | Blocked until Visual Studio ATL component is installed |
| Demo-prod backend | Laravel API ready locally with SQLite seed data |

## Quick Start

```powershell
cd mon_pfapp
flutter pub get
flutter test
flutter run
```

Run the backend:

```powershell
cd mon_pfapi
..\tools\runtime\php-8.4.22\php.exe artisan migrate:fresh --seed
..\tools\runtime\php-8.4.22\php.exe artisan serve --host=0.0.0.0 --port=8000
```

Run Flutter against the backend:

```powershell
cd mon_pfapp
flutter run --dart-define=DEMO_MODE=false --dart-define=API_BASE_URL=http://127.0.0.1:8000/api
```

Install the Android release APK on a connected device:

```powershell
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

See [Backend API](docs/backend-api.md) for endpoints, roles and accounts.

<details>
<summary><strong>Security decisions already applied</strong></summary>

- HTTPS/env-based API configuration through `API_BASE_URL`.
- `DEMO_MODE=true` by default for reliable local presentation.
- Removed public role selection during registration.
- Token and role stored through `flutter_secure_storage`.
- Auth requests include timeout and structured error handling.
- Async UI flows use `mounted` checks before updating state.
- Android signing files and keystores are ignored by Git.

</details>

## Documentation

| Document | Purpose |
|---|---|
| [Tutorial PDF](docs/tutorial/Mon_PF_App_Tutorial_Yassmine_Hajji.pdf) | Full explanation with stack, architecture, screenshots, algorithms, tests and presentation notes |
| [Editable tutorial DOCX](docs/tutorial/Mon_PF_App_Tutorial_Yassmine_Hajji.docx) | Source document for future edits |
| [PFE report PDF](docs/pfe-report/Rapport_PFE_Yassmine_Hajji_Mon_PF_App.pdf) | Academic BTS-style final project report |
| [Editable PFE report DOCX](docs/pfe-report/Rapport_PFE_Yassmine_Hajji_Mon_PF_App.docx) | Editable source report |
| [Requirements summary](docs/specifications/requirements-summary.md) | Extracted project context from the supplied PDFs |
| [Validation checklist](docs/specifications/validation-checklist.md) | What is covered vs. what remains for full cahier de charge validation |
| [Backend API](docs/backend-api.md) | Laravel structure, endpoints, roles, tests and launch commands |
| [Demo-prod runbook](docs/demo-prod-runbook.md) | Fast local demo steps for API, Windows and Android |
| [Logo note](docs/design/logo.md) | Logo concept and generated app icon locations |
| [Setup and release guide](mon_pfapp/docs/setup_and_release.md) | Android/Windows setup, build commands and blockers |
| [Testing guide](mon_pfapp/docs/testing_guide.md) | How to verify app behavior |
| [Architecture notes](mon_pfapp/docs/architecture.md) | Short technical architecture reference |

## Production Notes

Android is the strongest target today: the SDK is installed, Flutter doctor passes, and the APK builds. Windows needs the Visual Studio component **C++ ATL for latest v142 build tools** because `flutter_secure_storage_windows` requires `atlstr.h`.

For a true production launch, the next technical steps are HTTPS hosting, a hosted MySQL/PostgreSQL database, Laravel Sanctum, delivery status synchronization, notification strategy, and CI/CD builds.
