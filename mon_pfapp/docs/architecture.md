# Architecture de l'application Flutter

L'application est structuree pour suivre les acteurs et cas d'utilisation du
cahier de charge.

## Organisation de `lib/`

```text
lib/
├── app/                     # Demarrage, theme, navigation simple et etat demo
├── core/                    # Constantes, stockage securise, validateurs
├── data/                    # Donnees demo utilisees sans backend
├── domain/models/           # Modeles metier : User, Plat, Panier, Commande
├── features/
│   ├── auth/                # Connexion et inscription
│   ├── client/              # Menu, panier, suivi, commandes, profil
│   └── operations/          # Tableaux admin et livreur
└── shared/widgets/          # Composants UI reutilisables
```

## Correspondance avec les documents

- `Client` : `features/client/presentation`.
- `Administrateur` : `features/operations/presentation/admin_dashboard_screen.dart`.
- `Livreur` : `features/operations/presentation/driver_dashboard_screen.dart`.
- `Commande`, `Panier`, `Plat` : `domain/models`.
- Authentification et securite : `features/auth` et `core/storage.dart`.

## Mode demo

`DEMO_MODE` vaut `true` par defaut. Ce mode permet de presenter tous les ecrans
sans attendre le backend Laravel/MySQL.

Pour utiliser le backend reel :

```bash
flutter run --dart-define=DEMO_MODE=false --dart-define=API_BASE_URL=https://votre-domaine/api
```

## Evolutions conseillees

- Ajouter un espace `Serveur` separe si la soutenance demande de distinguer les
  commandes sur place des commandes livraison.
- Brancher `Menu`, `Commande` et `Livreur` sur l'API Laravel.
- Remplacer les donnees demo par des repositories/API clients.
- Ajouter des tests de service lorsque le backend sera stable.
