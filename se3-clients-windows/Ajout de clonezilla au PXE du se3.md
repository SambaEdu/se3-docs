
# Ajout de clonezilla au PXE du se3. Utilisation en clonage, sauvegarde, restauration

**Clonezilla est un Logiciel opensource permettant de faire/restaurer des images de disques, de partitions. 
Ces images peuvent être stockées localement sur une partition, un disque dur externe ou tout simplement sur 
le se3 par connexion ssh.**

Une connexion en ssh sur le serveur se3 se fera par défaut dans le répertoire /home/partimag/

Il peut être judicieux de rajouter un disque dur interne sur le se3. Ce disque sera monté de façon permanente en /home/partimag.
Il pourrait contenir des images de chaque type de PC, des partitions spécifiques à des pc d’une salle si des logiciels spécifiques ne peuvent être déployées par WPKG.

Un disque dur séparé n’est pas obligatoire mais permettra de faire des clonages sans que l’activité du serveur ne s’en trouve diminuée. Le format peut-être en ext3,ntfs, fat32 ou autre puisque les images générées sont découpées en fichiers de taille inférieure à 2 G0.

Clonezilla permet aussi de copier une image de partition vers une autre partition locale, servant ainsi de sauvegarde à la première, comme le fait le module du se3.

Le but est de pouvoir démarrer Clonezilla sur le poste client directement en PXE en vue de le restaurer/creer une image du poste, ou tout simplement faire une sauvegarde/restauration de partitions.

## Première partie : installation de clonezilla sur le serveur.

Les images au format ZIP de clonezilla peuvent être téléchargées aux adresses suivantes :

[http://downloads.sourceforge.net/project/clonezilla/clonezilla_live_stable/2.1.2-43/clonezilla-live-2.1.2-43-i686-pae.zip](http://downloads.sourceforge.net/project/clonezilla/clonezilla_live_stable/2.1.2-43/clonezilla-live-2.1.2-43-i686-pae.zip)

http://downloads.sourceforge.net/project/clonezilla/clonezilla_live_stable/2.1.2-43/clonezilla-live-2.1.2-43-i486.zip

http://downloads.sourceforge.net/project/clonezilla/clonezilla_live_stable/2.1.2-43/clonezilla-live-2.1.2-43-amd64.zip

Version alternative basée sur Ubuntu raring (utilisée sur mon se3)

http://downloads.sourceforge.net/project/clonezilla/clonezilla_live_alternative/20130819-raring/clonezilla-live-20130819-raring-i386.zip

**Remarque** : Je n’ai testé que la version "raring" dans mon établissement. Les autres sont peut-être plus ou moins performantes ou reconnues.

En cas de maj, les liens ne seront plus valides, mais les archives pourront être téléchargées ici :

http://clonezilla.org/downloads/download.php?branch=stable

Ouvrir une session root au choix sur le serveur, sur un poste client Windows avec Putty ou plus simplement une connexion en ssh avec un client linux (qui va rendre le copier coller des lignes suivantes bien plus pratique...)

Depuis le client linux


```sh
# ssh -22 root@ipduse3
```
![fenêtre menu](images/connexion_ssh_au_serveur.jpg.png)

```sh
# mkdir /tftpboot/clonezilla

# cd /tftpboot/clonezilla

# wget http://downloads.sourceforge.net/project/clonezilla/clonezilla_live_alternative/20140518-trusty/clonezilla-live-20140518-trusty-amd64.zip
```
*Décompression de l’archive clonezilla.*


```sh
# unzip -j clonezilla-live-*.zip
```

**Différents fichiers se retrouvent alors dans ce répertoire**

![fenêtre menu1](images/fichiers_clonezilla_decompresses-3.jpg.png)

Une fois décompressé, le fichier.zip peut être effacé.

## Deuxième partie : modification des entrées du menu PXE

Le module PXE doit être activé au niveau du se3, ainsi que la mise en place d’un mot de passe.

Le menu PXE contient certaines lignes préremplies (lancement de Slitaz, de Sysrescuecd, etc. ).

Pour ajouter ou supprimer des entées à ce menu, il va donc falloir modifier certains fichiers sur le se3.

Ces fichiers se trouvent dans le répertoire/tftpboot/pxelinux.cfg/ 

Il faudra modifier le fichier Linux.menu si vous voulez que les entrées apparaissent dans la partie maintenance.

Il y a alors deux possibilités :

- Soit vous éditez à la main le fichier maintenance.menu (ou clonage.menu) en ajoutant le lancement de clonezilla

- Soit vous allez ajouter un fichier clonezilla.menu qui contiendra toutes les informations de lancement, sauvegarde/restauration personnalisées.

La deuxième méthode sera clairement plus simple pour la mise en place, et pour la gestion des futures mises à jour du paquet se3-clonage.

### Première méthode

Pour éditer les fichiers, les non spécialistes du terminal (comme moi) pourront utiliser Filezilla et se connecter dessus en ssh. (aller dans le gestionnaire de sites)

[Filezilla est disponible pour windows, Linux et Mac.](https://filezilla-project.org/download.php?type=client)

![fenêtre menu2](images/connexion_en_ssh_avec_filezilla-2.jpg.png)

Un déplacement dans le répertoire /tftpboot/pxelinux.cfg/ se fera par simples clics

Les fichiers pourront alors être édités par gedit par un simple clic droit sur le fichier.

![fenêtre menu3](images/modification_de_fichier_avec_filezilla.jpg.png)


```sh
# cd /tftpboot/pxelinux.cfg (ou se déplacer jusqu’à cet emplacement)
```
Ajouter à maintenance.menu les lignes suivantes en adaptant l’ip du serveur se3 à votre configuration


```sh
label Clonezilla-live
MENU LABEL Clonezilla Live (Ramdisk)

KERNEL clonezilla/vmlinuz

APPEND initrd=clonezilla/initrd.img boot=live config noswap nolocales edd=on nomodeset ocs_live_run="ocs-live-general" ocs_live_extra_param="" keyboard-layouts="fr" ocs_live_batch="no" locales="" vga=788 nosplash noprompt fetch=tftp://IPDUSE3/clonezilla/filesystem.squashfs
```
ATTENTION : CE QUI SUIT « APPEND » EST SENSE ETRE SUR UNE SEULE LIGNE, IL NE FAUT DONC PAS APPUYER SUR ENTRER

![fenêtre menu4](images/fichier_linux.menu_avec_gedit.jpg.png)

Enregistrer et quitter le fichier. (si on utilise filezilla bien préciser « envoyer à nouveau le fichier vers le serveur » en cliquant sur oui)

![fenêtre menu5](images/enregistrement_des_modifs_avec_filezilla.jpg.png)

Cette commande permettra seulement de démarrer clonezilla par le PXE. Toutes les options (langue,clavier, sauvegarde,restauration...) devront être entrées devant le poste.

Clonezilla apparaît maintenant dans le menu maintenance.

![fenêtre menu6](images/menu_pxe_avec_clonezilla_seul.jpg.png)
