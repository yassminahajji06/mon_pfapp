# Mon PF API

Backend Laravel de l'application Mon PF App.

## Role

Cette API fournit les donnees persistantes de la demo-prod:

- authentification par token;
- roles `client`, `admin`, `serveur`, `livreur`;
- menu restaurant;
- creation et historique de commandes;
- statistiques administrateur;
- file de livraison.

## Lancement local

Depuis ce dossier:

```powershell
..\tools\runtime\php-8.4.22\php.exe artisan migrate:fresh --seed
..\tools\runtime\php-8.4.22\php.exe artisan serve --host=0.0.0.0 --port=8000
```

## Tests

```powershell
..\tools\runtime\php-8.4.22\php.exe artisan test
```

## Comptes de demo

Mot de passe commun: `password`.

| Email | Role |
|---|---|
| `yassmine@monpf.fr` | client |
| `admin@monpf.fr` | admin |
| `serveur@monpf.fr` | serveur |
| `livreur@monpf.fr` | livreur |

## Endpoints

Voir [../docs/backend-api.md](../docs/backend-api.md).
