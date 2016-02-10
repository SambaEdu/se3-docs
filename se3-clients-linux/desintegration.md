**Avertissement :** en fait, la désintégration **n'est plus
supportée** depuis Ubuntu Trusty inclus pour les OS Ubuntu
et depuis Debian Wheezy inclus pour les OS Debian.

Pour effectuer une désintégration, nous vous invitons donc
désormais à réinstaller l'OS à partir de zéro (c'est en
général assez rapide à faire et cela a le mérite d'être
fiable à 100%).

Nous laissons malgré tout cette partie de la
documentation en l'état (voir ci-dessous) car elle reste valable
pour des OS plus anciens comme Squeeze et Precise (même s'il
y a peu de chances que vous procédiez à l'installation de
ces OS à l'heure où ces lignes sont écrites).

---

# La désintégration (dépréciée)

Une fois un client GNU/Linux intégré au domaine, celui-ci
possédera *localement* un script permettant de le faire
sortir du domaine et de lui redonner (quasiment) son état
avant l'intégration. Il s'agit du script :

```sh
/etc/se3/bin/desintegration_<nom-de-code>.bash
```
où vous pouvez remplacer `<nom-de-code>` par `squeeze` ou par `precise`.

Ce script admet une unique option (qui ne
prend pas de paramètre) : il s'agit de l'option
`--redemarrer-client` ou `--rc` qui, comme son nom
l'indique, redémarre la machine à la fin du script de
désintégration.

Sans cette option, la machine ne redémarrera pas automatiquement.
Tout comme pour les scripts d'intégration, après désintégration,
un redémarrage est nécessaire pour que le système soit opérationnel.

Autre point commun : aucune modification sur l'annuaire du serveur
n'est effectuée lors de l'exécution du script de désintégration.

En particulier, après avoir sorti un client
GNU/Linux du domaine, il faudra effacer vous-même toute
trace de ce client dans l'annuaire du serveur.


