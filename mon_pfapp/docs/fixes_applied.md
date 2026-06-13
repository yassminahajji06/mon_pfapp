# Corrections appliquees

## 1. API en configuration d'environnement

Avant, l'URL API etait codee en dur en HTTP. Maintenant, elle est configurable
avec `--dart-define=API_BASE_URL=...` et la valeur par defaut utilise HTTPS.

Pourquoi : eviter de lier l'application a une seule adresse IP locale et
preparer une configuration plus propre pour la demo ou le deploiement.

## 2. Permissions reseau Android/iOS

Android declare maintenant la permission internet dans le manifest principal.
iOS declare explicitement une politique ATS qui n'autorise pas les chargements
HTTP arbitraires.

Pourquoi : eviter que l'app fonctionne en debug mais echoue en release.

## 3. Suppression du choix de role public

Le champ `Rôle` a ete retire de l'inscription. L'app n'envoie plus `role` au
backend pendant l'inscription.

Pourquoi : un utilisateur public ne doit pas pouvoir choisir `admin` ou
`livreur`. Le backend doit attribuer les roles.

## 4. Stockage securise du token

`SharedPreferences` a ete remplace par `flutter_secure_storage`.

Pourquoi : un token d'authentification est sensible. Il doit etre stocke dans un
emplacement plus adapte que des preferences generales.

## 5. Gestion d'erreurs API

`AuthService` ajoute maintenant :

- timeout ;
- `try/catch` ;
- decodage JSON plus prudent ;
- messages d'erreur propres ;
- deconnexion locale meme si le serveur ne repond pas.

Pourquoi : une app mobile doit rester stable si le reseau tombe ou si le serveur
renvoie une reponse inattendue.

## 6. Cycle de vie Flutter

Les ecrans verifient `mounted` apres les appels asynchrones et liberent les
`TextEditingController` avec `dispose`.

Pourquoi : eviter les erreurs quand un ecran est ferme pendant une requete.

## 7. Tests remplaces

Le test compteur Flutter par defaut a ete remplace par des tests pour :

- l'affichage de l'ecran de connexion ;
- la validation des champs ;
- la navigation vers l'inscription ;
- l'absence du champ role.

Pourquoi : les tests doivent verifier les vraies fonctionnalites du projet.

## 8. Metadata de release

Le nom visible de l'app, les identifiants Android/iOS/Web/Desktop et la README
ont ete adaptes au projet de Yassmine Hajji.

Pourquoi : une application de soutenance ne doit pas garder les valeurs
`com.example` ou `A new Flutter project`.
