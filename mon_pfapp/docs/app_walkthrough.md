# Parcours de demonstration

Ce fichier explique comment tester l'application complete apres l'integration
des maquettes.

## Mode demo

Le mode demo est actif par defaut grace a `DEMO_MODE=true`. Il permet de tester
l'application sans backend.

Identifiants affiches sur l'ecran de connexion :

- email : `yassmine@monpf.fr`
- mot de passe : `demo123`

## Parcours client

1. Ouvrir l'application.
2. Appuyer sur `Se connecter`.
3. Arriver sur l'accueil client.
4. Changer de categorie pour filtrer les plats.
5. Appuyer sur `Voir tout` pour ouvrir le menu.
6. Ajouter un plat au panier.
7. Ouvrir `Panier`.
8. Modifier les quantites.
9. Appuyer sur `Passer la commande`.
10. Consulter le suivi de livraison.

## Commandes

L'onglet `Commandes` affiche :

- une commande active ;
- un bouton `Suivre` ;
- l'historique des commandes recentes.

## Profil

L'onglet `Profil` affiche :

- les informations de Yassmine ;
- des statistiques client ;
- les commandes recentes ;
- des parametres ;
- la deconnexion.

## Espace livreur

Depuis l'accueil ou le profil, ouvrir `Livreur`.

Fonctionnalites disponibles :

- passer en ligne/hors ligne ;
- voir les statistiques du jour ;
- consulter les nouvelles commandes ;
- accepter une commande.

## Administration

Depuis l'accueil ou le profil, ouvrir `Admin` ou `Administration`.

Fonctionnalites disponibles :

- indicateurs de performance ;
- graphique hebdomadaire simplifie ;
- liste des commandes ;
- liste de l'equipe.

## Espace serveur

Le cahier de charge mentionne aussi un acteur `Serveur` pour les commandes sur
place. Dans la version Flutter actuelle, ce besoin est represente par le flux
operationnel/admin. Il peut devenir un onglet ou un ecran separe si la
presentation exige une separation stricte des roles.

## Choix de securite conserve

La maquette proposait un choix de role pendant l'inscription. Dans l'application
Flutter, ce choix n'a pas ete restaure. L'inscription publique reste limitee au
client, et les roles `livreur` ou `admin` doivent etre attribues par le backend
ou par une interface d'administration.
