# Installation automatique d'un `Se3`

…article en chantier…

* [Préliminaires](#préliminaires)
    * [Objectif](#objectif)
    * [Étapes de l'installation automatique d'un `se3`](#Étapes-de-linstallation-automatique-dun-se3)
* [Phase 1 : Les fichiers `preseed` et `setup_se3`](#les-fichiers-preseed-et-setup_se3)
    * [Création des fichiers `preseed` et `setup_se3`](#création-des-fichiers-preseed-et-setup_se3)
    * [Téléchargement des fichiers](#téléchargement-des-fichiers)
    * [Modification du fichier `preseed`](#modification-du-fichier-preseed)
    * [Téléchargement et modifications de fichiers pour la phase 3](#téléchargement-et-modifications-de-fichiers-pour-la-phase-3)
    * [Incorporer le fichier `preseed` à l'archive d'installation](#incorporer-le-fichier-preseed-à-larchive-dinstallation)
      * [Téléchargement de l'installateur `Debian`](#téléchargement-de-linstallateur-debian)
      * [Mise en place des éléments pour l'incorporation](#mise-en-place-des-éléments-pour-lincorporation)
         * [Création des répertoires de travail **isoorig** et **isonew**](#création-des-répertoires-de-travail-isoorig-et-isonew)
         * [Dans le répertoire **isoorig**](#dans-le-répertoire-isoorig)
         * [Dans le répertoire **isonew**](#dans-le-répertoire-isonew)
* [Phase 2 : Utiliser l'archive d'installation personnalisée](#utiliser-larchive-dinstallation-personnalisée)
    * [Sur un réseau virtuel](#sur-un-réseau-virtuel)
    * [Sur un `CD`](#graver-un-cd)
    * [Sur une clé `usb`](#utiliser-une-clé-usb)
* [Phase 3 : installation du paquet SE3](#ne fonctionne pas automatiquement)
* [Solution alternative](#solution-alternative)
* [Références](#références)


## Préliminaires


### Objectif

L'objectif est de créer un `CD d'installation` ou une clé `usb` complètement automatisé de son `SE3 Wheezy`.

Ainsi, avec ce `CD`, ou cette clé `usb`, *personnalisé* et une sauvegarde de son `SE3`, on pourra très rapidement (re)-mettre en production son `SE3`, que ce soit sur la même machine ou sur une autre machine.

Pour la sauvegarde du `SE3`, vous consulterez avec profit [la documentation ad hoc](../se3-sauvegarde/sauverestaure.md#sauvegarder-et-restaurer-un-serveur-se3).


### Étapes de l'installation automatique d'un `se3`

L'installation automatique d'un `se3` se déroule en 3 phases :
* **Phase1 :** création des fichiers **se3.preseed** et **setup_se3.data**
* **Phase2 :** installation du système d'exploitation `Debian` via le fichier **se3.preseed**
* **Phase3 :** installation du paquet `se3` et consorts

Pour la description de chaque phase, vous consulterez [la documentation ad hoc](http://wwdeb.crdp.ac-caen.fr/mediase3/index.php/Installation_sous_Debian_Wheezy_en_mode_automatique).

Il s'agit, dans ce qui suit, de minimiser la manipulation des divers fichiers nécessaires lors de l'installation, en les incorporant, une fois pour toute, dans l'archive de l'installateur.

Ainsi, les 3 phases pourront s'enchaîner automatiquement ; **travail encore en chantier actuellement puisque nous sommes dans une phase de mise au point de ce projet d'automatisation**.


## Phase1 : Les fichiers `preseed` et `setup_se3`

### Création des fichiers `preseed` et `setup_se3`

La phase 1 consiste à créer le fichier `preseed` (nommé ici **se3.preseed**) et le fichier **setup_se3.data** en utilisant [l'interface-outil de configuration](http://dimaker.tice.ac-caen.fr/dise3xp/se3conf-xp.php?dist=wheezy).

On pourra bien entendu utiliser un fichier **se3.preseed** existant, dans le cas d'une migration ou d'une ré-installation ou tout simplement par précaution : *mieux vaut prévenir que guérir*… Il y aura éventuellement des modifications à apporter en fonction des évolutions, que ce soit du point de vue des versions de `se3`, ou du point de vue du matériel, ou encore d'une optimisation des paramètres de ces fichiers.


### Téléchargement des fichiers

Une fois les fichiers **se3.preseed** et **setup_se3.data** ainsi créés, il s'agira de les télécharger en remplaçant les xxxx par le nombre qui convient (voir message de l'interface de création) :
```sh
wget http://dimaker.tice.ac-caen.fr/dise3wheezy/xxxx/se3.preseed http://dimaker.tice.ac-caen.fr/dise3wheezy/xxxx/setup_se3.data
```


### Modification du fichier `preseed`

pour une automatisation complète, il faut effectuer des modifications dans le fichier **se3.preseed** :

On l'édite :
```sh
nano se3.preseed
```

…quelques lignes à modifier :

**Pour la langue**, modifiez les lignes correspondantes :
```sh
# MODIFIE
# langue et pays
d-i localechooser/shortlist	select	FR
d-i debian-installer/locale string fr_FR.UTF-8
d-i debian-installer/language string fr
d-i debian-installer/country string FR
```
Attention : bugs dans le preseed de dimaker…
```sh
# Choix des parametres regionaux (locales)
d-i     debian-installer/locale                            string fr_FR.UTF-8
d-i     debian-installer/supported-locales                 string br_FR.UTF-8, en_US.UTF-8
d-i     debian-installer/locale                            string fr_FR.UTF-8
```
pourquoi une ligne est presente 2 fois ? Pourquoi il y avait br au lieu de fr dans la ligne du milieu ??
→ ce doit être un bug : outil de création du preseed à modifier ? 

**Pour le clavier**, modifications des lignes correspondantes :
```sh
#MODIFIE
# clavier
d-i console-keymaps-at/keymap select fr-latin9
d-i debian-installer/keymap string fr-latin9
d-i console-setup/modelcode string pc105
d-i console-setup/layoutcode string fr
```

**Pour un script inutile**, commentez la ligne :
```sh
#MODIFIE, pour éviter un problème de fichier corrompu avec netcfg.sh
#mais cela poses peut être des problèmes par la suite car pas de réseau juste dans l'installateur
#d-i preseed/run string netcfg.sh
```
**NB :** il faudrait éclaircir cela. 
Ce fichier existe nul part dans une install avec preseed d'un wheezy, il a surement été rajouté par ceux qui ont fabriqué l'install du se3. Lorsqu'on l'enlève, il semble que il n'y a pas d'acces reseau pendnant l'execution du preseed mais elle réapparait apres c'est pourquoi j'ai ete oblige de telecharger les fichiers plus loin dans le preseed avant de faire l'install. ceux la : http://dimaker.tice.ac-caen.fr/dise3wheezy/se3scripts
Lorsque je laisse cette ligne, l'installateur bloque avec un message rouge et me dit : le fichier netcfg.sh est corrompu ...
[TODO] remettre les wget dans le preseed à la fin ? lorsque cette command fonctionnera , ce sera possible .
J'ai remarqué de grosses differences entre l'execution de l'iso modifie pour etre completement automatique (qui bloque sur netcfg.sh) et l'iso normal qui s'install avec auto url=://dimaker ... beaucoup de fichiers sont installe en plus dans la 2eme ... entre autre netcfg et killall. Pourquoi ?

**Pour les dépôts**, il faut ajouter ces lignes :
```sh
#AJOUTE, pour indiquer le miroir et eventuellement le proxy pour atteindre le miroir
#Mirror settings
d-i mirror/protocol string http
d-i mirror/country string manual
d-i mirror/http/hostname string ftp.fr.debian.org
d-i mirror/http/directory string /debian
d-i mirror/http/proxy string
d-i mirror/suite string wheezy
```
**NB :** il faudrait que l'outil de création du preseed soit modifié, non ?

**Pour les statistiques**, une  ligne à rajouter :
```sh
#AJOUTE, pour evite de répondre à la question
#Some versions of the installer can report back on what software you have
#installed, and what software you use. The default is not to report back,
#but sending reports helps the project determine what software is most
#popular and include it on CDs.
popularity-contest popularity-contest/participate boolean false
```
**NB :** il faudrait que l'outil de création du preseed soit modifié, non ?

**Pour la mise en place de la phase 3**, modifiez les commandes à la fin :
```sh
#MODIFIE Preseed commands
#----------------
d-i preseed/early_command string cp /cdrom/setup_se3.data ./; \
    cp /cdrom/se3scripts/* ./; \
    chmod +x se3-early-command.sh se3-post-base-installer.sh install_phase2.sh; \
    ./se3-early-command.sh se3-post-base-installer.sh 
```
** je me demande a quoi sert la command chmod +x sur les fichiers, car ils ont deja sur le cd les droits en exécution ... j'ai testé en l'enlevant effectivement elle sert a rien ...

Voila , le fichier **se3.preseed** est pret


### Téléchargement et modifications de fichiers pour la phase 3

Il faut maintenant télécharger les fichiers suivants qui seront aussi nécessaires (cependant on pourrait laisser le fait de les telecharger en modifiant comme à l'origine le preseed mais avant il faut resourdre le probleme de cette ligne : d-i preseed/run string netcfg.sh
```sh
mkdir ./se3scripts
cd se3scripts
wget http://dimaker.tice.ac-caen.fr/dise3wheezy/se3scripts/se3-early-command.sh http://dimaker.tice.ac-caen.fr/dise3wheezy/se3scripts/se3-post-base-installer.sh http://dimaker.tice.ac-caen.fr/dise3wheezy/se3scripts/sources.se3 http://dimaker.tice.ac-caen.fr/dise3wheezy/se3scripts/install_phase2.sh http://dimaker.tice.ac-caen.fr/dise3wheezy/se3scripts/profile http://dimaker.tice.ac-caen.fr/dise3wheezy/se3scripts/inittab http://dimaker.tice.ac-caen.fr/dise3wheezy/se3scripts/bashrc
cd ..
```
Il faudra rajouter inittab dans http://dimaker.tice.ac-caen.fr/dise3wheezy/se3scripts , j'ai deja ajouté la ligne pour le telechargement au dessus [TODO] Sinon, il faudra le fabriquer pour permettre un redémarrage en autologin pour la phase 3…
```sh
nano ./se3scripts/inittab
```
Et copier à l'interieur ceci :
```sh
# /etc/inittab: init(8) configuration.
# $Id: inittab,v 1.91 2002/01/25 13:35:21 miquels Exp $

# The default runlevel.
id:2:initdefault:

# Boot-time system configuration/initialization script.
# This is run first except when booting in emergency (-b) mode.
si::sysinit:/etc/init.d/rcS

# What to do in single-user mode.
~~:S:wait:/sbin/sulogin

# /etc/init.d executes the S and K scripts upon change
# of runlevel.
#
# Runlevel 0 is halt.
# Runlevel 1 is single-user.
# Runlevels 2-5 are multi-user.
# Runlevel 6 is reboot.

l0:0:wait:/etc/init.d/rc 0
l1:1:wait:/etc/init.d/rc 1
l2:2:wait:/etc/init.d/rc 2
l3:3:wait:/etc/init.d/rc 3
l4:4:wait:/etc/init.d/rc 4
l5:5:wait:/etc/init.d/rc 5
l6:6:wait:/etc/init.d/rc 6
# Normally not reached, but fallthrough in case of emergency.
z6:6:respawn:/sbin/sulogin

# What to do when CTRL-ALT-DEL is pressed.
ca:12345:ctrlaltdel:/sbin/shutdown -t1 -a -r now

# Action on special keypress (ALT-UpArrow).
#kb::kbrequest:/bin/echo "Keyboard Request--edit /etc/inittab to let this work."

# What to do when the power fails/returns.
pf::powerwait:/etc/init.d/powerfail start
pn::powerfailnow:/etc/init.d/powerfail now
po::powerokwait:/etc/init.d/powerfail stop

# /sbin/getty invocations for the runlevels.
#
# The "id" field MUST be the same as the last
# characters of the device (after "tty").
#
# Format:
#  <id>:<runlevels>:<action>:<process>
#
# Note that on most Debian systems tty7 is used by the X Window System,
# so if you want to add more getty's go ahead but skip tty7 if you run X.
#
1:2345:respawn:/bin/login -f root tty1 </dev/tty1 >/dev/tty1 2>&1
2:23:respawn:/sbin/getty 38400 tty2
3:23:respawn:/sbin/getty 38400 tty3
4:23:respawn:/sbin/getty 38400 tty4
5:23:respawn:/sbin/getty 38400 tty5
6:23:respawn:/sbin/getty 38400 tty6

# Example how to put a getty on a serial line (for a terminal)
#
#T0:23:respawn:/sbin/getty -L ttyS0 9600 vt100
#T1:23:respawn:/sbin/getty -L ttyS1 9600 vt100

# Example how to put a getty on a modem line.
#
#T3:23:respawn:/sbin/mgetty -x0 -s 57600 ttyS3
```

On met en place l'autologin pour le 1er redémarrage du se3 (début de la phase 3) en modifiant le script se3-post-base-installer.sh :
```sh
nano ./se3scripts/se3-post-base-installer.sh
```

En rajoutant les lignes suivantes a la fin pour la gestion du fichier inittab :
```sh
mv bashrc /target/root/.bashrc
mv /target/etc/inittab /target/etc/inittab.orig
mv inittab /target/etc/inittab
cp /target/etc/inittab /target/root/
```
** dans le fichier la premiere ligne est deja presente, et il y a un probleme avec le fichier sources.list qui n'existe pas (mais pourrait etre telecharge sur se3scripts, un reste d'avant ... ? )tandis que sources.se3 existe mais est vide ... et n'est pas copier ... est il necessaire ?

Et pour supprimer l'autologin lors des redémarrages suivants., on modifie la fin du script install_phase2.sh :
```sh
nano ./se3scripts/install_phase2.sh
```

En rajoutant ces  2 lignes :
```sh
rm -f /etc/inittab
cp /etc/inittab.orig /etc/inittab
```
avant ces 2 lignes (vers la fin du script)
```sh
[ "$DEBUG" != "yes" ] && rm -f /root/install_phase2.sh
. /etc/profile
```


## Incorporer le fichier `preseed` à l'archive d'installation


### Téléchargement de l'installateur `Debian`

Comme nous allons incorporer les fichiers d'installation `Wheezy`, créés et modifiés précédemment, dans un `cd` ou une clé `usb`, il nous faut pour cela une archive `Debian Wheezy`.

Tout d'abord, récupérez une image d'installation de `Debian`. Une image *netinstall* devrait suffire.
```sh
wget http://cdimage.debian.org/cdimage/archive/latest-oldstable/amd64/iso-cd/debian-7.11.0-amd64-netinst.iso
```

Si votre serveur dispose de matériel (carte résau notamment) non reconnus car nécessitant des firmwares non libres, préférez cette image (non testée [TODO]):
```sh
wget http://cdimage.debian.org/cdimage/unofficial/non-free/cd-including-firmware/archive/7.11.0+nonfree/amd64/iso-cd/firmware-7.11.0-amd64-netinst.iso
```
NB : on peut aussi incorporer les firmwares à l'archive [TODO].


#### Mise en place des éléments pour l'incorporation


##### Création des répertoires de travail **isoorig** et **isonew**

Pour mener à bien la modification de l'installateur `Debian`, on va créer deux répertoires :
* **isoorig :** il contiendra le contenu de l'image d'origine
* **isonew :** il contiendra le contenu de votre image personnalisée
```sh
mkdir isoorig isonew
```


##### Dans le répertoire **isoorig**

On monte ensuite, dans le répertoire **isoorig**, l'iso téléchargée , puis on copie son contenu dans le répertoire isonew.
```sh
mount -o loop -t iso9660 debian-7.11.0-amd64-netinst.iso isoorig
rsync -a -H –exclude=TRANS.TBL isoorig/ isonew
```
Cela dit que l'image est montée en lecture seule c'est normal, et il y a une erreur sur TRANS.TBL car il n'existe pas dans l'archive téléchargée, c'est aussi normal. (En fait, ce fichier existe dans d'autres archives) … supprimer cette option ? [TODO]


##### Dans le répertoire **isonew**

Les modifications suivantes seront à réaliser dans le répertoire **isonew**.
On va maintenant faire en sorte que l'installateur se charge automatiquement.
On donne les droits en écriture aux 3 fichiers à modifier :
```sh
chmod 755 ./isonew/isolinux/txt.cfg ./isonew/isolinux/isolinux.cfg ./isonew/isolinux/prompt.cfg
```

On modifie le fichier isolinux/txt.cfg pour l'utilisation du fichier preseed lors de l'installation.
On l'édite :
```sh
nano ./isonew/isolinux/txt.cfg
```

On le modifie ainsi :
```sh
default install
label install
	menu label ^Install
	menu default
	kernel /install.amd/vmlinuz 
	append  auto=true priority=critical language=fr locale=fr_FR.UTF-8 console-setup/layoutcode=fr_FR keyboard-configuration/xkb-keymap=fr languagechooser/language-name=French countrychooser/shortlist=FR console-keymaps-at/keymap=fr debian-installer/country=FR debian-installer/locale=fr_FR.UTF-8 preseed/file=/cdrom/se3.preseed initrd=/install.amd/initrd.gz -- quiet
```
**Remarque :** Veillez à adapter install.amd/initrd.gz selon l'architecture utilisée, ici 64bit. En cas de doute, regardez ce qu'il y a dans le répertoire isoorig.

Ce qui ne marche pas :
```sh
   append auto=true vga=normal file=/cdrom/se3.preseed initrd=/install.amd/initrd.gz -- quiet
```
ou
```sh
append auto=true vga=788 preseed/file=/cdrom/se3.preseed priority=critical lang=fr locale=fr_FR.UTF-8 console-keymaps-at/keymap=fr-latin9 initrd=/install.amd/initrd.gz – quiet
```

Ensuite, éditez **isolinux/isolinux.cfg** et **isolinux/prompt.cfg** :  
changez *timeout 0* en *timeout 4* par exemple et *prompt 0* par *prompt 1*.
```sh
nano ./isonew/isolinux/isolinux.cfg
nano ./isonew/isolinux/prompt.cfg
```

Enfin, on copie les 2 fichiers du preseed à la racine du répertoire isonew et les fichiers se3scripts :
```sh
cp se3.preseed ./isonew/
cp setup_se3.data ./isonew/
mkdir ./isonew/se3scripts
cp ./se3scripts/* ./isonew/se3scripts/
```

Enfin on crée la nouvelle image `ISO` :
```sh
cd isonew
md5sum `find -follow -type f` > md5sum.txt
```
→ ne marche pas, pb avec le lien symbolique… il y a une boucle… (cela provient du lien à propos de .DEBIAN) ceci dit, il n'y a aucun fichier qui sont dans le md5sum.txt (normal, à cause de l'erreur : le travail ne s'est pas fait) qui ont été modifié donc (il faut regarder toutes les causes…) cette étape ne sert à rien il me semble (s'il n'y a pas le lien symbolique .DEBIAN, cela fonctionne !). → en fait l'option -follow est obsolète, il faudrait mettre -L (d'après man find). Ou alors -H si problème avec -L.[TODO]

```sh
apt-get install genisoimage
genisoimage -o ../my_wheezy_install.iso -r -J -no-emul-boot -boot-load-size 4 -boot-info-table -b isolinux/isolinux.bin -c isolinux/boot.cat ../isonew
cd ..
```
L’image est là (dans le repertoire en cours), elle porte le nom my_wheezy_install.iso


## Phase 2 : Utiliser l'archive d'installation personnalisée


### Sur un réseau virtuel

Sur une VM, il n'y a rien a faire, on peut utiliser directement l'image iso.


### Sur un `CD` ou Sur une clé `usb`

**Important :** dans la réalisation de l'archive `iso` ci-dessus, il faudra remplacer **cdrom** par **hd-media** si on veut l'utiliser via une clé `usb`. Non encore testé [TODO].

Insérez votre clé USB d'une taille supérieur à la taille de l'image iso.
En root, tapez
```sh
fdisk –l
```

```sh
  Disk /dev/sdd: 3 GB, 3997486080 bytes 
  255 heads, 63 sectors/track, 486 cylinders 
  Units = cylinders of 16065 * 512 = 8225280 bytes 
 
     Device Boot      Start         End      Blocks   Id  System 
  /dev/sdd1   *           1         487     3911796    6  FAT1
```
Repérez le volume /dev/sdx à coté de Disk qui correspond à votre clé USB grâce au système de fichier (FAT 16 ou FAT 32) et à sa taille. Dans l'exemple ici, c'est /dev/sdd

Attention, soyez certain de votre repérage. Si vous vous trompez de lettre, vous pouvez effacer un disque dur !
On lance la commande qui va créer la clé USB.
```sh
cp ./my_wheezy_install.iso /dev/sdX && sync
```

### Utilisation de la cle, du CD , ou de l'image iso

La machine démarre, il n'y a rien a faire l'installation est completement automatique jusqu'a la première connexion en root


## Phase 3 : Se connecter en ROOT et installation du paquet SE3

Au redémarrage se connecter en root, la suite de l'installation est automatique
Il faut appuyer sur **Entree** puis choisir **3** (sans serveur de communication), puis saisir le mot de passe pour `adminse3` et saisir 2 fois le nouveau mot de passe pour `root`

** NB ** ne peut on pas terminer l'automatisation complete et automatiser  le dessus ? et en profiter pour installer tous les paquets SE3  : se3-backup se3-clamav se3-dhcp se3-client-linux se3-wpkg se3-ocs se3-clonage se3-pla se3-radius puis faire une mise a jour de tout ... ?
**NB :** je ne me souviens plus ce qu'il faut mettre en place pour qu'au redémarrage on se trouve en root et qu'un script se lance.

Il reste a tester que le se3 est vraiement ok, en tout cas il est accessible en [IPSE3]:909

## Références

Voici quelques références que nous avons utilisé pour la rédaction de cette documentation :

* Article du site [`Debian Facile`](https://debian-facile.org) : [preseed debian](https://debian-facile.org/doc:install:preseed) qui décrit l'incorporation d'un fichier `preseed`.
* Article du site [`Debian Facile`](https://debian-facile.org) : [preseed debian](https://debian-facile.org/doc:install:usb-boot) qui décrit lacopie d'une image iso sur une cle usb.
* La documentation officielle `Debian` concernant [l'installation via un preseed](https://www.debian.org/releases/wheezy/amd64/apb.html.fr).
* …
