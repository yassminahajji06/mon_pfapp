# Guide Demo-Prod - Mon PF App

Ce runbook donne les actions rapides pour presenter l'application comme produit presque final pendant la soutenance.

## 1. Demarrer l'API

```powershell
cd C:\Users\LOQ\Documents\yassmin pfe\mon_pfapi
..\tools\runtime\php-8.4.22\php.exe artisan migrate:fresh --seed
..\tools\runtime\php-8.4.22\php.exe artisan serve --host=0.0.0.0 --port=8000
```

Garder cette fenetre ouverte.

## 2. Tester l'API

```powershell
Invoke-RestMethod http://127.0.0.1:8000/api/health
Invoke-RestMethod http://127.0.0.1:8000/api/menu
```

## 3. Lancer Flutter en mode backend reel

Sur Windows:

```powershell
cd C:\Users\LOQ\Documents\yassmin pfe\mon_pfapp
flutter run -d windows --dart-define=DEMO_MODE=false --dart-define=API_BASE_URL=http://127.0.0.1:8000/api
```

Sur Web Chrome:

```powershell
cd C:\Users\LOQ\Documents\yassmin pfe\mon_pfapp
flutter run -d chrome --web-port=5600 --dart-define=DEMO_MODE=false --dart-define=API_BASE_URL=http://127.0.0.1:8000/api
```

Le backend active CORS pour `api/*` afin que Flutter Web puisse appeler l'API locale pendant la demonstration.

Sur telephone Android connecte au meme Wi-Fi:

```powershell
flutter run -d <device-id> --dart-define=DEMO_MODE=false --dart-define=API_BASE_URL=http://ADRESSE_IP_PC:8000/api
```

APK debug deja construit pour l'API locale de cette machine:

```text
C:\Users\LOQ\Documents\yassmin pfe\mon_pfapp\build\app\outputs\flutter-apk\app-debug.apk
```

Il pointe vers:

```text
http://172.17.182.162:8000/api
```

Si l'adresse IP Wi-Fi change, reconstruire l'APK debug avec la nouvelle adresse.

Trouver l'adresse IP du PC:

```powershell
ipconfig
```

Utiliser l'IPv4 du Wi-Fi, par exemple `http://192.168.1.20:8000/api`.

## 4. Scenario de demonstration

1. Se connecter avec `yassmine@monpf.fr` / `password`.
2. Consulter le menu et ajouter des plats au panier.
3. Passer la commande.
4. Ouvrir le suivi et montrer le statut.
5. Se connecter avec `admin@monpf.fr` / `password` pour montrer les statistiques et commandes.
6. Se connecter avec `livreur@monpf.fr` / `password` pour accepter une livraison.

## 5. Commandes de validation

Backend:

```powershell
cd C:\Users\LOQ\Documents\yassmin pfe\mon_pfapi
..\tools\runtime\php-8.4.22\php.exe artisan test
```

Flutter:

```powershell
cd C:\Users\LOQ\Documents\yassmin pfe\mon_pfapp
C:\Users\LOQ\dev\flutter\bin\flutter.bat test
C:\Users\LOQ\dev\flutter\bin\cache\dart-sdk\bin\dart.exe analyze
```

## 6. Ce qui est demo-prod

- UI Flutter moderne avec logo et images de plats.
- Authentification reliee a une API.
- Roles imposes cote backend.
- Menu et commandes stockes en base SQLite.
- Creation commande reelle via API.
- Dashboard admin et espace livreur connectables.
- Tests backend et Flutter.

## 7. Ce qui reste pour vraie production

- Heberger l'API sur un domaine HTTPS.
- Remplacer SQLite par MySQL/PostgreSQL heberge.
- Ajouter Laravel Sanctum.
- Ajouter notifications push.
- Ajouter paiement en ligne si requis.
- Mettre un pipeline CI/CD.

## 8. Windows

Le build Windows est bloque tant que le composant Visual Studio ATL n'est pas installe.

Erreur observee:

```text
fatal error C1083: Impossible d'ouvrir le fichier include : 'atlstr.h'
```

Action a faire dans Visual Studio Installer:

1. Ouvrir Visual Studio Installer.
2. Modifier `Visual Studio Community 2026`.
3. Dans les composants individuels, chercher `ATL`.
4. Installer `C++ ATL for latest v143/v14x build tools` ou le composant equivalent disponible.
5. Relancer:

```powershell
cd C:\Users\LOQ\Documents\yassmin pfe\mon_pfapp
flutter build windows --debug --dart-define=DEMO_MODE=false --dart-define=API_BASE_URL=http://127.0.0.1:8000/api
```
