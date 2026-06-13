# Synthese des exigences

Cette synthese vient des deux documents fournis :

- `cahier-de-charge.pdf`
- `analyse-et-conception-systeme.pdf`

## Problematique

La gestion manuelle des commandes d'un restaurant provoque des erreurs, des
retards de preparation/livraison, une mauvaise communication entre client,
restaurant et livreur, et donc une baisse de satisfaction client.

## Objectif general

Developper une application mobile permettant de digitaliser et optimiser la
gestion des commandes et des livraisons d'un restaurant.

## Acteurs

- Client : consulte le menu, passe une commande et suit sa livraison.
- Administrateur/Gerant : gere les utilisateurs, le menu, les commandes et les
  statistiques.
- Serveur : traite les commandes sur place.
- Livreur : consulte, accepte et met a jour les livraisons.

## Besoins fonctionnels

### Client

- Creer un compte et se connecter.
- Consulter le menu.
- Ajouter des plats au panier.
- Passer une commande.
- Suivre l'etat de la commande.

### Restaurant / Administrateur / Serveur

- Gerer les utilisateurs.
- Gerer le menu : ajout, modification, suppression, disponibilite.
- Recevoir les commandes.
- Mettre a jour l'etat des commandes.
- Affecter une commande a un livreur.
- Consulter les statistiques.

### Livreur

- Se connecter.
- Consulter les commandes a livrer.
- Accepter une livraison.
- Mettre a jour l'etat de livraison.
- Consulter l'historique des livraisons.

## Besoins non fonctionnels

- Securite des donnees et authentification.
- Interface mobile simple et intuitive.
- Rapidite de traitement.
- Fiabilite et synchronisation en temps reel.
- Facile maintenance.

## Regles de gestion

- Une commande ne peut pas etre validee sans plats.
- Une commande livree ne peut plus etre modifiee.

## Modele conceptuel extrait

Les classes principales du diagramme sont :

- `Utilisateur` : id, nom, email, motDePasse.
- `Client` : consulterMenu, ajouterAuPanier, passerCommande, suivreCommande.
- `Administrateur` : gererUtilisateurs, gererMenu, recevoirCommandes,
  mettreAJourEtatCommande, affecterCommande, consulterStatistiques.
- `Livreur` : consulterCommandes, accepterLivraison,
  mettreAJourEtatLivraison, consulterHistorique.
- `Commande` : id, client, plats, etat, livreur.
- `Panier` : plats, ajouterPlat, retirerPlat, calculerTotal.
- `Plat` : id, nom, description, prix.

## Couverture actuelle dans Flutter

- Client : couvert par accueil, menu, panier, commandes, suivi et profil.
- Livreur : couvert par le tableau de bord livreur demo.
- Administrateur : couvert par le tableau de bord admin demo.
- Serveur : represente actuellement dans le flux operationnel/admin, mais peut
  devenir un espace dedie si le projet doit separer les commandes sur place.
