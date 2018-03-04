# Augmenter l’espace dévolu aux "homes" en changeant un disque dur

* [Introduction](#introduction)
* [Installation du disque dans la machine](#installation-du-disque-dans-la-machine)
* [Préparation du disque](#préparation-du-disque)

## Introduction

L’espace dévolu aux données des utilisateurs est devenu trop étroit. Vous avez acheté un beau disque dur tout neuf de 2 To. Comment l’installer ?

Tout d’abord, il faut bien comprendre que vous n’allez pas étendre l’espace des homes mais copier ce qui existe vers un espace plus grand. La partition actuellement dévolue aux données des utilisateurs sera inutilisée à l’issue de cette manipulation.

## Installation du disque dans la machine

* Installer physiquement le disque dur dans le serveur avec votre meilleur tournevis.

* Redémarrer le serveur. Dans les messages de démarrage, on doit voir apparaître le nouveau disque avec son nom (/dev/sdb par exemple, si le premier disque se nomme /dev/sda)

## Préparation du disque

* Vérifier l’état du disque en utilisant par exemple la commande cfdisk :

```sh
cfdisk /dev/sdb
```

* Créer une nouvelle partition en utilisant le menu de l’application ("new" pour créer la partition, "write" pour sauvegarder les changements et enfin "quit" pour sortir de l’application).

* Quitter cfdisk et retourner en mode console pour formater en XFS la partition nouvellement créée :

```sh
mkfs.xfs /dev/sdb1
```

* Créer un point de montage /home2 pour la nouvelle partition :

```sh
mkdir /home2
```

* Monter la nouvelle partition sur son point de montage :

```sh
mount -t xfs /dev/sdb1 /home2
```

* Copier le contenu de /home dans home2

```sh
cp -R /home/* /home2
```

* Modifier le fichier /etc/fstab pour qu’au démarrage la nouvelle partition soit montée sur home à la place de l’ancienne en remplaçant l'UUID de l'ancien disque par celui du nouveau.

>La commande blkid en root donne en réponse la liste de toutes les partitions montées, ainsi que leurs UUIDs, labels et type de partition.

```sh
blkid
```
Retour type de la commande :

```sh
/dev/sda1: UUID="8bf33340-e94c-4c4c-981d-35e73f8bc65c" TYPE="ext4" 
/dev/sda2: UUID="ac56a704-260b-45f5-85ac-e1b451bb79bc" TYPE="swap" 
/dev/sda3: LABEL="Home" UUID="8244710a-5cce-49ad-8b93-a92b5d2e53a0" TYPE="ext4" 
/dev/sda4: UUID="DCF041AFF0419126" TYPE="ntfs" 
```

* Rebooter le serveur.

* Après le redémarrage du serveur, pensez à remettre les droits corrects des utilisateurs sur leurs fichiers. Pour ce faire, dans l’interface web de se3, connecté en admin, utiliser dans "Informations système" "Corrections de problèmes" "Remise en place des droits sur les comptes utilisateurs". Attention, selon le nombre d’utilisateurs, ça peut être un peu long.
