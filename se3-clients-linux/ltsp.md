# Installation du service LTSP - Client lourd (fat client) sur un serveur Samba Edu 3

## Introduction :

Cette documantation explique comment `intégrer le service ltsp` à un serveur Samba Edu 3 puis `comment l'administrer simplement`.

Tout PC disposant d'une carte ethernet avec un boot PXE et d'au moins 512 Mo de RAM pourra démarrer en tant que clients lourds (mode fat client) 
grâce au réseau ethernet et sans avoir besoin de son disque dur.

Le bureau des clients lourds pourra être : 
* soit un bureau `Debian Jessie Mate`.
* soit un bureau `Ubuntu Xenial Mate`.

La configuration ltsp appliquée ici impacte peu le serveur Se3 : l'environnement (chroot) des clients lourds est configuré afin de les rendre "autonomes" du se3 ; 
en particulier, l'identification d'un utilisateur est réalisé par l'environnement (chroot) des clients lourds et non par le serveur se3.

Le démarrage d'un PC en "mode client lourd" peut :
* être laissé au choix de l'utilisateur via le menu PXE du se3 qui apparaît pendant quelques secondes au démarrage.
* être configuré par défaut afin que tous les PC démarrent en clients lourds ltsp.

Le **serveur Se3 n'a pas besoin d'être très puissant** car ltsp est configuré ici pour **ne gérer que des clients lourds (fat client)**.

## Pourquoi installer le service ltsp sur un se3 ?

Les utilisations peuvent être nombreuses. Par exemple :

* **faciliter la gestion d'un parc informatique**, la maintenance du parc se limitant à l'environnement (chroot) construit pour tous les clients lourds sur le serveur se3.
* disposer d'un **mode de démarrage réseau "de secours"** pour l'ensemble de son parc : tout pc disposant d'une carte réseau pxe pourra démarrer grâce au réseau.

## Pre-requis

* **Votre serveur Se3 doit être sous Debian Wheezy** et disposait d'au moins une carte 1 Gbs relié à un port 1 Gbs d'un commutateur réseau.
* Le service ltsp est configuré en "mode client lourd" **uniquement** : autrement dit, le serveur ltsp n'a pas besoin d'être très puissant car
les applications sont exécutés avec les ressources des clients lourds. C'est surtout les **accès en lecture au(x) disque(s) dur(s)** qui vont être 
sollicités sur le se3 (service **nfs ou nbd** selon le bureau) : si le choix se présente, il est donc préférable d'opter dans un (ou des) disque(s) dur(s) SSD 
ou des disques durs SATA mais montés en RAID 0 (ou RAID 5) pour augmenter le débit des accès disques.
* La carte réseau des clients lourds doit être au moins de 100 Mbs et reliée à un port 100 Mbs ou plus du commutateur réseau.
* Il faut éviter de mettre trop de commutateurs réseau en série (en cascade) afin d'éviter de diminuer la vitesse de leur port 1 Gbs.
* D'une façon générale, le réseau ethernet pédagogique doit être "en bon état" car il va être assez sollicité par l'ensemble des clients lourds en fonctionnement.

**Remarque :**

Pour desservir un très grand nombre de clients lourds, il peut être judicieux d'équiper le se3 de plusieurs cartes réseaux 1Gbs et de faire
une agrégation de liens (en mode balance-tlb ou en mode balance-alb).

## Installation de LTSP

* Se connecter au serveur SE3 en tant que root (en ssh par exemple).
* Pour obtenir des clients lourds avec le bureau Ubuntu Xenial Mate, rendre le script suivant executable :
```sh
chmod u+x /home/netlogon/clients-linux/ltsp/Xenial_LTSP_sur_SE3_wheezy.sh
```
ou, pour un bureau Debian Jessie Mate :
```sh
chmod u+x /home/netlogon/clients-linux/ltsp/Jessie_LTSP_sur_SE3_wheezy.sh
```

* Puis l'exécuter :
```sh
/home/netlogon/clients-linux/ltsp/Xenial_LTSP_sur_SE3_wheezy.sh
```
ou, pour un bureau Debian Jessie Mate :
```sh
/home/netlogon/clients-linux/ltsp/Jessie_LTSP_sur_SE3_wheezy.sh
```

Pendant l'installation (qui dure environ une heure), il est demandé :
* Le mot de passe du `compte root de l'environnement des clients lourds`
* Le mot de passe du `compte local enseignant`

**Attention !!!**
Avec le bureau `Ubuntu`, **les mots de passe saisis** sont avec un **clavier querty** (la locale est changée pendant l'installation)

## Que fait le script d'installation ?

Le script d'installation précédent va seulement :
* créer un répertoire `/opt/ltsp/i386` qui contiendra l'environnement (le chroot) des clients lourds Debian Jessie ou Ubuntu Xenial.
* installer et configurer les services `NFS et NBD` qui mettra à disposition des clients lourds leur environnement i386.
* créer un répertoire `/tftpboot/ltsp` contenant l'initrd et le kernel pour le boot PXE des clients lourds.
* ajouter une entrée au menu PXE `/tftpboot/pxelinux.cfg/default` afin qu'un utilisateur puisse faire démarrer un PC en client lourd LTSP.
* configurer l'environnement i386 des clients lourds pour réaliser l'`identification des utilisateurs avec l annuaire ldap du se3` 
et `le montage automatique de deux partages Samba du se3 (Docs et Classes)`.

Seul **un service supplémentaire** va être lancé sur le serveur se3, ce sera :
* le service nfs si c'est le bureau Debian Jessie Mate qui est installé dans l'environnement des clients lourds.
* le service nbd si c'est le bureau Ubuntu Xenial Mate qui est installé dans l'environnement des clients lourds.

L'environnement des clients lourds est configuré pour être au maximum **autonome** et **impacter au minimum le serveur se3**. 
Par soucis de simplicité, **un seul environnement** en architecture i386 est construit pour l'ensemble du parc : cet environnement 
devra contenir toutes les applications utiles aux utilisateurs et sera utilisé à la fois par les clients lourds i386 et amd64.

## nfs et nbd, quelle différence ?
nfs et nbd sont deux services utilisés pour desservir via le réseau ethernet, l'environnement (le chroot) aux clients lourds.
nfs est plus souple mais moins performant que nbd : il est utilisé par défaut sur Debian contrairement à Ubuntu qui utilise nbd.

## Comment administrer le serveur LTSP ?

L'administration du service LTSP consiste principalement à personnaliser l'environnement i386 des clients lourds (le chroot).
Pour administrer simplement l'environnement des clients lourds, un ensemble de scripts est à disposition dans le partage Samba du se3 `Clients-linux/ltsp/administrer`.

Toutes les tâches d'administration peuvent se faire à partir d'un client lourd du réseau, en se connectant avec le **compte admin du se3** (ce compte est le seul à avoir accès au partage précédent).

* Se connecter sur un client lourd du réseau, avec le compte admin du se3.
* Se rendre dans le partage Samba du se3 `Clients-linux/ltsp/administrer` accessible depuis le bureau du compte admin du se3.

Ce repertoire contient un ensemble de script qu'il est possible de lancer très simplement en double-cliquant dessus.

Voici une description du rôle et du fonctionnement de ces scripts :

1. `construire_squashfs_image.sh` :

	Ce script construit l'image squashfs des clients lourds, lorsque le service nbd est utilisé.

	Il doit être lancé **uniquement** avec `Ubuntu`, **au moins une fois à la fin** des tâches d'administration.

	Il entraîne l'arrêt du service nbd : il doit donc être lancé **lorsqu'aucun client lourd n'est utilisé**.

2. `deployer_mes_lanceurs.sh` :

	Ce script permet de personnaliser le bureau des clients lourds.
	* Créer sur votre bureau les lanceurs que vous voulez voir apparaître sur le bureau de vos clients.
	* Double-cliquer sur le script `deployer_mes_lanceurs.sh`
	* Si la distribution Ubuntu est utilisée, reconstruire l'image squashfs (attention, tous les clients lourds seront automatiquement déconnectés).

3. `deployer_mon_skel.sh` :

	Ce script permet de personnaliser le "home" par défaut des utilisateurs de client lourd.
	* Personnaliser vos applications (votre navigateur web par exemple).
	* Repérer les dossiers de configuration de vos application (par exemple, `/home/admin/.mozilla` pour le navigateur firefox).
	* Copier ces dossiers dans le partage Samba du se3 `Clients-linux/ltsp/skel`, accessible depuis le bureau du compte admin du se3.
	* Double-cliquer sur le script `deployer_mon_skel.sh`
	* Si la distribution Ubuntu est utilisée, reconstruire l'image squashfs (attention, tous les clients lourds seront automatiquement déconnectés).

4. `deployer_imprimantes.sh` :

	Ce script permet d'installer les pilotes d'imprimantes dont vous disposez le fichier ppd.
	* Lancer l'outil de configuration graphique des imprimantes disponible sur votre client lourd.
	* Configurer toutes les imprimantes de votre réseau, restreindre éventuellement les droits à certains groupes d'utilisateurs.
	Le mot de passe du compte root des clients lourds (saisi pendant l'installation de ltps sur le se3) vous est demandé.
	* Tester l'impression sur vos imprimantes.
	* Si tout est fonctionnel, double-cliquer sur le script `deployer_imprimantes.sh`.
	* Si la distribution Ubuntu est utilisée, reconstruire l'image squashfs (attention, tous les clients lourds seront automatiquement déconnectés).

5. `sauvegarder_chroot_actuel.sh` :

	Ce script réalise une sauvegarde sans compression dans `/var/se3/ltsp` de l'environnement actuel (le chroot) des clients lourds.
	
	Si une sauvegarde précédente existe déjà dans `/var/se3/ltsp`, cette dernière sera au préalable déplacée dans `/var/se3/ltsp/precedentes`.
	
	Il peut être lancé dès que votre environnement est fonctionnel et configuré comme vous le souhaitez.
	
	La sauvegarde prend quelques minutes.

6. `restaurer_derniere_sauvegarde.sh` :

	Ce script restaure la dernière sauvegarde de votre environnement (chroot).
	
	Il peut être lancé si vous constatez que votre environnement n'est plus fonctionnel après des opérations de maintenance effectuées.
	
	La restauration prend quelques secondes.

7. `restaurer_sauvegarde_originale.sh` :

	Ce script restaure la première sauvegarde de votre environnement : celle qui a été faite juste 
	à la fin du script d'installation de ltsp sur le se3 (dans `/var/se3/ltsp/originale/`)
	
	Cela permet de refaire une configuration de l'environnement des clients lourds, en `"repartant de zéro"`.
	
	Cette restauration prend quelques secondes.

8. `supprimer_sauvegardes_sauf_derniere.sh` :

	Ce script supprime toutes les sauvegardes stockées dans `/var/se3/ltps/precedente`.
	
	Seule la dernière sauvegarde réalisée, stockée dans `/var/se3/ltsp/`, n'est pas supprimée.

9. `installer_des_applis.sh` :

	Ce script permet d'installer très rapidement une liste d'applications installables via l'outil "apt-get".
	
	Avant de lancer le script, il est conseillé de tester le "bon déroulement" des installations en les testant sur un client lourd en fonctionnement.
	* ouvrir un terminal graphique et se connecter avec le compte root des clients lourds :
	```sh
	su root
	```
	* puis saisir le mot de passe root renseigné durant l'installation de ltsp sur le serveur se3.
	* effectuer l'installation des applications :
	```sh
	apt-get install -f appli1 appli2 appli3 appli4 ...
	```

	**Remarque :**

	Cette installation n'est pas persistente car l'environnement des clients lourds "en fonctionnement" 
	est **en lecture seule** : au prochain démarrage du client lourd, les applications installées auront disparu ...

	Par contre, cette installation permet de se placer "dans les mêmes conditions" que dans le "chroot" : si elle se déroule convenablement,
	il y a de très forte chance que l'execution du script `installer_mes_applis.sh` se passe aussi bien.

	* si la commande précédente s'est exécutée sans erreur, lancer le script `installer_mes_applis.sh` puis resaisir la même liste d'applications :
	```sh
	appli1 appli2 appli3 appli4 ...
	```
		
	* Si la distribution `Ubuntu` est utilisée, reconstruire l'image squashfs (attention, tous les clients lourds seront automatiquement déconnectés).
