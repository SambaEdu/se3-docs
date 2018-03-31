# Intégration des `clients-windows10`

Voici la procédure pour intégrer un `windows10` à un domaine géré par un `se3`.


## Prérequis

**_La procédure "domscripts" issue du paquet se3-domain est obsolète et ne doit plus être utilisé !_**

Il est nécessaire que le serveur `se3` soit au minimum en **Wheezy 3.0.5**. Le paquet **sambaedu-client-windows** doit être installé. Ce paquet s'installe 

Une recommendation : partez d'un `windows10` de base, c'est-à-dire uniquement avec `windows10` (version actuelle 1709), rien d'autre. Ou refaites une installation propre à l'aide du paquet **sambaedu-client-windows**, c'est automatisé et cela permet d'avoir un poste compatible à 100 % avec SambaEdu. 

Les instructions complètes sont ici  :
[installation windows 10](https://github.com/SambaEdu/sambaedu-client-windows/blob/master/README.md#sambaedu-client-windows)



**note**
Pour le moment l'installation automatique ne permet pas de partitionner le disque  avec un espace libre pour installer un `client-linux`.
## Références

* recommendations pour les [clients-windows](../se3-clients-windows/clients-windows.md#prérequis-pour-lintégration-de-clients-windows).
* installation des [clients-linux](../pxe-clients-linux/README.md#installation-de-clients-linux-debian-et-ubuntu-via-se3--intégration-automatique).

