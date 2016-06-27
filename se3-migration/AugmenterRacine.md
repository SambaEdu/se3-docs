# Faire de la place pour passer en Wheezy

Si vous avez conservé les paramètres par défaut lors de l'installation en Squeeze, vous avez une partition racine `/` de 3Go.

Avec le développement de `se3-clients-linux`, les outils d'installation s'accumulent dans le répertoire èè/tftpboot`, et la partition racine `/` devient trop petite pour envisager une migration en toute sérénité.

La commande `df -h` ou l'affichage de l'occupation des disques dans l'interface web pourra vous aider à voir où vous en êtes...

Plusieurs solutions peuvent être envisagées.

Si votre installation utilise LVM, il est possible de modifier la répartition des différents volumes pour augmenter la taille de la partition racine `/`, voire d'ajouter une partition spécifique pour `/tftpboot` distincte.

Si votre utilisation n'utilise pas LVM, ou si vous trouvez cela plus simple, l'autre solution est d'ajouter un disque physique, et de l'utiliser pour y placer le répertoire `/tftpbootè`.

## Ajouter un disque physique pour déplacer <code>/tftpboot</code> et son contenu

Cette procédure nécessite à priori d'éteindre le serveur, d'y ajouter un disque physique, puis de redémarrer le serveur. Ce disque n'a pas besoin d'être d'un volume important. À la limite, une clé USB branchée sur un port interne pourrait suffire !

### Repérer le nouveau disque

La commande `fdisk -l` devrait vous indiquer le nom du disque ajouté. À priori, si vous n'aviez qu'un seul disque, cela devrait être `/dev/sdb`.

### Créer une partition sur l'ensemble du disque

Si ce n'est pas déjà le cas, créer une partition primaire occupant la totalité du disque : `fdisk /dev/sdb` puis répondre aux questions.

Formater cette partition en ext3 : `mkfs.ext3 /dev/sdb1`

Monter ce disque provisoirement dans `/mnt/disque` :
```
mkdir /mnt/disque
mount /dev/sdb1 /mnt/disque

```

Déplacer le contenu de /tftpboot sur ce nouveau disque :
```
mv /tftpboot/* /mnt/disque
```

Vérifier que `/tftpboot` est vide :
```
ls -alh /tftpboot
```

Démonter le disque :
```
umount /mnt/disque
rmdir /mnt/disque
```

Modifier le fichier `/etc/fstab` en ajoutant la ligne suivante à la fin du fichier :
```
/dev/sdb1 /tftpboot     ext3    defaults        0       2
```

Effectuer les montages contenus dans `/etc/fstab` avec la commande `mount -a`

Vérifier que le contenu de `/tftpboot` est bien là :
```
ls -alh /tftpboot
```

Et voilà ! Un petit coup de `df -h` pour vérifier que `/` a plus de place, et vous pouvez respirer !

## Modifier le partitionnement LVM

Si vous utilisez LVM, il est possible de modifier la répartition de l'espace entre les différentes partitions faisant partie du groupe de volume. Pour bien comprendre de quoi il s'agit, il est vivement conseillé de bien connaître ce qu'est et ce que permet LVM <https://doc.ubuntu-fr.org/lvm>.

Il demeure un problème de taille toutefois. En effet, si la réduction de la taille d'un systeme de fichier ext3 est possible, la réduction de la tailler d'un système de fichier xfs n'est pas possible. Or il y a de fortes chances que vous souhaitiez rogner sur votre partition `/home` ou `/var/se3`, qui sont en xfs, pour augmenter la racine ou créer une partition dédiée à `/tftpboot`.

La solution consistera à :
* créer un dump de la partition `/home` ou `/var/se3` sur un disque externe d'un volume suffisant,
* réduire la taille du volume contenant `/home` ou `/var/se3`,
* formater le nouveau volume en xfs,
* restaurer le dump,
* utiliser l'espace libéré comme on le souhaite.

### Redimensionner un volume LVM pour disposer d'espace libre

### Soit augmenter la partition racine <code>/</code>

### Soit ajouter une partition <code>/tftpboot</code>