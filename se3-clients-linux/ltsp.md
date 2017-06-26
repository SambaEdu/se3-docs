# Installation du service LTSP - Client lourd (fat client) sur un serveur Samba Edu 3

## Introduction :

Cette documantation explique comment `intégrer le service ltsp` à un serveur Samba Edu 3 puis comment l'`administrer` simplement.

Tout PC disposant d'une carte ethernet avec un boot PXE et d'au moins 512 Mo de RAM pourra démarrer en tant que clients lourds (mode fat client) 
grâce au réseau ethernet et sans avoir besoin de son disque dur.

Le bureau des clients lourds retenu est Mate, pour sa légereté, et pourra être sous la distribution :
* soit `Ubuntu Xenial`.
* soit `Debian Stretch`.

L'environnement des clients lourds étant isolé dans un `chroot`, il est ainsi possible de faire tourner les clients lourds avec les dernières versions 
de Debian (Stretch) et d'Ubuntu (Xenial) alors que le serveur se3 est sous Debian Wheezy.

A noter : la version Stretch de Debian ne prend plus en charge les architectures i486 et i586. Les PCs du réseau ayant cette architecture
matérielle ne pourront donc pas démarrer en tant que client lourd ltsp.

Le démarrage d'un PC en `mode client lourd` peut :
* être laissé **au choix de l'utilisateur** via le menu PXE du se3 qui apparaît pendant quelques secondes au démarrage : 
c'est la configuration mise en place par défaut par le script d'installation de ltsp.
* être **automatique** pour tous les PC PXE du réseau pédagogique, après les quelques secondes où s'affiche le menu PXE 
(voir la rubrique "Administrer" pour mettre en place simplement cette configuration)

La configuration ltsp appliquée au serveur Se3 l'impacte peu :
* seuls deux services supplémentaires sont exécutés sur le se3 : les services nfs et nbd.
* l'environnement (chroot) des clients lourds est configuré afin de les rendre `autonomes` du se3 ; en particulier, l'identification 
des utilisateurs est réalisée par l'environnement (chroot) des clients lourds et non sur le serveur se3.
* les clients lourds **ne font pas partie d'un sous-réseau** du réseau pédagogique : ltsp est configuré ici en mode `1 carte réseau` pour faciliter 
sa mise en place : il **n'est pas nécessaire** d'équiper le se3 d'une 2ème carte réseau, **ni** d'investir dans un commutateur réseau dédié au sous-réseau 
de clients lourds : tout PC ayant un boot PXE et relié au réseau pédagogique pourra démarrer en client lourd, n'importe où dans l'établissement.
* le serveur Se3 **n'a pas** besoin d'être très puissant car ltsp est configuré ici pour n'être qu'un `serveur d'environnement ltsp`
et ne **gérer que des clients lourds** (fat client) : pour pouvoir gérer aussi des clients légers (commme des Raspberry avec le projet Berryterminal), 
il faudra installer un `serveur d'applications ltsp` **puissant**, en plus du se3. Ce dernier ne devra pas nécessairement tourner 
sous Debian Wheezy : il pourra tourner sous `Debian Stretch` (ou sur Ubuntu Xenial ?).
On pourra se reporter à l'article suivant pour plus de détail (paragraphe `Mise en place d'un cluster de serveurs LTSP`) :

[Wiki de la DANE Versailles LTSP sur Debian Wheezy](http://wiki.dane.ac-versailles.fr/index.php?title=Installer_un_serveur_de_clients_l%C3%A9gers_%28LTSP_sous_Debian_Wheezy%29_dans_un_r%C3%A9seau_Se3)


La configuration de l'environnement des clients lourds appliquée ici s'appuie sur le paragraphe 11.6 de l'ANNEXE "Rendre les `clients lourds complétement autonomes` du serveur LTSP)" de l'article suivant :

[Wiki de la DANE Versailles LTSP sur Debian Jessie](http://wiki.dane.ac-versailles.fr/index.php?title=Installer_un_serveur_de_clients_l%C3%A9gers_%28LTSP_sous_Debian_Jessie%29_dans_un_r%C3%A9seau_Se3)


## Pourquoi installer le service ltsp sur un se3 ?

Les utilisations peuvent être nombreuses. Par exemple :

* **faciliter** la gestion d'un parc informatique, la maintenance du parc se limitant à l'environnement (chroot) construit pour tous les clients lourds sur le serveur se3.
* disposer d'un **mode de démarrage réseau "de secours"** pour l'ensemble de son parc : tout pc disposant d'une carte réseau pxe pourra démarrer grâce au réseau.

## Pre-requis

* Le serveur `Se3` **doit** être sous `Debian Wheezy` et disposait d'au moins une `carte 1 Gbs` relié à un port 1 Gbs d'un commutateur réseau.
* Les modules `Serveur DHCP` (se3-dhcp), `Support des clients GNU/Linux` (se3-clients-linux) et `Sauvegarde / Clonage - Restauration de stations` (se3-clonage) doivent être activés sur le se3. 
* La partition `racine /` doit disposer d'environ `15 Go` pour contenir l'environnement (chroot) des clients lourds.
* La partition `/var/se3` doit disposer d'environ `10 Go` pour contenir la sauvegarde originale du chroot faite pendant l'installation.
* Le service ltsp est configuré en "mode client lourd" **uniquement** : autrement dit, le `serveur se3` n'a donc pas besoin d'être très puissant car
les applications sont exécutés avec les ressources des clients lourds. C'est surtout les **accès en lecture au(x) disque(s) dur(s)** qui vont être 
sollicités sur le se3 (service **nfs ou nbd**) : si le choix se présente, il est donc préférable d'opter dans un `disque dur SSD`
ou des disques durs SATA mais montés en RAID 0 (ou RAID 5) pour augmenter le débit des accès aux disques durs du se3.
* La carte réseau des clients lourds doit être au moins de 100 Mbs et reliée à un port pédagogique 100 Mbs (ou plus) d'un commutateur réseau.
* Il faut éviter de mettre trop de commutateurs réseau en série (en cascade) afin d'éviter de diminuer la vitesse de leur port 1 Gbs.
* D'une façon générale, le réseau ethernet pédagogique doit être "en bon état" car il va être assez sollicité par l'ensemble des clients lourds en fonctionnement.

**Remarque :**

Pour desservir un très grand nombre de clients lourds, il peut être judicieux d'équiper le se3 de plusieurs cartes réseaux 1Gbs et de faire
une `agrégation de liens` (en mode balance-tlb ou en mode balance-alb).

## Installation de LTSP

* Se connecter au serveur SE3 en tant que root (en ssh par exemple).
* Télécharger le dernier script disponible sur github à l'endroit suivant :
```sh
wget https://raw.githubusercontent.com/SambaEdu/se3-clients-linux/master/src/home/netlogon/clients-linux/ltsp/LTSP_sur_SE3_wheezy.sh
```

Par défaut, c'est l'architecture i386 et debian stretch qui est déployé mais il est possible de changer cela avec les deux variables de début de script.
Par exemple, pour construire un environnement Ubuntu Xenial en architecture 64 bits, modifié les deux variables de la façon suivante :
```sh
ENVIRONNEMENT=amd64
DISTRIB=xenial
```

* Puis exécuter le script :
```sh
./LTSP_sur_SE3_wheezy.sh
```

Pendant l'installation (qui peut durer une heure), il est demandé, dans l'ordre :
* Le mot de passe du compte `root` de l'environnement des clients lourds
* Le mot de passe du compte `local` enseignant

**Attention !!!**

Sous `Ubuntu`, **les mots de passe saisis** sont avec un **clavier querty** (la locale est changée pendant l'installation)

**Remarque :**
Ce scritp peut être éxécuté plusieurs fois sur le se3 (le script est idempotent). Il est par exemple possible de le lancer une 1ère fois en stretch i386 
puis une 2de fois en xenial amd64 afin de disposer de deux environnements différents.

## Que fait le script d'installation ?

Le script d'installation précédent va seulement :
* créer un répertoire `/opt/ltsp/i386` (ou `/opt/ltsp/amd64`)  qui contiendra l'environnement (le chroot) des clients lourds Debian ou Ubuntu.
* installer et configurer les services `NFS et NBD` afin que les clients lourds puissent monter, via le réseau, leur environnement à leur démarrage.
* créer un répertoire `/tftpboot/ltsp` contenant l'initrd et le kernel pour le boot PXE des clients lourds.
* ajouter une entrée au menu PXE `/tftpboot/pxelinux.cfg/default` afin qu'un utilisateur puisse faire démarrer un PC en client lourd LTSP.
* configurer l'environnement i386 (ou amd64) des clients lourds pour réaliser l'`identification des utilisateurs avec l annuaire ldap du se3` 
et `le montage automatique de deux partages Samba du se3 (Docs et Classes)`.
* créer une sauvegarde, à la fin de l'installation, de l'environnement des clients lourds dans /var/se3/ltsp/i386-originale : cela permettra 
de restaurer le chroot des clients lourds en 5 minutes, en cas de problèmes lors de son administration.

Seulement ** deux services supplémentaires ** sont lancés sur le serveur se3 :
* le service nbd accessible depuis le menu PXE du se3 par tous les utilisateurs de clients lourds du réseau.
* le service nfs accessible depuis le sous-menu `divers` du menu maintenance du se3, pour tester des installations dans l'environneement des clients lourds.

L'environnement des clients lourds est configuré pour être au maximum **autonome** et **impacter au minimum le serveur se3**. 
Par défaut, par souci de simplicité, **un seul environnement** en architecture i386 est construit pour l'ensemble du parc : cet environnement 
devra contenir toutes les applications utiles aux utilisateurs et sera utilisé à la fois par les clients lourds i386 et amd64.

## Quelles applications seront disponibles sur les clients lourds ?
En plus des applications disponibles par défaut sur le bureau mate, il est installé dans l'environnement des clients lourds :
* des applications pour l'enseignement d'informatique ICN/ISN : python avec pygame, blocly-arduino, mblock, processing, wireshark, sonic-pi.
* des applications pour l'enseignement des mathmétiques : geogebra 5, algobox, xcas, scilab, python, scratch.
* et plein d'autres applications ... à décrouvrir !

## xenial et stretch, quelle différence ?
L'environnement Debian stretch est plus récent (Juin 2017) que celui d'Ubuntu Xenial (Avril 2016). 
Certaines applications (telles que Scratch 2 ou OpenSankore) ne sont parfois fonctionnels que sur l'un (xenial) et pas sur l'autre.

## i386 et amd64, quelle différence ?
Si tous les PC bootable PXE du réseau sont en architecture amd64 (64 bits), il est conseillé de construire un environnement amd64 pour les clients lourds
car certaines applications (telles que OpenBoard ou mBlock) ne sont parfois disponibles qu'en architecture 64 bits.

## nfs et nbd, quelle différence ?

## nfs et nbd, quelle différence ?
nfs et nbd sont deux services utilisés pour desservir (via le réseau ethernet) l'environnement aux clients lourds.
nfs est plus souple mais moins performant que nbd : nfs ne nécessite pas de reconstruire l'image squashfs avec la commande ltsp-update-image.
C'est pourquoi on le concerve dans un sous-menu du menu maintenance du PXE du se3, afin de pouvoir faire des tests plus rapidement.

## Comment administrer le serveur LTSP ?
L'administration du service LTSP consiste principalement à personnaliser l'environnement i386 (ou amd64) des clients lourds.

Cette administration peut se faire simplement en ligne de commande en se connectant en root au se3 (via ssh par exemple) puis en se mettant sur 
la racine de l'environnement (le "chroot") des clients lourds avec une des deux commandes suivantes :

```sh
ltsp-chroot -a i386		   # ou ltsp-chroot -a amd64 (si c'est l'architecture amd64 qui a été choisie)
```

ou

```sh
ltsp-chroot -a -m i386     # ou ltsp-chroot -a -m amd64 (si c'est l'architecture amd64 qui a été choisie)
```

Une fois l'administration terminée, sortir du chroot avec la commande :

```sh
exit
```

Pour tester l'installation réalisée dans le chroot, démarrer un client lourd via le sous-menu `divers` du menu maintenance du PXE du se3 (nfs est ainsi utilisé).
Si tout fonctionne correctement, reconstruire l'image squashfs en saisissant sur le se3, en tant que root :
```sh
ltsp-update-image i386     # ou ltsp-update-image amd64 (si c'est l'architecture amd64 qui a été choisie)
```

**Remarques:**

* l'option -m permet de monter dans le chroot deux répertoires du se3 (/dev et /proc) : elle est parfois nécessaire à certaines installations dans le chroot. 

* Toutes les commandes shell exécutables sur un client linux "classique" peuvent "en principe" être éxécutés dans ce chroot et s'appliquer à tous les clients lourds du réseau.

Pour faciliter l'administration, un ensemble de scripts est à disposition dans le partage Samba du se3 `Clients-linux/ltsp/administrer`.
Ces scripts ne sont fonctionels que pour un chroot en architecture i386.
Se reporter à l'annexe pour une description.

## Comment personnaliser le "home" de l'utilisateur ?
Il existe deux endroits sur le serveur se3 qui permettent de personnaliser le "home" de l'utilisateur

* /opt/ltsp/i386[ou amd64]/etc/skel
Tous les fichiers et répertoires déposés dans ce répertoire sont copiés via le réseau **à chaque ouverture** de session et **pour chaque utilisateur** dans son home.
Il est donc important que la taille de ce répertoire ne soit pas très importante (10 Mo au plus).

* /opt/ltsp/i386[ou amd64]/etc/skel2
Tous les répertoires de ce dossier doivent avoir les droits 755.
Tous les répertoires déposés dans ce dossier seront copiés via le réseau **uniquement à la 1ère ouverture** de session et **pour chaque utilisateur** dans son partage //Docs/.i386/ sur le se3.
Ces répertoires sont ainsi rendus "persistants" et personnalisables par l'utilisateur.
Il est possible d'y mettre les répertoires qui ont une taille importantes (.mozilla et .wine par exemple) et qu'on souhaite rendre personnalisables par l'utilisateur.
A l'ouverture de session, le script /usr/local/bin/logon.sh sur le client lourd est automatiquement lancé par l'utilisateur qui se loggue et se charge de faire cette copie.
Un fichier de log de ce script est présent dans /home/$USER/.logon.log

Ainsi, pour personnaliser le profil firefox et le rendre personnalisable, il suffit :
- de se logguer sur un client lourd avec le compte admin par exemple.
- de lancer l'application que l'on souhaite personnaliser, par exemple firefox et de la personnaliser (en installant le plugin codeblender pour que blockly-arduino soit fonctionnel par exemple).
- de repérer dans /home/admin le répertoire de conf de l'application, pour firefox, c'est .mozilla.
- de vérifier que le répertoire de conf de l'application a les droits 755.
- d'ouvrir un terminal et d'adapter la commande suivante :

```sh
rsync -avz --delete-after /home/admin/.mozilla root@ip_du_se3:/opt/ltsp/i386/etc/skel2/
``` 
 
## Comment désactiver ltsp sur le se3 ?
Il suffit simplement de désactiver les deux services nfs-kernel-server et nbd-server en saisissant sur le se3, en tant que root, les commandes suivantes :

```sh
update-rc.d nfs-kernel-server disable
update-rc.d nbd-server disable
```

## TODO : derniers points à régler ##

* Certains éléments du home de l'utilisateur (ceux déposés dans /opt/ltsp/i386/etc/skel2 sur le serveur se3) sont personnalisables et rendus persistants dans le partage //Docs/.i386 de l'utilisateur
Comment gérer une mise à jour d'un élément de /opt/ltsp/i386/etc/skel2 autrement qu'en faisant, sur le se3, en tant que root, un :
```sh
rm -rf --one-file-system /home/*/Docs/.i386/repertoire_a_mettre_a_jour
```
Peut-être créant un fichier texte de version dans chaque /opt/ltsp/i386/etc/skel2/repertoire/ ?

* La "mise à jour" du module se3-clonage (ou certaines actions dans le menu tftp de l'interface web du se3) va faire perdre le menu PXE suivant :

`Démarrer le PC en client lourd LTSP`

Ce qui privera tout PC de booter en tant que client ltsp.

Afin de pouvoir le restaurer rapidement, il est conseillé après l'installation du serveur ltsp de faire une copie du fichier suivant : `/tftpboot/pxelinux.cfg/default`

* Chaque client ltsp crée dynamiquement à son démarrage son nom d'hôte (`hostname`) à partir de son adresse IP (ou MAC ?) : les clients ltsp auront 
des noms d'hote de la forme `ltsp553`, `ltsp137`, ...
Si ces clients ont déjà été réservés dans le dhcp du se3, cela va créer des `doublons` dans l'annuaire ldap du se3 qu'il est possible de supprimer 
via l'interface web du se3 (`Gestion des parcs -> Recherche -> Recherche des doublons`).

Une solution pour éviter l'apparition de ces doublons serait d'ajouter la directive suivante à la rubrique `GENERAL OPTIONS` du fichier `/etc/dhcp/dhcpd.conf` du se3 :
```sh
use-host-decl-names on; 
```
Avec cette directive, le serveur dhcp du se3 indique au client dhcp de chaque PC ayant son adresse IP de réservée, d'utiliser comme nom d'hôte celui qui apparaît dans 
le fichier dhcpd.conf du se3 à côté de la rubrique `host` de sa réservation.
En principe (?), ce nom est identique à celui stocké dans la branche `computers` de l'annuaire ldap du se3. 

Ainsi, un PC qui aura son adresse IP de réservée dans le dhcp du se3 aura le même nom, qu'il boote en client lourd ou en client "classique". 
Si le PC n'a pas son adresse IP de réservée, le client lourd prendra un nom de la forme `ltsp553` ...

Tout comme le module se3-clonage, **toute mise à jour (ou action) faite** sur le serveur `dhcp `via l'interface web du se3 fera perdre cette directive ...

Il est néanmoins possibible de créer un script qui ajoutera automatiquement cette ligne dans le fichier /etc/dhcp/dhcpd.conf si elle est absente.
Ce script peut être ajouté en tache cron au se3.
```sh 
#!/bin/bash

#le contenu de la ligne 18 est mis dans une variable ligne18
ligne18=$(sed -n "18 p" /etc/dhcp/dhcpd.conf)

#si le contenu de la ligne 18 est "use-host-decl-names on;" on ne fait rien sinon on lance l'ajout de 'use-host-decl-names on;' suivi de la relance du service dhcd
if [ "$ligne18" = 'use-host-decl-names on;' ]; then  exit

else    sed -i "18i\use-host-decl-names on;\n" /etc/dhcp/dhcpd.conf
service isc-dhcp-server restart
fi
exit 0
```

## ANNEXE ##
Ces scripts sont accessibles à partir d'un client lourd du réseau, en se connectant avec le **compte admin du se3** (ce compte est le seul à avoir accès au partage précédent).
Il ne sont fonctionnels que pour un chroot construire en architecture i386.

* Se connecter sur un client lourd du réseau, avec le compte admin du se3.
* Se rendre dans le partage Samba du se3 `Clients-linux/ltsp/administrer` accessible depuis le bureau du compte admin du se3.

Ce repertoire contient un ensemble de script qu'il est possible de lancer très simplement en double-cliquant dessus puis en cliquant sur `Lancer`

Voici une description du rôle et du fonctionnement de ces scripts :

1. `construire_squashfs_image.sh` :

	Ce script construit l'image squashfs des clients lourds, lorsque le service nbd est utilisé.

	Il entraîne l'arrêt du service nbd : il doit donc être lancé **lorsqu'aucun client lourd n'est utilisé**.

2. `deployer_mes_lanceurs.sh` :

	Ce script permet de personnaliser le bureau des clients lourds.
	* Créer sur votre bureau les lanceurs que vous voulez voir apparaître sur le bureau de vos clients.
	* Double-cliquer sur le script `deployer_mes_lanceurs.sh`

3. `deployer_mon_skel.sh` :

	Obsolète : à ne pas utiliser.
	
4. `deployer_imprimantes.sh` :

	Ce script permet d'installer les pilotes d'imprimantes dont vous disposez le fichier ppd.
	* Lancer l'outil de configuration graphique des imprimantes disponible sur votre client lourd.
	* Configurer toutes les imprimantes de votre réseau, restreindre éventuellement les droits à certains groupes d'utilisateurs.
	Le mot de passe du compte root des clients lourds (saisi pendant l'installation de ltps sur le se3) vous est demandé.
	* Tester l'impression sur vos imprimantes.
	* Si tout est fonctionnel, double-cliquer sur le script `deployer_imprimantes.sh`.

5. `sauvegarder_chroot_actuel.sh` :

	Ce script réalise une sauvegarde sans compression dans `/var/se3/ltsp` de l'environnement actuel (le chroot) des clients lourds.
	
	Si une sauvegarde précédente existe déjà dans `/var/se3/ltsp`, cette dernière sera au préalable déplacée dans `/var/se3/ltsp/precedentes`.
	
	Il peut être lancé dès que votre environnement est fonctionnel et configuré comme vous le souhaitez.
	
	La sauvegarde prend quelques minutes.

6. `restaurer_derniere_sauvegarde.sh` :

	Ce script restaure la dernière sauvegarde de votre environnement (chroot).
	
	Il peut être lancé si vous constatez que votre environnement n'est plus fonctionnel après des opérations de maintenance effectuées.
	
	La restauration prend quelques minutes.

7. `restaurer_sauvegarde_originale.sh` :

	Ce script restaure la première sauvegarde (stockée dans `/var/se3/ltsp/originale/`) de l'environnement : celui qui a été créé par le script
	d'insllation de ltsp sur votre se3.
	
	Cela permet de refaire une configuration de l'environnement des clients lourds, en `repartant de l'environnement "original"`.
	
	Cette restauration prend quelques minutes.

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

	Par contre, cette installation permet de se placer "dans les mêmes conditions" que dans le "chroot" des clients lourds : si elle se déroule convenablement,
	il y a de très forte chance que l'execution du script `installer_mes_applis.sh` se passe aussi bien.

	* si la commande précédente s'est exécutée sans erreur, lancer le script `installer_mes_applis.sh` puis ressaisir la même liste d'applications :
	```sh
	appli1 appli2 appli3 appli4 ...
	```
	
10. `choisir_boot_par_defaut.sh`
	
	Ce script permet de choisir le mode de démarrage par défaut des PC qui bootent avec leur carte réseau PXE sur le réseau pédagogique.
	
	Deux choix possibles :
	
	* `1` : en saisissant cette valeur, les `PC PXE booteront par défaut avec leur disque dur`, après les quelques secondes d'affichage du menu PXE.
	* `2` : en saisissant cette valeur, les `PC PXE booteront par défaut en client lourd ltsp`, après les quelques secondes d'affichage du  menu PXE.
