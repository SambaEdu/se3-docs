# Lancement d'un script perso en fin de post-installation des `clients-linux`

* [Objectifs](#objectifs)
* [Fonctions disponibles](#fonctions-disponibles)
* [Variables disponibles](#variables-disponibles)


## Objectifs

Le paquet `pxe-clients-linux` propose un mécanisme qui permet de lancer un script perso à la fin de la post-installation (**phase 2**).

Ce script perso se nomme `monscript-perso.sh` et il se trouve dans le répertoire `/home/netlogon/clients-linux/install/messcripts_perso/`. Les noms de ce répertoire et de ce fichier ne devront pas être modifié.

Le contenu de ce script perso peut être adapté par l'administrateur du `se3` afin de lancer les opérations de son choix sur le `client-linux` lors de la phase de post-installation.


**Remarque :** lors des mises à jour du dispositif `pxe-clients-linux`, le contenu de ce répertoire `/home/netlogon/clients-linux/install/messcripts_perso/` est préservé, en ce sens que la mise à jour le laise tel qu'il était lors de la dernière modification de son contenu par l'administrateur du serveur `se3`.


## Fonctions disponibles

Ce script comporte deux fonctions :

* `recuperer_parametres` (importation de paramètres utiles)
* `test_se3` (vérification que le script n'est pas lancé sur le serveur `se3`)

La partie qui correspond au programme se trouve à la fin du fichier :
```sh
#####
# début du programme
recuperer_parametres
test_se3
# Vos commandes perso :


exit 0
# fin du programme
#####
```

Dans cette partie du programme, que vous pouvez gérer comme bon vous semble, vous pouvez mettre des commandes ou bien vous pouvez lancer des scripts que vous pourrez stocker dans le répertoire `/home/netlogon/clients-linux/install/messcripts_perso/`.

Vous pouvez aussi rajouter des fonctions dans la partie du script dédiée aux fonctions.


## Variables disponibles

La fonction `recuperer_parametres` a pour but de vous permettre d'utiliser un certain nombre de variables utiles pour l'écriture de votre script.

Voici ces variables :

* Paramètres Proxy :
    * $ip_proxy
    * $port_proxy
* Paramètres SE3 :
    * $ip_se3
    * $nom_se3
    * $nom_domaine
* Paramètres LDAP :
    * $ip_ldap
    * $ldap_base_dn


