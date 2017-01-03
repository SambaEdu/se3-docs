# Installer et tester en toute sécurité la version d'un paquet issue de la branche `se3testing`

* [Présentation](#présentation)
* [Passer en branche `se3testing`](#passer-en-branche-se3testing)
    * [Édition du fichier `/etc/apt/sources.list.d/se3.list`](#Édition-du-fichier-etcaptsourceslistdse3list)
    * [Mettre à jour la liste des paquets](#mise-à-jour-du-cache-apt)
* [Mettre à jour un ou des paquet(s)](#mise-à-jour-du-ou-des-paquets)
* [Retourner en branche stable `se3`](#retour-à-la-branche-stable-se3)


# Présentation

En général, la politique chez `SambaÉdu`, lorsqu'une nouvelle
version d'un paquet est publiée, est de déposer ce paquet
dans la branche `se3testing` pendant quelques jours avant de
le mettre dans la branche `se3`, qui est la branche stable.

Ci-dessous, nous vous expliquons comment installer la
version du paquet `se3-clients-linux` issue de la branche
`se3testing` sur votre serveur en toute sécurité, en évitant
de mettre à jour d'autres paquets issus de cette branche.

**Remarque :** les explications sont données pour le paquet `se3-clients-linux`, mais cela est valable pour tout autre paquet du projet `SambaÉdu`.

Le but est donc d'installer, via la branche `se3testing`
(parce que vous êtes impatient de tester la nouvelle version
qui s'y trouve), le paquet `se3-clients-linux` **mais de le faire
rien que pour ce paquet et ses éventuelles dépendances**, les autres paquets étant toujours
installés via la branche stable `se3` comme d'habitude
(parce que vous ne souhaitez pas non plus prendre de risque
au niveau de votre serveur de production).

On suppose ici que votre serveur `Se3` est sous `Wheezy` mais
la méthode est très certainement exactement la même pour un
serveur `Se3` sous une autre distribution.

Voici les étapes que nous vous proposons :

* modifier le fichier `/etc/apt/sources.list.d/se3.list`
* recharger la liste des paquets
* mettre à jour le ou les paquet(s) à tester
* revenir à la branche stable

Les deux premières étapes permettent de se retrouver en branche `se3testing`, la troisième permet d'utiliser la version du paquet disponible en branche `se3testing` et, enfin, la dernière étape permet un retour à la branche stable, ce qui est plus prudent lorsqu'on fait les tests sur un `se3` en production.


## Passer en branche `se3testing`

### Édition du fichier `/etc/apt/sources.list.d/se3.list`

Éditez le fichier `/etc/apt/sources.list.d/se3.list` en
console (par exemple avec l'éditeur `nano`).
```sh
nano /etc/apt/sources.list.d/se3.list
```

Dans ce fichier, vous devriez avoir cette ligne là :
```
deb http://wawadeb.crdp.ac-caen.fr/debian wheezy se3
```

Vous allez commenter cette ligne pour qu'elle devienne
comme ceci (commenter une commande consiste à rajouter un # au début de la ligne) :
```
#deb http://wawadeb.crdp.ac-caen.fr/debian wheezy se3
```

Toujours dans ce fichier, vous avez la ligne suivante qui est commentée :
```
#deb http://wawadeb.crdp.ac-caen.fr/debian wheezy se3testing
```

Vous allez décommenter cette ligne pour qu'elle devienne
comme ceci :
```
deb http://wawadeb.crdp.ac-caen.fr/debian wheezy se3testing
```

Vous fermez ensuite votre éditeur en prenant bien soin
d'enregistrer la modification (à l'aide des combinaisons de touches `Ctrl+o` puis `Ctrl+x`).


### Mise à jour du cache APT

Ensuite, vous mettez à jour votre cache APT pour que votre
`Se3` soit bien « informé » des versions des paquets disponibles
dans la branche `se3testing`.

Pour ce faire, il suffit de lancer la commande suivante :
```sh
apt-get update
```


## Mise à jour du ou des paquets

Ensuite, vous pouvez alors passer à la mise à jour du paquet (ici, nous prenons en exemple le paquet
`se3-clients-linux` dont une version est disponible dans la branche `se3testing`) avec la commande :
```sh
# Et oui, c'est curieux mais `apt-get install` permet de
# mettre à jour un paquet (et de l'installer s'il ne l'est
# pas déjà).
apt-get install se3-clients-linux
```

**Remarque :** si vous voulez tester la version en *branche testing* d'un autre paquet ou de plusieurs paquets, il suffira de remplacer, dans cette commande, le paramètre *se3-clients-linux* par les noms des paquets à tester.


## Retour à la branche stable `se3`

Maintenant que nous avons « chipé » la version d'un paquet
issue de la branche `se3testing`, nous voulons que
notre serveur consulte à nouveau la branche stable `se3`
afin d'éviter la mise à jour intempestive
d'autres paquets issus de la branche `se3testing`.

Pour ce faire, rien de plus simple, il suffit de rééditer à nouveau
le fichier `/etc/apt/sources.list.d/se3.list` afin de faire
pointer notre serveur à nouveau vers la branche stable
`se3`.

Vous éditez donc à nouveau le fichier `/etc/apt/sources.list.d/se3.list`
(voir ci-dessus) afin de remettre les lignes modifiées précédemment
dans leur état initial, à savoir comme ceci :
```
deb http://wawadeb.crdp.ac-caen.fr/debian wheezy se3

#deb http://wawadeb.crdp.ac-caen.fr/debian wheezy se3testing

```

Pensez bien à enregistrer la modification (à l'aide des combinaisons de
touches `Ctrl+o` puis `Ctrl+x`) puis lancez ensuite la commande suivante qui permet de recharger la liste des paquets :
```sh
# Mise à jour du cache APT pour qu'il s'aligne à nouveau sur
# les versions des paquets de la branche stable se3.
apt-get update
```

Et voilà, c'est fini. Vous bénéficiez d'un paquet (`se3-clients-linux` dans l'exemple ci-dessus)
dans sa version disponible dans la branche `se3testing`. N'hésitez pas à remonter les résultats de vos tests sur la liste `l-se3-devel` de Caen.

