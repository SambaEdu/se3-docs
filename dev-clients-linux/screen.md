# Utilisation d'une session `screen`

* [Présentation](#présentation)
* [Ouvrir une session `screen`](#ouvrir-une-session-screen)
* [Quitter ou fermer une session `screen`](#quitter-ou-fermer-une-session-screen)
* [Reprendre une session `screen`](#reprendre-une-session-screen)


## Présentation

`screen` est une session particulière en ce sens que vous pouvez la quitter sans que le processus soit arrêté, contrairement à une session normale.

Vous trouverez ci-dessous quelques commandes pouvant être utiles pour gérer cet outil.


## Ouvrir une session `screen`

Pour ouvrir une session `screen`, lancez la commande suivante :
```sh
screen
```

**Remarque 1 :** il se peut que le paquet ne soit pas installé. Dans ce cas, il faut l'installer :
```sh
aptitude install screen
```

**Remarque 2 :** chaque fois que l'on lance la commande `screen`, il y a un texte introductif qui s'affiche ; il suffit d'appuyer sur la touche `Entrée` pour se retrouver dans la session `screen`.


## Quitter ou fermer une session `screen`

Une fois dans une session `screen`, vous pourrez en sortir ou la fermer à l'aide des commandes suivantes :

* Ctrl+a d → sortir de la session `screen` sans arrêter le script lancé
* exit → fermer la session screen en cours

**Remarque :** "Ctrl+a d" signifie que vous utilisez la combinaison des 2 touches `Ctrl` et `a` puis, une fois ces deux touches `Ctrl` et `a` relachées, que vous appuyez sur la touche `d`.


## Reprendre une session `screen`

Pour reprendre une session `screen`, on peut utiliser la commande suivante :

```sh
screen -r
```

Si l'on veut vérifier l'existence de sessions `screen`, on peut utiliser la commande suivante qui liste les sessions `screen` en cours de fonctionnement :

```sh
screen -ls
```

