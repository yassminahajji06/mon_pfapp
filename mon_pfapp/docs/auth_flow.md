# Flux d'authentification

## Connexion

1. L'utilisateur saisit son email et son mot de passe dans `LoginScreen`.
2. Les champs sont valides localement avec `Validators`.
3. `AuthService.login` envoie une requete `POST /login`.
4. Le backend retourne un `token` et un objet `user`.
5. En mode backend reel, le token et le role sont sauvegardes avec `Storage`.
6. En mode demo, l'app utilise un utilisateur local pour faciliter les tests.
7. L'app ouvre `HomeScreen`.

## Inscription

1. L'utilisateur saisit son nom, email et mot de passe dans `RegisterScreen`.
2. Le role n'est plus choisi dans l'application.
3. `AuthService.register` envoie `nom`, `email` et `mot_de_passe`.
4. Le backend decide le role. Pour une inscription publique, le role attendu
   est normalement `client`.
5. Si l'inscription reussit, l'app ouvre `HomeScreen`.

## Deconnexion

1. `HomeScreen` appelle `AuthService.logout`.
2. L'app tente d'appeler `POST /logout` avec le token.
3. Meme si le backend ne repond pas, le token local est supprime.
4. L'app retourne vers `LoginScreen`.

## Fichiers principaux

- `lib/screens/login_screen.dart` : formulaire de connexion.
- `lib/screens/register_screen.dart` : formulaire d'inscription client.
- `lib/screens/home_screen.dart` : accueil client apres authentification.
- `lib/screens/menu_screen.dart` : menu filtrable.
- `lib/screens/cart_screen.dart` : panier.
- `lib/screens/tracking_screen.dart` : suivi de livraison.
- `lib/screens/orders_screen.dart` : historique des commandes.
- `lib/screens/driver_dashboard_screen.dart` : espace livreur.
- `lib/screens/admin_dashboard_screen.dart` : administration.
- `lib/services/auth_service.dart` : appels API et traitement des erreurs.
- `lib/core/storage.dart` : stockage securise du token.
- `lib/core/constants.dart` : configuration API.
- `lib/core/validators.dart` : regles de validation des champs.
