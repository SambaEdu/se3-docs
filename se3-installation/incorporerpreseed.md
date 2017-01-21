# Installation automatique d'un `Se3`

…article en chantier…

* [Préliminaires](#préliminaires)
    * [Objectif](#objectif)
    * [Étapes de l'installation automatique d'un `se3`](#Étapes-de-linstallation-automatique-dun-se3)
* [Les fichiers `preseed` et `setup_se3`](#les-fichiers-preseed-et-setup_se3)
    * [Création des fichiers `preseed` et `setup_se3`](#création-des-fichiers-preseed-et-setup_se3)
    * [Téléchargement des fichiers](#téléchargement-des-fichiers)
    * [Modification du fichier `preseed`](#modification-du-fichier-preseed)
* [Incorporer le fichier `preseed` à l'archive d'installation](#incorporer-le-fichier-preseed-à-larchive-dinstallation)
    * [Téléchargement de l'installateur `Debian`](#téléchargement-de-linstallateur-debian)
    * [Mise en place des éléments pour l'incorporation](#mise-en-place-des-éléments-pour-lincorporation)
        * [Création des répertoires de travail **isoorig** et **isonew**](#création-des-répertoires-de-travail-isoorig-et-isonew)
        * [Dans le répertoire **isoorig**](#dans-le-répertoire-isoorig)
        * [Dans le répertoire **isonew**](#dans-le-répertoire-isonew)
* [Utiliser l'archive d'installation personnalisée](#utiliser-larchive-dinstallation-personnalisée)
    * [Sur un réseau virtuel](#sur-un-réseau-virtuel)
    * [Avec un `CD`](#graver-un-cd)
    * [Avec une clé `usb`](#utiliser-une-clé-usb)
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


## Les fichiers `preseed` et `setup_se3`

### Création des fichiers `preseed` et `setup_se3`

La phase 1 consiste à créer le fichier `preseed` (nommé ici **se3.preseed**) et le fichier **setup_se3.data** en utilisant [l'interface-outil de configuration](http://dimaker.tice.ac-caen.fr/dise3xp/se3conf-xp.php?dist=wheezy).

On pourra bien entendu utiliser un fichier **se3.preseed** existant, dans le cas d'une migration ou d'une ré-installation ou tout simplement par précaution : *mieux vaut prévenir que guérir*… Il y aura éventuellement des modifications à apporter en fonction des évolutions, que ce soit du point de vue des versions de `se3`, ou du point de vue du matériel, ou encore d'une optimisation des paramètres de ces fichiers.


### Téléchargement des fichiers

Une fois les fichiers **se3.preseed** et **setup_se3.data** ainsi créés, il s'agira de les télécharger en remplaçant les xxxx par le nombre qui convient (voir message de l'interface de création) :
```sh
wget http://dimaker.tice.ac-caen.fr/dise3wheezy/xxxx/se3.preseed
wget http://dimaker.tice.ac-caen.fr/dise3wheezy/xxxx/setup_se3.data
```


### Modification du fichier `preseed`

pour une automatisation complète, il faut effectuer des modifications dans le fichier **se3.preseed** :

On l'édite :
```sh
nano se3.preseed
```

Ensuite,quelques lignes à adapter :
```sh
# MODIFIE
# Choix des parametres regionaux (locales)
d-i     debian-installer/locale                            string fr_FR.UTF-8
d-i     debian-installer/supported-locales                 string fr_FR.UTF-8, en_US.UTF-8
d-i     debian-installer/locale                            string fr_FR.UTF-8
```
pourquoi une ligne est presente 2 fois ? Pourquoi il y avait br au lieu de fr dans la ligne du milieu ??
→ ce doit être un bug : outil de création du preseed à modifier ? quelqu'un peut il confirmer ? (mais cela ne resoud pas le pb de claveir en querty a la fin car j'ai essaye les 2 )
**NB :**je mettrai plutôt ceci :
```sh
# Préconfigurer la locale seule définit la langue, le pays et la locale.
d-i debian-installer/locale string fr_FR
```

```sh
#MODIFIE
### Keyboard
d-i console-keymaps-at/keymap select fr
d-i keyboard-configuration/xkb-keymap                  select fr
d-i console-keymaps-at/keymap select fr
d-i keyboard-configuration/layoutcode                  string fr
d-i debian-installer/keymap string fr-latin9
```
**NB :** et ici, ceci :
```sh
# Choix du clavier :
# keymap est un alias de keyboard-configuration/xkb-keymap
d-i keymap select fr(latin9) 
```
j'ai deja essaye cela cela me dit que le clavier fr(latin9) est obsolete , interromp l'install et me demande un autre clavier fr-latin9 est ce qui est propose par dimaker ... et ne resoud pas le pb de clavier en querty à la fin

```sh
#MODIFIE, pour éviter un problème de fichier corrompu avec netcfg.sh
#mais cela poses peut être des problèmes par la suite car pas de réseau juste dans l'installateur
#d-i preseed/run string netcfg.sh
```
**NB :** il faudrait éclaircir cela. 
Ce fichier existe null pas dans une install avec preseed d'un wheezy, il a surement ete rajoute par ceux qui ont fabrique l'install du se3. Lorsqu'on l'enleve il semble que il n'y a pas d'acces reseau pendnant l'execution du preseed mais elle reapparait apres c'est pourquoi j'ai ete oblige de telecharger les fichiers plus loin dans le preceed avant de faire l'install. ceux la : http://dimaker.tice.ac-caen.fr/dise3wheezy/se3scripts
Lorsque je laisse cette ligne, l'installateur bloque avec un message rouge et me dit : le fichier netcfg.sh est corrompu ...

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

```sh
#AJOUTE, pour evite de répondre à la question
#Some versions of the installer can report back on what software you have
#installed, and what software you use. The default is not to report back,
#but sending reports helps the project determine what software is most
#popular and include it on CDs.
popularity-contest popularity-contest/participate boolean false
```
**NB :** il faudrait que l'outil de création du preseed soit modifié, non ?

```sh
#AJOUTE, pour installer par exemple les packages des modules du se3 mais cela ne fonctionne pas 
#peut etre que les paquet ne sont pas dnas les depot wheezy ...
#Individual additional packages to install
d-i pkgsel/include string se3-backup se3-clamav se3-dhcp se3-client-linux se3-wpkg se3-ocs se3-clonage se3-pla se3-radius...
#Whether to upgrade packages after debootstrap.
#Allowed values: none, safe-upgrade, full-upgrade
#d-i pkgsel/upgrade select none
```
**NB :** Cela ne fonctionne pas car les dépôts ne sont pas encore en place : ils le seront lors de la phase 3.
OK

```sh
#MODIFIE Preseed commands
----------------
d-i preseed/early_command string cp /cdrom/setup_se3.data ./; \
    cp /cdrom/se3scripts/* ./; \
    chmod +x se3-early-command.sh se3-post-base-installer.sh install_phase2.sh; \
    ./se3-early-command.sh se3-post-base-installer.sh 
```
Il faut aussi télécharger les fichiers suivants qui seront aussi nécessaires (cependant on pourrit laisser le fait de les telecharger en modifiant comme a l'origine le preseed mais avant il faut resourdre le probleme de cette ligne : d-i preseed/run string netcfg.sh
```sh
mkdir ./se3scripts
cd se3scripts
wget http://dimaker.tice.ac-caen.fr/dise3wheezy/se3scripts/se3-early-command.sh
wget http://dimaker.tice.ac-caen.fr/dise3wheezy/se3scripts/se3-post-base-installer.sh
wget http://dimaker.tice.ac-caen.fr/dise3wheezy/se3scripts/sources.se3
wget http://dimaker.tice.ac-caen.fr/dise3wheezy/se3scripts/install_phase2.sh
wget http://dimaker.tice.ac-caen.fr/dise3wheezy/se3scripts/profile
wget http://dimaker.tice.ac-caen.fr/dise3wheezy/se3scripts/bashrc
cd ..
```

**NB :** je ne me souviens plus ce qu'il faut mettre en place pour qu'au redémarrage on se trouve en root et qu'un script se lance.
normalement c'est automatique : avec une install auto url=... avec ce meme preceed tout fonctionne correctement mais en install auto file =... non , la phase 2 ./install_phase2.sh ne se lance pas tout seul ...

## Incorporer le fichier `preseed` à l'archive d'installation

### Téléchargement de l'installateur `Debian`

Comme nous allons incorporer les fichiers d'installation `Wheezy`, créés et modifiés précédemment, dans un `cd` ou une clé `usb`, il nous faut pour cela une archive `Debian Wheezy`.

Tout d'abord, récupérez une image d'installation de `Debian`. Une image *netinstall* devrait suffire.
```sh
wget http://cdimage.debian.org/cdimage/archive/latest-oldstable/amd64/iso-cd/debian-7.11.0-amd64-netinst.iso
```

Si votre serveur dispose de matériel (carte résau notamment) non reconnus car nécessitant des firmwares non libres, préférez cette image :
```sh
wget http://cdimage.debian.org/cdimage/unofficial/non-free/cd-including-firmware/archive/7.11.0+nonfree/amd64/iso-cd/firmware-7.11.0-amd64-netinst.iso
```
NB : on peut aussi incorporer les firmwares à l'archive [TODO].


### Mise en place des éléments pour l'incorporation

#### Création des répertoires de travail **isoorig** et **isonew**

Pour mener à bien la modification de l'installateur `Debian`, on va créer deux répertoires :
* **isoorig :** il contiendra le contenu de l'image d'origine
* **isonew :** il contiendra le contenu de votre image personnalisée
```sh
mkdir isoorig isonew
```


#### Dans le répertoire **isoorig**

On monte ensuite, dans le répertoire **isoorig**, l'iso téléchargée , puis on copie son contenu dans le répertoire isonew.
```sh
mount -o loop -t iso9660 debian-7.11.0-amd64-netinst.iso isoorig
rsync -a -H –exclude=TRANS.TBL isoorig/ isonew
```
J'ai pas trés bien compris à quoi cela sert d'exclure TRANS.TBL car il n'existe pas dans l'archive téléchargée. En fait, ce fichier existe dans d'autres archives… supprimer cette option ? [TODO]
OK mais pas dans l'archive avec install reseau ? no dnas celle avec les firwares que tu propose au dessus  ?


#### Dans le répertoire **isonew**

Les modifications suivantes seront à réaliser dans le répertoire **isonew**.
On va maintenant faire en sorte que l'installateur se charge automatiquement.
On donne les droits en écriture aux 3 fichiers à modifier :
```sh
chmod 755 ./isonew/isolinux/txt.cfg
chmod 755 ./isonew/isolinux/isolinux.cfg
chmod 755 ./isonew/isolinux/prompt.cfg
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
      append auto=true vga=normal file=/cdrom/se3.preseed initrd=/install.amd/initrd.gz -- quiet
```

J'ai aussi essaye cela a la place de la derniere ligne mais cela ne change rien ...
```sh
append auto=true vga=788 preseed/file=/cdrom/se3.preseed priority=critical lang=fr locale=fr_FR.UTF-8 console-keymaps-at/keymap=fr-latin9 initrd=/install.amd/initrd.gz – quiet
```

Je mettrai plutôt ceci :
```sh
append auto=true preseed/file=/cdrom/se3.preseed initrd=/install.amd/initrd.gz -- quiet
```
Éventuellement, on peut rajouter une locale avec : locale=fr_FR et un clavier keymap=fr mais je me demande si c'est utile ? Ne les rajoute pas dans un premier temps.
Comme tu le vois au dessus j'ai deja essaye cela et cela ne fonctionne pas ... clavier toujours en querty apres

(Veillez à adapter install.amd/initrd.gz selon l'architecture utilisée, ici 64bit. En cas de doute, regardez ce qu'il y a dans le répertoire isoorig.)

Ensuite, éditez **isolinux/isolinux.cfg** et **isolinux/prompt.cfg** :
et changez *timeout 0* en *timeout 4* par exemple et *prompt 0* par *prompt 1*.
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
(ne marche pas, pb avec le lien symbolique ... il y a une boucle ... ceci dit, il n'y a aucun fichier qui sont dans le md5sum.txt qui ont été modifié donc cette étape ne sert à rien il me semble)

```sh
apt-get install genisoimage
genisoimage -o ../my_wheezy_install.iso -r -J -no-emul-boot -boot-load-size 4 -boot-info-table -b isolinux/isolinux.bin -c isolinux/boot.cat ../isonew
cd ..
```
L’image est là (dans le repertoire en cours) elle porte le nom my_wheezy_install.iso


## Utiliser l'archive d'installation personnalisée

### Sur un réseau virtuel
J'ai teste l'image iso sur une VM.  L'iso démarre, ne pose aucune question mais le clavier est en `qwerty` et, à la première connexion en root, la 2ème phase ne démarre pas toute seule, il faut lancer à la main ./install_phase2.sh qui est bien présent au bon endroit, idem pour setup_se3.data.


### Graver un `CD`

…à venir…


### Utiliser une clé `usb`

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


## Utilisation de la cle, du CD , ou de l'image iso

La machine démarre, ne pose aucune question mais le clavier est en qwerty et à la première connexion en root la 2eme phase ne démarre pas toute seul, il faut la lancer à la main.
Au redémarrage se connecter en root puis lancer : 
```sh
./install_phase2.sh
```

Le reste semble se dérouler correctement ... a tester.

## Références

Voici quelques références que nous avons utilisé pour la rédaction de cette documentation :

* Article du site [`Debian Facile`](https://debian-facile.org) : [preseed debian](https://debian-facile.org/doc:install:preseed) qui décrit l'incorporation d'un fichier `preseed`.
* Article du site [`Debian Facile`](https://debian-facile.org) : [preseed debian](https://debian-facile.org/doc:install:usb-boot) qui décrit lacopie d'une image iso sur une cle usb.
* La documentation officielle `Debian` concernant [l'installation via un preseed](https://www.debian.org/releases/wheezy/amd64/apb.html.fr).
* …
