# se3-docs

Ce dépôt contient la documentation de certains composants de
la solution `SambaÉdu3` dont le code est hébergé sur `Github`.

* [Pour contribuer au projet](#pour-contribuer-au-projet)
* [Pour gérer un serveur `se3`](#pour-gérer-un-serveur-se3)
    * [Installer un `se3`](#installer-un-se3)
    * [Migrer un `se3`](#migrer-un-se3)
    * [Sauvegarder et restaurer un `se3`](#sauvegarder-et-restaurer-un-se3)
    * [Tester ou remonter des bugs](#tester-ou-remonter-des-bugs)
* [Gestion des `clients-linux`](#gestion-des-clients-linux)
* [Gestion des `clients-windows`](#gestion-des-clients-windows)
* [Utilitaires](#utilitaires)
* [Des documentations sur Debian](#des-documentations-sur-debian)


## Pour contribuer au projet

* Documentation en rapport avec [le développement et l'utilisation de Git](dev-clients-linux/README.md#documentation-pour-le-futur--contributeurdéveloppeur)
* Documentation pour [utiliser le Git](dev-clients-linux/memo-git.md#memo-git)
* Documentation de base pour [utiliser le formatage markdown](dev-clients-linux/memo-markdown.md#memo-sur-le-formatage-markdown-fichiers-md)
* Documentation plus complète pour [le formatage markdown](http://enacit1.epfl.ch/markdown-pandoc/)
* Documentation en rapport avec [la création de paquets debian](https://www.debian.org/doc/manuals/maint-guide/index.fr.html)


## Pour gérer un serveur `se3`

### Installer un `se3`

* Documentation pour une [installation manuelle](se3-installation/installationmanuelle.md#installation-manuelle-dun-se3) d'un `se3`
* Documentation pour une [installation automatique](se3-installation/incorporerpreseed.md#installation-automatique-dun-se3) d'un `se3`
* Documentation pour installer [un réseau virtuel `se3`](http://wiki.dane.ac-versailles.fr/index.php?title=Installer_un_r%C3%A9seau_SE3_avec_VirtualBox) avec `VirtualBox`
* Documentation pour configurer [l'onduleur](http://www.samba-edu.ac-versailles.fr/Configurer-l-onduleur)
* Documentation pour configurer [la messagerie](http://www.samba-edu.ac-versailles.fr/Configurer-l-envoi-de-courriels-derriere-Amon-avec-un-SMTP-authentifie)


### Migrer un `se3`

* Procédure pour migrer [de se3-squeeze à se3-wheezy](se3-migration/SqueezeToWheezy.md#migration-de-se3-squeeze-vers-se3-wheezy)


### Sauvegarder et restaurer un `se3`

* La documentation pour [les scripts `sauve_se3.sh` et `restaure_se3.sh`](se3-sauvegarde/sauverestaure.md#sauvegarder-et-restaurer-un-serveur-se3)


### Tester ou remonter des bugs

* Documentation pour passer sur [la branche `se3testing` du projet](dev-clients-linux/upgrade-via-se3testing.md#installer-et-tester-en-toute-sécurité-la-version-dun-paquet-issue-de-la-branche-se3testing) dans le but de tester des paquets et aider dans la remontée des bugs

* Documentation expliquant [comment tester la compatibilité `samba 4.4` de son annuaire `ldap` de production](dev-clients-linux/test-annu-smb44.md#tester-la-compatibilité-dun-annuaire-de-production-dans-une-machine-virtuelle) **sur une machine virtuelle**


## Gestion des `clients-linux`

* Documentation de l'installation automatique [des `clients-linux`](pxe-clients-linux/README.md#installation-de-clients-linux-debian-et-ubuntu-via-se3--intégration-automatique)
* Documentation de la gestion des [`clients-linux`](se3-clients-linux/README.md#gestion-des-stations-de-travail-debian-ou-ubuntu-dans-un-domaine-sambaÉdu-avec-le-paquet-se3-clients-linux)


## Gestion des `clients-windows`

* Prérequis [avant intégration d'un clients-windows](se3-clients-windows/clients-windows.md#prérequis-pour-lintégration-de-clients-windows)
* Gestion des imprimantes : [utiliser une console `MMC`](se3-clients-windows/imprimantes.md#gestion-des-imprimantes-pour-les-clients-windows)


## Utilitaires

* Une brêve documentation pour [l'utilisation d'une session `screen`](../dev-clients-linux/screen.md#utilisation-dune-session-screen)
* Un petit memo concernant [reprepro](reprepro/memo.md#petit-memo-sur-reprepro)


## Des documentations sur Debian

* Une documentation pour [les débutants](http://lescahiersdudebutant.fr/)
* La documentation de Raphaël Hertzog : [le cahier de l'administrateur Debian](https://debian-handbook.info/browse/fr-FR/stable/)


