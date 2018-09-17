# se3-docs

Ce dépôt contient la documentation de certains composants de
la solution `SambaÉdu3` dont le code est hébergé sur `Github`.

* [Pour contribuer au projet](#pour-contribuer-au-projet)
* [Pour gérer un serveur `se3`](#pour-gérer-un-serveur-se3)
    * [Installer un `se3`](#installer-un-se3)
    * [Administrer un `se3`](#administrer-un-se3)
    * [Migrer un `se3`](#migrer-un-se3)
    * [Sauvegarder et restaurer un `se3`](#sauvegarder-et-restaurer-un-se3)
    * [Tester ou remonter des bugs](#tester-ou-remonter-des-bugs)
* [Gestion des `clients-linux`](#gestion-des-clients-linux)
* [Gestion des `clients-windows`](#gestion-des-clients-windows)
* [Utilitaires et veille technologique](#utilitaires-et-veille-technologique)
* [Autres documentations sur le projet `se3`](#autres-documentations-sur-le-projet-se3)
* [De la documentation sur Debian](#de-la-documentation-sur-debian)


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
* Documentation pour installer [un réseau virtuel `se3`](se3-virtualisation/installerReseauSE3Virtualbox.md#installer-un-réseau-se3-avec-virtualbox) avec `VirtualBox`


### Administrer un `se3`

* Documentation pour configurer [l'onduleur](se3-administration/configurer_onduleur.md#configurer-londuleur)
* Documentation pour configurer [la messagerie](se3-administration/messagerie.md#configurer-la-messagerie-du-se3)
* Documentation pour [changer l'adresse](se3-administration/changer_adresse_reseau.md#changer-ladresse-du-réseau) du réseau pédagogique


### Migrer un `se3`

* Procédure pour migrer [de se3/lenny à se3/wheezy](se3-migration/LennyToWheezy.md#migration-de-se3lenny-vers-se3wheezy)
* Procédure pour migrer [de se3/squeeze à se3/wheezy](se3-migration/SqueezeToWheezy.md#migration-de-se3squeeze-vers-se3wheezy)


### Sauvegarder et restaurer un `se3`

* La documentation pour [les scripts `sauve_se3.sh` et `restaure_se3.sh`](se3-sauvegarde/sauverestaure.md#sauvegarder-et-restaurer-un-serveur-se3)

* La documentation pour [cloner les disques](se3-sauvegarde/clonerse3.md#cloner-un-se3) de votre `se3`


### Tester ou remonter des bugs

* Documentation pour passer sur [la branche `se3testing` du projet](dev-clients-linux/upgrade-via-se3testing.md#installer-et-tester-en-toute-sécurité-la-version-dun-paquet-issue-de-la-branche-se3testing) dans le but de tester des paquets et aider dans la remontée des bugs

* Documentation expliquant [comment tester la compatibilité `samba 4.4` de son annuaire `ldap` de production](dev-clients-linux/test-annu-smb44.md#tester-la-compatibilité-dun-annuaire-de-production-dans-une-machine-virtuelle) **sur une machine virtuelle**


## Gestion des `clients-linux`

* Documentation de [l'installation/intégration/post-installation automatique](pxe-clients-linux/README.md#installation-de-clients-linux-debian-et-ubuntu-via-se3--intégration-automatique) des `clients-linux`
* Documentation de [la gestion](se3-clients-linux/README.md#gestion-des-stations-de-travail-debian-ou-ubuntu-dans-un-domaine-sambaÉdu-avec-le-paquet-se3-clients-linux) des `clients-linux`


## Gestion des `clients-windows`

* Prérequis [avant intégration d'un client-windows](se3-clients-windows/clients-windows.md#prérequis-pour-lintégration-de-clients-windows)
* Intégration des [windows10](se3-clients-windows/windows10.md#int%C3%A9gration-des-clients-windows10)
* Gestion des imprimantes : [utiliser une console `MMC`](se3-clients-windows/imprimantes.md#gestion-des-imprimantes-pour-les-clients-windows)


## Utilitaires et veille technologique

* Une brêve documentation pour [l'utilisation d'une session `screen`](dev-clients-linux/screen.md#utilisation-dune-session-screen)
* Un petit memo concernant [reprepro](reprepro/memo.md#petit-memo-sur-reprepro)
* Un petit memo prometteur pour [Ansible](dev-clients-linux/labs/ansible/tuto-ansible.md#petit-tutoriel-sur-ansible)
* Intégration d'[un serveur Jupyterhub](se3-env/memo.md) utilisant le serveur LDAP de Se3  


## Autres documentations sur le projet `se3`

* La documentation de [Caen](http://wwdeb.crdp.ac-caen.fr/mediase3/index.php/Table_des_mati%C3%A8res)
* La documentation de [Versailles](http://www.samba-edu.ac-versailles.fr/)
* La page [`SambaÉdu` Wikipedia](https://fr.wikipedia.org/wiki/SambaEdu)


## De la documentation sur Debian

* Une documentation du projet `DFLinux` pour [les débutants](http://lescahiersdudebutant.fr/)
* La documentation de *Raphaël Hertzog* et *Roland Mas* : [le cahier de l'administrateur `Debian`](https://debian-handbook.info/browse/fr-FR/stable/)


