# Installation d'Owncloud 9 (9.0 ou 9.1) sur un serveur Samba Edu 3

## Introduction :

Cette documentation décrit l'intégration d'un serveur `Owncloud 9` sur un serveur `Samba Edu 3` sous `Debian Wheezy`.
Depuis la version 9 d'owncloud, les dépôts d'Owncloud séparent la partie "serveur web" de la partie "fichiers owncloud" en deux paquets distincts
afin de pouvoir intégrer d'Owncloud 9 à un serveur web déjà existant (et plus ancien que celui recommandé pour Owncloud 9) : il est ainsi possible
d'installer Owncloud 9 sur un serveur Debian Wheezy (et sa version 5.4 de PHP).

## Pourquoi intégrer Owncloud 9 à un serveur se3 ?

Owncloud permet (en autre) :
* de rendre accessible depuis l'extérieur de l'établissement les partages Samba de l'utilisateur.
* mettre à disposition de chaque utilisateur un repertoire Cloud accessible à partir de n'importe quel navigateur Web et permettant de faire très 
simplement du partage de document.


Intégrer directement Owncloud à un serveur se3 évite : 
* la maintenance de plusieurs serveurs.
* facilite l'installation d'Owncloud ainsi que la configuration.


## Pre-requis

* Le  **serveur Se3 doit être sous Debian Wheezy**.
* Il doit disposer sur sa partition /var/se3 d'au moins (100 Mo * Nombre d'utilisateurs) soit environ 100 Go pour un établissement comptant 1000 utilisateurs.
* Pour autoriser à faire du partage entre membre d'un meme cours, cocher la création des groupes de cours pendant l'importation des comptes utilisateurs faites en début d'année.

## Intégration d'Owncloud au se3.

* Se connecter au serveur SE3 en tant que root (en ssh par exemple).
* Rendre le script suivant executable :

```sh
chmod u+x /home/netlogon/clients-linux/owncloud/integrer_owncloud_sur_se3.sh 
```

* Puis l'exécuter. Par exemple, pour installer la version 9.0 d'Owncloud, saisir :
```sh
/home/netlogon/clients-linux/owncloud/integrer_owncloud_sur_se3.sh 9.0
```

ou, pour installer la version 9.1 d'Owncloud :
```sh
/home/netlogon/clients-linux/owncloud/integrer_owncloud_sur_se3.sh 9.1
```

L'installation est complétement automatique et ne dure que quelques minutes. Elle essaie d'être, dans la mesure du possible, 
le plus "fidèle" aux recommendations de la documentation officielle d'Owncloud :

[Documentation officielle d'Owncloud](https://doc.owncloud.org/server/9.0/admin_manual/)

ainsi qu'à l'article wiki suivant :

[Wiki de le DANE de Versailles](http://wiki.dane.ac-versailles.fr/index.php?title=Installer_un_serveur_owncloud_8_avec_l%27annuaire_du_se3)

**Remarque:**

Lorsque aucun paramètre n'est spécifié au script précédent, ce dernier installe par défaut la `dernière version stable` des dépôts d'Owncloud.
Le script a été testé avec les `versions 9.0 et 9.1` d'Owncloud. Il est donc **déconseillé** de lancer le script sur une version > 9.1, `sans avoir au préalable 
testé que le script était fonctionnel (sous machine virtuelle par exemple)`.

## Que fait le script d'installation ?

Le script d'installation précédent va :
* installer les `paquets` nécessaires à `owncloud 9` et à son module `stockage externe CIFS/SMB`.
* ajoute le fichier de configuration d'Owncloud 9 `/etc/apache2/sites-available/owncloud.conf` au serveur Apache2 du se3.
* configurer le module stockage externe pour rendre accessible de l'extérieur de l'établissement deux `partages Samba` 
du se3 : `Docs` et `Classes`.
* créer un répertoire `Cloud` pour les utilisateurs afin qu'ils puissent stocker des documents et les partager avec 
des membres d'un même cours (ou matière pour les enseignants). Le quota par utilisateur a été fixé par défaut à 100 Mo.
(ce paramètre est réglable via l'interface web d'administration d'Owncloud)
* déplacer le repertoire `data` d'Owncloud dans `/var/se3/dataOC` afin d'avoir plus d'espace de stockage 
et de profiter d'un (éventuel) dispositif de sauvegarde mise en place sur le se3. Ce repertoire `data`
contiendra toutes les données stockées par les utilisateurs dans leur repertoire `Cloud`
* Créer deux scripts sur le se3, déposés tout deux à l'endroit suivant :
`/usr/share/se3/scripts/`

Le premier script `mettre_droits_sur_data_owncloud.sh` ressere les droits sur le repertoire /var/www/owncloud selon les recommandations de la
documentation officielle d'Owncloud 9.

Le 2d script `upgrade_owncloud.sh` permet de mettre à jour Owncloud 9 vers une version supérieure. 
Par exemple, si la version 9.0 est installée sur le se3 et que la version 9.1 est disponible dans les depôts d'Owncloud, 
la mise à jour peut être faite en lançant le script suivant :

`/usr/share/se3/scripts/upgrade_owncloud.sh 9.1`

**Remarques:**

* Il est **déconseillé** de mettre à jour owncloud vers une version supérieure sans avoir `au préalable` testé (sur machine virtuelle par exemple)
qu'elle se déroulait convenablement , sous peine de perdre son serveur Owncloud ... Le script de mise à jour précédent a été testé uniquement 
pour une migration de la version 9.0 vers la version 9.1 d'Owncloud.

* Owncloud ne compatibilise pas l'espace de stockage consommé par l'utilisateur dans `Docs` et `Classes` : le
quota de 100 Mo alloué par défaut ne concerne que son repertoire `Cloud`.

## Que faire après l'installation ?

Pour vérifier que tout est fonctionnel :
* Se connecter via un navigateur web à l'url suivante :
```sh
http://IP_DU_SE3/owncloud
```
* Saisir les identifiants du compte admin de l'interface web du se3.
* Depuis la fenêtre d'administration, personnaliser Owncloud 9 : ajouter/configurer d'autres partages Samba du se3, 
augmenter le quota des utilisateurs (mis par défaut à 100 Mo), ...
* Se déconnecter du compte admin puis s'identifier avec un compte (Prof ou Eleve) de l'annuaire ldap du se3 et 
vérifier l'accès en lecture/écriture aux partages Docs et Classes du se3 ainsi qu'au repertoire Cloud.
* Tester les fonctionnalités de `partage entre membre d'un même groupe` offerte par Owncloud sur le repertoire `Cloud`.
(Cette fonctionnalité n'est pas disponible sur les partage `Docs` et `Classes` du module stockage externe).

Si tout est fonctionnel en interne à l'adresse `http://IP_DU_SE3/owncloud`, faire une demande pour activer 
le reverse proxy de la passerelle du réseau (ticket cariina pour un serveur Amon). Lors de cette demande, indiquer 
que votre serveur Owncloud est accessible sur le réseau pédagogique en `http` à l'adresse `http://IP_DU_SE3/owncloud`.

Une fois cette activation réalisée, votre serveur owncloud sera accessible de l'`extérieur de l'établissement` à 
une adresse du type :

`https://lpo-RNE.ac-versailles.fr/owncloud`

