# Mon PF API - Backend Laravel

Ce document explique le backend ajoute au projet pour transformer la demo Flutter en application demo-prod avec donnees persistantes.

## Objectif

Le backend sert a remplacer les donnees statiques par une API REST:

- authentification client/admin/serveur/livreur;
- menu restaurant stocke en base;
- creation de commande depuis le panier;
- historique des commandes;
- tableau de bord administrateur;
- file de commandes pour livreur;
- affectation et changement de statut.

## Stack

| Couche | Technologie | Pourquoi |
|---|---|---|
| API | Laravel 13 | Framework PHP robuste, clair pour un PFE, routes REST et validations integrees. |
| Base demo | SQLite | Rapide a lancer localement, aucune installation serveur DB necessaire. |
| Auth demo-prod | Bearer token hash en base | Simple a expliquer et suffisant pour la soutenance. |
| Tests | PHPUnit Laravel | Validation automatique des flux API critiques. |
| Mobile | Flutter | Android/Windows avec UI commune. |

En production commerciale, on remplacerait SQLite par MySQL/PostgreSQL et le token simple par Laravel Sanctum ou Passport.

## Structure

```text
mon_pfapi/
├── app/
│   ├── Http/Controllers/Api/   # Auth, menu, commandes
│   ├── Http/Middleware/        # Middleware Bearer token + roles
│   └── Models/                 # User, Restaurant, Category, MenuItem, Order
├── database/
│   ├── migrations/             # Schema relationnel
│   └── seeders/                # Comptes et menu de demonstration
├── routes/api.php              # Endpoints REST
└── tests/Feature/ApiFlowTest.php
```

## Comptes de test

Tous les comptes utilisent le mot de passe `password`.

| Email | Role | Utilisation |
|---|---|---|
| `yassmine@monpf.fr` | client | Parcours client: menu, panier, commande, suivi. |
| `admin@monpf.fr` | admin | Dashboard, stats, commandes, CRUD menu. |
| `serveur@monpf.fr` | serveur | Gestion des commandes cote restaurant. |
| `livreur@monpf.fr` | livreur | File de livraison et acceptation commande. |

## Lancer localement

Depuis la racine du repo:

```powershell
cd mon_pfapi
..\tools\runtime\php-8.4.22\php.exe artisan migrate:fresh --seed
..\tools\runtime\php-8.4.22\php.exe artisan serve --host=0.0.0.0 --port=8000
```

Tester rapidement:

```powershell
Invoke-RestMethod http://127.0.0.1:8000/api/health
Invoke-RestMethod http://127.0.0.1:8000/api/menu
```

## Brancher Flutter

Emulateur Android:

```powershell
flutter run --dart-define=DEMO_MODE=false --dart-define=API_BASE_URL=http://10.0.2.2:8000/api
```

Telephone Android sur le meme Wi-Fi:

```powershell
flutter run --dart-define=DEMO_MODE=false --dart-define=API_BASE_URL=http://ADRESSE_IP_PC:8000/api
```

Windows:

```powershell
flutter run -d windows --dart-define=DEMO_MODE=false --dart-define=API_BASE_URL=http://127.0.0.1:8000/api
```

L'APK release garde une politique reseau stricte. Pour une vraie publication, utiliser une API HTTPS et construire avec:

```powershell
flutter build apk --release --dart-define=DEMO_MODE=false --dart-define=API_BASE_URL=https://votre-domaine/api
```

## Endpoints principaux

| Methode | Endpoint | Role | Description |
|---|---|---|---|
| GET | `/api/health` | public | Verification API. |
| GET | `/api/menu` | public | Categories, plats, restaurant. |
| POST | `/api/register` | public | Cree toujours un compte `client`. |
| POST | `/api/login` | public | Retourne token + utilisateur. |
| POST | `/api/logout` | connecte | Revoque le token. |
| GET | `/api/orders` | connecte | Commandes selon role. |
| POST | `/api/orders` | client | Cree une commande depuis le panier. |
| PATCH | `/api/orders/{order}/status` | admin/serveur/livreur selon statut | Change l'etat de commande. |
| GET | `/api/admin/stats` | admin/serveur | Statistiques dashboard. |
| PATCH | `/api/admin/orders/{order}/assign-driver` | admin/serveur | Affecte un livreur. |
| GET | `/api/driver/orders` | admin/livreur | File de livraison. |
| PATCH | `/api/driver/orders/{order}/accept` | admin/livreur | Accepte une commande. |

## Tests

```powershell
cd mon_pfapi
..\tools\runtime\php-8.4.22\php.exe artisan test
```

Les tests valident:

- catalogue public seedé;
- login avec token;
- inscription publique forcee en role `client`;
- creation commande authentifiee;
- structure JSON attendue par Flutter.
