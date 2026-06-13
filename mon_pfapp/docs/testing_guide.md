# Guide de tests

## Commandes

```bash
flutter analyze
flutter test
```

Commandes exactes validees sur cette machine :

```powershell
cd "C:\Users\LOQ\Documents\yassmin pfe\mon_pfapp"
& "$env:USERPROFILE\dev\flutter\bin\cache\dart-sdk\bin\dart.exe" analyze
& "$env:USERPROFILE\dev\flutter\bin\flutter.bat" test
```

Resultat du 13 Juin 2026 :

- `dart analyze` : aucun probleme ;
- `flutter test` : 5 tests passent.
- `flutter doctor -v` : aucun probleme ;
- Android release APK : construit et signe ;
- Windows release : bloque par le composant Visual C++ ATL manquant.

Pour visualiser l'application :

```powershell
& "$env:USERPROFILE\dev\flutter\bin\flutter.bat" run -d chrome --web-port 57321
```

Puis ouvrir :

```text
http://localhost:57321
```

Pour visualiser le build release :

```powershell
& "$env:USERPROFILE\dev\flutter\bin\flutter.bat" build web --release --dart-define=DEMO_MODE=true
python -m http.server 57321 --directory build\web
```

Pour tester Android sur telephone :

```powershell
C:\Users\LOQ\AppData\Local\Android\Sdk\platform-tools\adb.exe devices
C:\Users\LOQ\AppData\Local\Android\Sdk\platform-tools\adb.exe install -r build\app\outputs\flutter-apk\app-release.apk
```

Si le telephone affiche une alerte de securite, accepter l'installation depuis
le gestionnaire de fichiers ou l'outil de debug uniquement pour ce test.

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

## Parcours manuel conseille

1. Ouvrir l'ecran de connexion et verifier le style de la maquette.
2. Cliquer sur `Se connecter` pour entrer en mode demo client.
3. Ouvrir le menu, filtrer une categorie et ajouter un plat au panier.
4. Ouvrir le panier, changer les quantites et passer la commande.
5. Verifier l'ecran de suivi de livraison.
6. Ouvrir le profil, puis les espaces `Livreur` et `Administration`.
7. Verifier que l'inscription publique ne propose jamais le choix du role.
