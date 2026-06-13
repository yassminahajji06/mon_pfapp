# Configuration, lancement et release

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

## Android

L'identifiant Android est :

```text
ma.yassminehajji.monpfapp
```

Le build release n'utilise plus la cle debug. Avant de partager un APK final, il
faut creer une vraie cle de signature Android et configurer Gradle.

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
