#Les logs pour détecter un problème

Après modification du script de `logon`, vous n'obtiendrez peut-être pas le comportement souhaité. Peut-être, par exemple, parce que vous aurez tout simplement commis des erreurs lors de la personnalisation.

Afin de faire un diagnostic, il vous sera toujours possible de consulter, **sur un client GNU/Linux**, quelques fichiers log qui se trouvent, tous, dans le répertoire `/etc/se3/log/`.

Voici la liste des fichiers log disponibles
selon les phases d'exécution du script de `logon`. :

* **synchronisation d'un logon local avec le logon distant**
    * [mise à jour du logon local](#fichier-0maj_logonlog)
* **phase d'initialisation**
    * [logon local](#fichier-1initialisationlog)
    * [logon distant](#fichier-1initialisation_distantlog)
    * [logon perso](#fichier-1initialisation_persolog)
* **phase d'ouverture**
    * [logon local](#fichier-2ouverturelog)
    * [logon perso](#fichier-2ouverture_persolog)
* **phase de fermeture**
    * [logon local](#fichier-3fermeturelog)
    * [logon perso](#fichier-3fermeture_persolog)

**Note :** les différentes phases d'exécution du script de `logon` sont détaillées à la page dédiée au [script de logon](script_logon.md).

À chaque fois que le script de logon s'exécute, avant d'écrire sur le fichier `xxx.log` adapté à la
situation du moment, le fichier xxx.log, s'il existe déjà, est d'abord vidé de son contenu. Donc les
fichiers log ne seront jamais très gros.

Par exemple, dans le fichier `1.initialisation.log`, vous
aurez des informations portant uniquement sur la dernière phase d'initialisation effectuée par le client GNU/Linux (pas sur les phases d'initialisation précédentes).



## Fichier `0.maj_logon.log`

La mise à jour du script de logon local (via son remplacement par une copie de
la version distante) est un moment important et ce fichier indiquera si cette mise à jour a marché
ou non.

La date de la mise à jour y est indiquée.


## Fichier `1.initialisation.log`

Ce fichier contiendra tous les messages (d'erreur ou non) suite à l'exé-
cution du script de logon **local** lors de la phase d'initialisation.


## Fichier `1.initialisation_distant.log`

Ce fichier contiendra tous les messages (d'erreur ou non) suite
à l'exécution, lors de la phase d'initialisation, du script de logon **distant** (celui qui se trouve sur le serveur) et non celui qui se trouve en local sur le client GNU/Linux.

Rappelez-vous que cela se produit quand les deux versions du script de logon (la version locale et la version et distante) sont différentes (ce qui est censé se produire ponctuellement seulement puisque la version locale est ensuite mise à jour).


## Fichier `1.initialisation_perso.log`

Ce fichier contiendra tous les messages (d'erreur ou non) suite
à l'exécution, lors de la phase d'initialisation, de votre fonction `initialisation_perso`.


## Fichier `2.ouverture.log`

Ce fichier contiendra tous les messages (d'erreur ou non) suite à l'exécution
du script de logon local lors de la phase d'ouverture.


## Fichier `2.ouverture_perso.log`

Ce fichier contiendra tous les messages (d'erreur ou non) suite à l'exé-
cution, lors de la phase d'ouverture, de votre fonction `ouverture_perso`.


## Fichier `3.fermeture.log`

Ce fichier contiendra tous les messages (d'erreur ou non) suite à l'exécution
du script de logon local lors de la phase de fermeture.


## Fichier `3.fermeture_perso.log`

Ce fichier contiendra tous les messages (d'erreur ou non) suite à l'exé-
cution, lors de la phase de fermeture, de votre fonction `fermeture_perso`.


