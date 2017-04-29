# Migration de se3-lenny vers se3-wheezy

* [Présentation](#présentation)
* [Procédure](#procédure)
* [Compléments](#compléments)
* [Références](#Références)


## Présentation

On pourrait penser que procéder par étapes, migrer de `se3/Lenny` vers `se3/Squeeze` puis  migrer de `se3/Squeeze` vers `se3/Wheezy`, pourrait convenir. Mais les évolutions sont trop importantes et il faudrait reprendre de façon importante le script de la première migration : ce qui ne sera pas fait pour des raisons évidentes…

D'autant plus qu'une solution fiable existe pour effectuer une migration de votre `se3/Lenny` vers un `se3/Wheezy`. Vous en trouverez les grandes lignes ci-dessous.

Pour les détails, consultez les articles spécifiques à chaque étape de la solution proposée ici.

Vous pouvez aussi consulter la documentation de migration de `se3/Squeeze` vers `se3/Wheezy` (voir les références ci-dessous) pour vous vérifier quelques prérequis avant de passer à `se3/Wheezy` (comme vous installez un `se3/Wheezy`, tous les prérequis ne seront pas nécessaires : la problématique est légérement différente).


## Procédure

* sauvegarde via le script **sauve_se3.sh** (voir la doc pour les détails)
* installer `se3/wheezy` : voir la doc sur GitHub ; il y a plusieurs procédures, manuelles, automatiques,…
* mettre en place les modules comme sur l'ancien `se3` + messagerie + onduleur (voir la doc)
* lancer la restauration via le script **restaure_se3.sh** (idem pour les détails)
* appliquer quelques correctifs (ils ne sont pas encore intégrés au script de restauration) → voir les compléments ci-dessous
* vérifier que tout fonctionne → à préciser…
* remettre en place la sauvegarde via **sauve_se3.sh**
* on peut aussi mettre en place un clonage via clonezilla : voir la doc sur GitHub de même


## Compléments

- Si problème de `SID` sur l’interface web, lancer **correctSID.sh**
- Lancer **update-smbconf.sh**
- Vérifier que le fichier `/etc/samba/smb_Vista.conf` a bien la ligne suivante en bas de la section [netlogon]
```ini
acl allow execute always = True
```


## Références

* Procédure pour migrer [de `se3/squeeze` à `se3/wheezy`](../se3-migration/SqueezeToWheezy.md#migration-de-se3-squeeze-vers-se3-wheezy)
* La documentation pour [les scripts `sauve_se3.sh` et `restaure_se3.sh`](../se3-sauvegarde/sauverestaure.md#sauvegarder-et-restaurer-un-serveur-se3)
* La documentation pour [cloner les disques](../se3-sauvegarde/clonerse3.md#cloner-un-se3) de votre `se3`

