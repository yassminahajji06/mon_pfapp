# Guide de tests

## Commandes

```bash
flutter analyze
flutter test
```

## Tests existants

Le fichier `test/widget_test.dart` verifie maintenant :

- que `MyApp` demarre sur l'ecran de connexion inspire de la maquette ;
- que la connexion demo ouvre l'accueil client ;
- que le menu, le panier et le suivi sont atteignables ;
- que les espaces livreur et admin sont atteignables ;
- que le champ `Rôle` n'existe plus dans l'inscription publique.

## Tests a ajouter plus tard

Quand le backend ou une couche de mock sera disponible, ajouter :

- test de connexion reussie ;
- test d'echec de connexion ;
- test d'inscription reussie ;
- test de timeout API ;
- test de deconnexion ;
- test de reprise de session si un token existe.

## Pourquoi ces tests comptent

Pour une soutenance, les tests montrent que le projet n'est pas seulement une UI
statique. Ils prouvent que les parcours principaux sont verifies de maniere
automatique.
