# Faire de la place pour passer en Wheezy

Si vous avez conservé les paramètres par défaut lors de l'installation en Squeeze, vous avez une partition racine `/` de 3Go.

Avec le développement de `se3-clients-linux`, les outils d'installation s'accumulent dans le répertoire èè/tftpboot`, et la partition racine `/` devient trop petite pour envisager une migration en toute sérénité.

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
```

Modifier le fichier `/etc/fstab`
Ajouter la ligne suivante à la fin du fichier :
```
/dev/sdb1 /tftpboot     ext3    defaults        0       2
```

Effectuer les montages contenus dans `/etc/fstab` avec la commande `mount -a`

Vérifier que le contenu de `/tftpboot` est bien là :
```
ls -alh /tftpboot
```

## Modifier le partitionnement LVM

### Redimensionner un volume LVM pour disposer d'espace libre

### Soit augmenter la partition racine <code>/</code>

### Soit ajouter une partition <code>/tftpboot</code>