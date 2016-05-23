# Installation du service LTSP - Client lourd (fat client) sur un serveur Samba Edu 3

## Présentation 
Cette documantation explique comment intégrer le service ltsp à un serveur Samba Edu 3 puis comment l'administrer simplement.
Tout PC disposant d'une carte ethernet avec un boot PXE et d'au moins 512 Mo de RAM pourra démarrer en tant que clients lourds (mode fat client) grâce au réseau et
sans avoire besoin de disque dur.
Le bureau des clients lourds peut soit être un bureau Debian Jessie Mate ou Ubuntu Xenial Mate.
Le serveur Se3 n'a pas besoin d'être très puissant car ltsp n'est configuré pour gérer que des clients lourds (fat client).

## Pourquoi installer le service ltsp sur un se3 ?
Les utilisations peuvent être nombreuses. Par exemple :
* faciliter la gestion d'un parc informatique, la maintenance se limitant à l'environnement construit sur le serveur se3 pour les clients lourds.
* disposer d'un mode de démarrage réseau "de secours" pour l'ensemble de son parc : tout pc disposant d'une carte réseau pxe pourra démarrer sur le réseau, sans avoir besoin de son disque dur.

## Pre-requis

* Votre serveur Se3 doit être sous Debian Wheezy et disposait d'au moins une carte 1 Gbs relié à un port 1 Gbs d'un commutateur réseau.
* Le service ltsp est configuré en mode client lourd uniquement : autrement dit, le serveur ltsp n'a pas besoin d'être très puissant car
les applications sont exécutés avec les ressources du client lourd. C'est surtout les accès en lecture au disque dur qui vont être sollicités
sur le se3 (par le service nfs ou nbd de ltsp) : il est donc conseillé d'investir dans un (ou des) disque(s) dur(s) SSD à accès rapide ou 
des disques durs SATA montés en RAID 0 (ou RAID 5) pour accélérer les accès.
* La carte réseau des clients lourds doit être au moins de 100 Mbs et reliée à un port 100 Mbs ou plus du commutateur réseau.
* Il faut éviter de mettre trop de commutateurs réseau en série (en cascade) afin d'éviter de diminuer la vitesse de leur port 1 Gbs.
* D'une façon générale, le réseau ethernet pédagogique doit être "en bon état" car il va être assez sollicité.

Remarque :
Pour desservir un très grand nombre de clients lourds, il est conseillé d'équiper le se3 de plusieurs cartes ethernet 1Gbs et de faire
une agrégation de liens (en mode balance-tlb ou balance-alb).

## Installation de LTSP

* Se connecter au serveur SE3 en tant que root (en ssh par exemple).
* Rendre executable le script suivant executable
* Puis l'exécuter :
* Pendant l'installation (qui dure environ une heure), il est demandé :
** Le mot de passe du compte root de l'environnement des clients lourds.
** Le mot de passe du compte local enseignant

## Que fait le script d'installation ?

Le script d'installation du service ltsp va simplement :
* créer un répertoire /opt/ltsp/i386 qui contiendra l'environnement (le chroot) des clients lourds Debian Jessie (ou Ubuntu Xenial)
* installer et configurer les services NFS et NBD pour mettre à disposition des clients lourds, via le réseau, leur environnement i386 (leur chroot)
* créer un répertoire /tftpboot/ltsp contenant l'initrd et le kernel pour le boot PXE des clients lourds
* ajouter une entrée au menu /tftpboot/pxelinux.cfg/default afin qu'un utilisateur puisse faire démarrer un PC en client lourds LTSP
* configurer l'environnement i386 des clients lourds (le chroot) pour réaliser l'identification des utilisateurs avec l annuaire ldap du se3 
et le montage automatique de deux partages Samba du se3 (Docs et Classes)

Seul un service supplémentaire va être lancé sur le serveur se3, selon la distribution installée, ce sera :
* le service nfs si c'est un bureau Debian est installé pour les clients lourds.
* le service nbd si un bureau Ubuntu est desservi aux clients lourds.

L'environnement (le chroot) des clients lourds est configuré pour être autonome et impacter au minimum le serveur se3. Par soucis de simplification,
un seul environnement en architecture i386 est construit : cet environnement contiendra toutes les applications utiles aux utilisateurs et sera 
utilisé à la fois par les clients lourds i386 et amd64.

## nfs et nbd, quelle différence ?
nfs et nbd sont deux services utilisés pour desservir l'environnement (le chroot) aux clients lourds ltsp.
nfs est plus souple mais moins performant que nbd : il est utilisé par défaut sur Debian contrairement à Ubuntu qui utilise nbd.


## Comment administrer le serveur LTSP ?

L'administration du service LTSP consiste principalement à personnaliser l'environnement i386 des clients lourds (le chroot).
qui a été construit sur le se3 durant l'intégration de ltsp.
Pour administrer simplement l'environnement des clients lourds :
* Se connecter sur un client lourd du réseau, avec le compte admin du se3.
* Se rendre dans le partage Samba du se3 `Clients-linux/ltsp/administrer` accessible depuis le bureau du compte admin du se3.
Ce repertoire contient un ensemble de script qu'il est possible de lancer très simplement en double-cliquant dessus.
Voici une description expliquant comment utiliser chacun de ces scripts :

** construire_squashfs_image.sh
Ce script construit l'image squashfs des clients lourds, lorsque le service nbd est utilisé.
Il doit être lancé au moins une fois, à la fin des tâches d'administration réalisées sur un environnement Ubuntu.
Il entraîne l'arrêt du service nbd : il doit donc être lancé lorsqu'aucun client lourd n'est utilisé.

** deployer_mes_lanceurs.sh :
Ce script permet de personnaliser le bureau des clients lourds.
*** Créer sur votre bureau les lanceurs que vous voulez voir apparaître sur le bureau de vos clients.
*** Double-cliquer sur le script deployer_mes_lanceurs.sh
*** Si la distribution Ubuntu est utilisée, reconstruire l'image squashfs (attention, tous les clients lourds seront automatiquement déconnectés).

** deployer_mon_skel.sh :
Ce script permet de personnaliser le "home" par défaut des utilisateurs de client lourd.
*** Personnaliser vos applications (votre navigateur web par exemple).
*** Repérer les dossiers de configuration de vos application (par exemple, /home/admin/.mozilla pour le navigateur firefox).
*** Copier ces dossiers dans le partage Samba du se3 `Clients-linux/ltsp/skel`, accessible depuis le bureau du compte admin du se3.
*** Double-cliquer sur le script deployer_mon_skel.sh
*** Si la distribution Ubuntu est utilisée, reconstruire l'image squashfs (attention, tous les clients lourds seront automatiquement déconnectés).

** deployer_imprimantes.sh :
Ce script permet d'installer les pilotes d'imprimantes.
*** Configurer toutes les imprimantes de votre réseau, restreindre éventuellement les droits à certains groupes d'utilisateurs.
*** Tester l'impression sur vos imprimantes
*** Double-cliquer sur le script deployer_imprimantes.sh
*** Si la distribution Ubuntu est utilisée, reconstruire l'image squashfs (attention, tous les clients lourds seront automatiquement déconnectés).

* sauvegarder_chroot_actuel.sh :
Ce script réalise une sauvegarde sans compression dans /var/se3/ltsp de l'environnement actuel (le chroot) des clients lourds.
Si une sauvegarde précédente existe déjà dans /var/se3/ltsp, cette dernière est déplacée dans /var/se3/ltsp/precedentes.
Il peut être lancé dès que votre environnement est configuré comme souhaité et fonctionnel.
La sauvegarde prend quelques minutes.

* restaurer_derniere_sauvegarde.sh :
Ce script restaure la dernière sauvegarde de votre environnement (chroot) réalisée.
Il peut être lancé si vous constatez que votre environnement n'est plus fonctionnel après des opérations de maintenance effectuées.
La restauration prend quelques secondes.

* restaurer_sauvegarde_originale.sh :
Ce script restaure la première sauvegarde de votre environnement (chroot) réalisée, juste à la fin du script d'installation de ltsp sur le se3.
Cela permet de "repartir" à zéro dans la configuration de l'environnement (chroot) des clients lourds.
La restauration prend quelques secondes.

* supprimer_sauvegardes_sauf_derniere.sh :
Ce script supprime toutes les sauvegardes stockées dans /var/se3/ltps/precedente.
Seule la dernière sauvegarde réalisée, stockée dans /var/se3/ltsp/, n'est pas supprimée.

* installer_des_applis.sh :
Ce script permet d'installer très rapidement une liste d'applications installables via apt-get.
Avant de lancer le script, il est conseillé de tester le bon déroulement en testant l'installation sur un client lourd.
** ouvrir un terminal graphique et se connecter avec le compte root des clients lourds :
su root
** puis saisir le mot de passe entré pendant l'installation de ltsp sur le serveur se3.
** effectuer l'installation des applications :
apt-get install -f appli1 appli2 appli3 appli4 ...

Remarque:
Cette installation n'est pas persistente car l'environnement des clients lourds en fonctionnement est en lecture seule : 
au prochain démarrage du client lourd, les applications installées auront disparu ...
Par contre, cette installation permet de se placer "dans les mêmes conditions" que dans le "chroot" : si elle se déroule convenablement,
il y a de très forte chance que l'execution du script installer_mes_applis.sh se passe aussi bien.

** si l'installation s'est bien déroulée sur le client lourd, lancer le script installer_mes_applis.sh présent dans `Clients-linux/ltsp/administrer` puis saisir la même liste d'applications à installer dans le chroot :
appli1 appli2 appli3 appli4 ...

