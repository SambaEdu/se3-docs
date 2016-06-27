# Faire de la place pour passer en Wheezy

Si vous avez conservé les paramètres par défaut lors de l'installation en Squeeze, vous avez une partition racine <code>/</code> de 3Go.

Avec le développement de <code>se3-clients-linux</code>, les outils d'installation s'accumulent dans le répertoire <code>/tftpboot</code>, et la partition racine <code>/</code> devient trop petite pour envisager une migration en toute sérénité.

Plusieurs solutions peuvent être envisagées.

Si votre installation utilise LVM, il est possible de modifier la répartition des différents volumes pour augmenter la taille de la partition racine <code>/</code>, voire d'ajouter une partition spécifique pour <code>/tftpboot</code> distincte.

Si votre utilisation n'utilise pas LVM, ou si vous trouvez cela plus simple, l'autre solution est d'ajouter un disque physique, et de l'utiliser pour y placer le répertoire <code>/tftpboot</code>.

## Ajouter un disque physique pour déplacer <code>/tftpboot</code> et son contenu

## Modifier le partitionnement LVM

### Redimensionner un volume LVM pour disposer d'espace libre

### Soit augmenter la partition racine <code>/</code>

### Soit ajouter une partition <code>/tftpboot</code>