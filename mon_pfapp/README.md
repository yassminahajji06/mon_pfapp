# Mon PF App

Application Flutter de restauration et livraison preparee pour le projet de fin
d'annee de Yassmine Hajji dans la filiere developpement d'applications.

## Objectif

L'application couvre maintenant un parcours complet de demonstration :

- connexion utilisateur ;
- creation de compte client ;
- stockage securise du jeton d'authentification ;
- accueil client avec categories et plats populaires ;
- menu filtrable ;
- panier avec quantites et total ;
- suivi de livraison ;
- historique des commandes ;
- profil utilisateur ;
- tableau de bord livreur ;
- tableau de bord administrateur ;
- deconnexion.

## Configuration rapide

Installer les dependances :

```bash
flutter pub get
```

Lancer l'application avec l'URL de l'API :

```bash
flutter run --dart-define=API_BASE_URL=https://votre-domaine/api
```

Par defaut, `DEMO_MODE` vaut `true`. Cela permet de tester toute l'interface
sans backend :

```bash
flutter run
```

Pour brancher le vrai backend :

```bash
flutter run --dart-define=DEMO_MODE=false --dart-define=API_BASE_URL=https://votre-domaine/api
```

## Backend attendu

L'app attend une API REST avec ces routes :

- `POST /register`
- `POST /login`
- `POST /logout`

Les reponses de connexion et d'inscription doivent retourner un `token` et un
objet `user` contenant au minimum `id`, `nom`, `email` et `role`.

## Documentation projet

Les fichiers dans `docs/` expliquent les corrections appliquees et comment les
presenter :

- `docs/project_context.md`
- `docs/auth_flow.md`
- `docs/fixes_applied.md`
- `docs/setup_and_release.md`
- `docs/testing_guide.md`
- `docs/app_walkthrough.md`
- `docs/README.md`

## Verification

```bash
flutter analyze
flutter test
```

Dans cet environnement Codex, Flutter n'etait pas disponible sur le PATH, donc
ces commandes doivent etre executees sur la machine de developpement Flutter.
