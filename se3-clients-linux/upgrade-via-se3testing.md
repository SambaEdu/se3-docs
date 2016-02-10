# Installer et tester en toute sécurité la version du paquet issue de la branche `se3testing`

En général, la politique chez SambaÉdu lorsqu'une nouvelle
version d'un paquet est publiée est de déposer ce paquet
dans la branche `se3testing` pendant quelques jours avant de
le mettre dans la branche `se3`, qui est la branche stable.

Ci-dessous, nous vous expliquons comment installer la
version du paquet `se3-clients-linux` issue de la branche
`se3testing` sur votre serveur en toute sécurité, en évitant
de mettre à jour d'autres paquets issus de cette branche.

Le but est donc d'installer, via la branche `se3testing`
(parce que vous êtes impatient de tester la nouvelle version
qui s'y trouve), le paquet `se3-clients-linux` mais de le faire
rien que pour ce paquet, les autres paquets étant toujours
installés via la branche stable `se3` comme d'habitude
(parce que vous ne souhaitez pas non plus prendre de risque
au niveau de votre serveur de production).

On suppose ici que votre serveur Se3 est sous Squeeze mais
la méthode est très certainement exactement la même pour un
serveur Se3 sous une autre distribution.

Voici les étapes que nous vous proposons :

* [passer en branche `se3testing`](#Édition-du-fichier-etcaptsourceslistdse3list)
* [mettre à jour la liste des paquets](#mise-à-jour-du-cache-apt)
* [mettre à jour le paquet `se3-clients-linux`](#mise-à-jour-du-paquet-se3-clients-linux)
* [retourner en branche stable `se3`](#retour-à-la-branche-stable-se3)


## Édition du fichier `/etc/apt/sources.list.d/se3.list`

Éditez le fichier `/etc/apt/sources.list.d/se3.list` en
console (par exemple avec l'éditeur `nano`).
```sh
nano /etc/apt/sources.list.d/se3.list
```

Dans ce fichier, vous devriez avoir cette ligne là :
```
deb http://wawadeb.crdp.ac-caen.fr/debian squeeze se3
```

Vous devez alors modifier cette ligne pour qu'elle devienne
comme ceci (vous changez juste la branche utilisée qui est
`se3testing` au lieu de `se3` désormais) :
```
deb http://wawadeb.crdp.ac-caen.fr/debian squeeze se3testing
```

Vous fermez ensuite votre éditeur en prenant bien soin
d'enregistrer la modification (à l'aide des combinaisons de touches `Ctrl+o` puis `Ctrl+x`).


## Mise à jour du cache APT

Ensuite, vous mettez à jour votre cache APT pour que votre
Se3 soit bien « informé » des versions des paquets disponibles
dans la branche `se3testing`.

Pour ce faire, il suffit de lancer la commande :
```sh
apt-get update
```


## Mise à jour du paquet `se3-clients-linux`

Ensuite, vous pouvez alors passer à la mise à jour du paquet
`se3-clients-linux` **et de lui seulement** avec la commande :
```sh
# Et oui, c'est curieux mais `apt-get install` permet de
# mettre à jour un paquet (et de l'installer s'il ne l'est
# pas déjà).
apt-get install se3-clients-linux
```


## Retour à la branche stable `se3`

Maintenant que nous avons « chipé » la version du paquet
`se3-clients-linux` issue de la branche `se3testing`, nous
voulons que notre serveur consulte à nouveau la branche
stable `se3` afin d'éviter la mise à jour intempestive
d'autres paquets issus de la branche `se3testing`.

Pour ce faire, rien de plus simple, il suffit de rééditer à nouveau
le fichier `/etc/apt/sources.list.d/se3.list` afin de faire
pointer notre serveur à nouveau vers la branche stable
`se3`.

Vous éditez donc à nouveau le fichier `/etc/apt/sources.list.d/se3.list`
(voir ci-dessus) afin de remettre la ligne modifiée précédemment
dans son état initial, à savoir comme ceci :
```
deb http://wawadeb.crdp.ac-caen.fr/debian squeeze se3
```

Pensez bien à enregistrer la modification (à l'aide des combinaisons de
touches `Ctrl+o` puis `Ctrl+x`) puis lancez ensuite la commande :
```sh
# Mise à jour du cache APT pour qu'il s'aligne à nouveau sur
# les versions des paquets de la branche stable se3.
apt-get update
```

Et voilà, c'est fini. Vous bénéficiez du paquet `se3-clients-linux`
dans sa version disponible dans la branche `se3testing`.

