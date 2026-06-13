# Configuration, lancement et release

## Etat valide le 13 Juin 2026

Ces commandes ont ete validees sur cette machine :

```powershell
& "$env:USERPROFILE\dev\flutter\bin\cache\dart-sdk\bin\dart.exe" analyze
& "$env:USERPROFILE\dev\flutter\bin\flutter.bat" test
& "$env:USERPROFILE\dev\flutter\bin\flutter.bat" devices
```

Resultat actuel :

- analyse statique : aucun probleme ;
- tests widgets : tous les tests passent ;
- appareils disponibles : Windows, Chrome, Edge ;
- Android SDK/NDK : installes et valides ;
- APK Android release : construit et signe localement ;
- Windows release : bloque tant que le composant Visual C++ ATL manque.

## Installation

```bash
flutter pub get
```

Cette commande est necessaire apres l'ajout de `flutter_secure_storage`.
Elle mettra aussi a jour `pubspec.lock` et les fichiers de plugins generes.
Si `shared_preferences` apparait encore dans un fichier genere avant cette
commande, c'est simplement l'ancien etat du projet.

## Lancer avec une API

```bash
flutter run --dart-define=API_BASE_URL=https://votre-domaine/api
```

## Lancer en mode demo

Le mode demo est actif par defaut. Il permet de tester tous les ecrans sans API :

```bash
flutter run
```

Sur cette machine, le lancement web rapide est :

```powershell
cd "C:\Users\LOQ\Documents\yassmin pfe\mon_pfapp"
& "$env:USERPROFILE\dev\flutter\bin\flutter.bat" run -d chrome --web-port 57321
```

URL de test locale :

```text
http://localhost:57321
```

Pour forcer le mode backend reel :

```bash
flutter run --dart-define=DEMO_MODE=false --dart-define=API_BASE_URL=https://votre-domaine/api
```

Pour Android emulator, iOS simulator ou telephone physique, l'URL doit etre
accessible depuis l'appareil. Une IP `localhost` sur le PC ne represente pas le
meme appareil cote mobile.

## HTTPS

La configuration actuelle privilegie HTTPS. Pour une soutenance, il est mieux
d'exposer le backend via une URL HTTPS temporaire ou officielle.

Exemples possibles :

- domaine de test avec certificat TLS ;
- tunnel HTTPS de demonstration ;
- serveur deploye sur un hebergeur.

Pour une release branchee au backend Laravel :

```powershell
& "$env:USERPROFILE\dev\flutter\bin\flutter.bat" build web --release --dart-define=DEMO_MODE=false --dart-define=API_BASE_URL=https://votre-domaine/api
```

Pour une demo de soutenance sans backend :

```powershell
& "$env:USERPROFILE\dev\flutter\bin\flutter.bat" build web --release --dart-define=DEMO_MODE=true
```

Le dossier a deployer sur Netlify, Vercel, Firebase Hosting ou un serveur web
statique est :

```text
mon_pfapp/build/web
```

Pour tester ce build en local comme un site statique :

```powershell
cd "C:\Users\LOQ\Documents\yassmin pfe\mon_pfapp"
python -m http.server 57321 --directory build\web
```

Puis ouvrir :

```text
http://localhost:57321
```

## Android

L'identifiant Android est :

```text
ma.yassminehajji.monpfapp
```

Le build release utilise une cle locale :

```text
android/app/upload-keystore.jks
android/key.properties
```

Ces fichiers sont ignores par Git et ne doivent pas etre publies sur GitHub.
Pour regenerer un APK release de demonstration :

```powershell
cd "C:\Users\LOQ\Documents\yassmin pfe\mon_pfapp"
& "$env:USERPROFILE\dev\flutter\bin\flutter.bat" build apk --release --dart-define=DEMO_MODE=true
```

APK signe obtenu :

```text
build/app/outputs/flutter-apk/app-release.apk
```

APK debug de test :

```text
build/app/outputs/flutter-apk/app-debug.apk
```

Pour installer sur un telephone Android branche en USB :

```powershell
C:\Users\LOQ\AppData\Local\Android\Sdk\platform-tools\adb.exe devices
C:\Users\LOQ\AppData\Local\Android\Sdk\platform-tools\adb.exe install -r build\app\outputs\flutter-apk\app-release.apk
```

Si Android refuse l'installation a cause d'une ancienne signature :

```powershell
C:\Users\LOQ\AppData\Local\Android\Sdk\platform-tools\adb.exe uninstall ma.yassminehajji.monpfapp
C:\Users\LOQ\AppData\Local\Android\Sdk\platform-tools\adb.exe install build\app\outputs\flutter-apk\app-release.apk
```

Avant cela, activer `Options developpeur` puis `Debogage USB` sur le telephone,
et accepter la demande RSA affichee sur l'appareil.

## Windows

La toolchain Windows Flutter est detectee par `flutter doctor`, mais le build
Windows est bloque par ce fichier manquant :

```text
atlstr.h
```

Ce fichier vient du composant Visual Studio :

```text
Microsoft.VisualStudio.Component.VC.ATL
```

Action manuelle a faire :

1. Ouvrir `Visual Studio Installer` en administrateur.
2. Modifier `Visual Studio Build Tools 2019`.
3. Installer `Desktop development with C++`.
4. Dans `Individual components`, cocher `C++ ATL for latest v142 build tools`.
5. Appliquer les modifications.

Verification :

```powershell
Get-ChildItem "C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools" -Recurse -Filter atlstr.h
& "$env:USERPROFILE\dev\flutter\bin\flutter.bat" build windows --release
```

Sortie attendue apres correction :

```text
build/windows/x64/runner/Release/mon_pfapp.exe
```

## iOS

L'identifiant iOS est :

```text
ma.yassminehajji.monpfapp
```

Le projet bloque les chargements HTTP arbitraires. Utiliser HTTPS pour eviter
les erreurs reseau.

## Elements visuels non modifies

Les icones et le style global n'ont pas ete remplaces. Ce point doit attendre
les maquettes Figma ou les images de style choisies.
