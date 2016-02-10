# Installer et tester en toute sécurité la version du paquet issue de la branche `se3testing`

En général, la politique chez `SambaÉdu` lorsqu'une nouvelle
version d'un paquet est publiée est de déposer ce paquet
dans la branche `se3testing` pendant quelques jours avant de
le mettre dans la branche `se3`, qui est la branche stable.

Ci-dessous, nous vous expliquons comment installer la
version du paquet `pxe-clients-linux` issue de la branche
`se3testing` sur votre serveur en toute sécurité, en évitant
de mettre à jour d'autres paquets issus de cette branche.

Il est à noter que, pour l'instant, le paquet `pxe-client-linux` est une composante du paquet `se3-clonage` : c'est donc ce paquet que l'on va mettre à jour.

La méthode est la même que celle décrite pour le paquet `se3-clients-linux` : pour plus de détails, vous pourrez lire [l'article concernant ce paquet](https://github.com/flaf/se3-clients-linux/blob/master/doc/upgrade-via-se3testing.md).


**1)** passer en `se3testing`
Éditez le fichier /etc/apt/sources.list.d/se3.list :
```ssh
nano /etc/apt/sources.list.d/se3.list
```
Décommentez la ligne associée au dépôt `se3testing`
![decommenter ligne](/doc/images/pxe_tftp_05.png)

Sauvegardez cette modification (combinaison de touches `Ctrl+o`) et fermer le fichier (combinaison de touches `Ctrl+x`)

**2)** recharger la liste des paquets
```ssh
apt-get update
```

**3)** installer le paquet `se3-clonage` et le paquet `se3-clients-linux`
```ssh
apt-get install se3-clonage se3-clients-linux
```

**4)** revenir à la branche stable
Éditez le fichier /etc/apt/sources.list.d/se3.list :
```ssh
nano /etc/apt/sources.list.d/se3.list
```
Commentez la ligne associée au dépôt `se3testing`
![commenter ligne](/doc/images/pxe_tftp_04.png)

Sauvegardez cette modification (combinaison de touches `Ctrl+o`) et fermer le fichier (combinaison de touches `Ctrl+x`)

**5)** recharger la liste des paquets
```ssh
apt-get update
```

Et voilà, c'est fini. Vous bénéficiez des paquets `se3-clients-linux` et `se3-clonage`
dans leurs versions disponibles dans la branche `se3testing`.

Reprenez alors les opérations de [mise en place du mécanisme](misenplace.md#mise-à-jour).

