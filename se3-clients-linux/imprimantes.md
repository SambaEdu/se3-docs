#Un mot sur les imprimantes

Ce qui suit vous permettra d'installer des imprimantes sur les `clients-linux`.

**Note :** Si vous avez du code bash à me proposer pour automatiser l'installation des imprimantes sur les clients GNU/Linux via par exemple la fonction initialisation_perso, je suis preneur (francois.lafont@crdp.ac-versailles.fr).

* [Le répertoire `/mnt/netlogon/install/messcripts_perso/imprimantes/`](#le-répertoire-mntnetlogoninstallmesscripts_persoimprimantes)
* [Installation d'une imprimante réseau](#installation-dune-imprimante-réseau)
* [Imprimante par défaut](#imprimante-par-défaut)
* [Suppression d'une imprimante](#suppression-dune-imprimante)
* [Définir le paramétrage d'impression par défaut](#définir-le-paramétrage-dimpression-par-défaut)
* [CUPS](#cups)
* [Références](#références)


## Le répertoire `/mnt/netlogon/install/messcripts_perso/imprimantes/`

Sur un client GNU/Linux, le répertoire `/mnt/netlogon/install/messcripts_perso/` contient un sous-répertoire nommé `imprimantes/` ; si ce n'est pas le cas, vous pouvez le créer.

Ce répertoire vous permettra de stocker de manière centralisée des fichiers `.ppd` (pour « PostScript Printer Description ») qui sont des sortes de drivers permettant d'installer des imprimantes sur les clients GNU/Linux.

Vous pouvez télécharger de tels fichiers (qui dépendent du modèle de l'imprimante) sur ce site par exemple :  
[http://www.openprinting.org/printers](http://www.openprinting.org/printers)

Certains constructeurs proposent des fichiers `.ppd` sur leurs sites.


## Installation d'une imprimante réseau

Supposons que, dans le répertoire `/mnt/netlogon/install/messcripts_perso/imprimantes/`, se trouve le fichier `.ppd` d'un modèle d'imprimante réseau donné.

Vous pouvez alors lancer l'installation de cette imprimante sur un client GNU/Linux via la commande suivante (en tant que `root`) :

```sh
lpadmin -p NOM-IMPRIMANTE -v socket://IP-IMPRIMANTE:9100 \<Touche ENTRÉE>
    -E -P /mnt/netlogon/install/messcripts_perso/imprimantes/fichier.ppd
```

Cette commande doit être, en principe, exécutée une seule fois sur le client GNU/Linux.

Si tout va bien, vous devriez ensuite (même après redémarrage du système) être en mesure d'imprimer tout ce que vous souhaitez à travers vos applications favorites (navigateur Web, traitement de texte, lecteur de PDF etc).

### Cas des copieurs Kyocera avec un code utilisateur
Pour pouvoir imprimer sur un copieur Kyocera qui nécessite un code utilisateur individuel, il va falloir faire deux manipulations:

La première sur les clients Linux (mais qui peut se faire avec un script unefois.bat).

La deuxième sur le script de logon_perso situé sur le se3.

Il faut déjà installer le logiciel kyodialog".
On le trouvera sur cette page, dans la catégorie **Linux** (Linux UPD driver with extended feature support).
Il faut décompresser l'archive et garder le package "LinuxPhase4/KyoceraPackageLinux/Debian/EU/kyodialog_amd64/kyodialog_4.0-0_amd64.deb

On l'installe en faisant:

```sh
dpkg -i kyodialog_4.0-0_amd64.deb
```

Il est possible qu'un problème de dépendance se pose. Il faut alors le regler en faisant
```sh
apt-get install -f
```

Le logiciel kyodialog s'installe donc (Kyocera Print Panel), ainsi qu'un grand nombre de drivers PPD qui se mettent dans `/usr/share/ppd/kyocera/`

Il suffit ensuite d'installer les imprimantes de façon classique:
```
lpadmin -p copieur-sdp3 -v socket://172.20.71.100:9100 -E -P /usr/share/ppd/kyocera/Kyocera_TASKalfa_4550ci.ppd
```

On lance kKyocera Print Panel. Les trois imprimantes doivent s'y trouver.
Il suffit de cliquer sur une imprimante, puis `Travail`. On coche `comptabilisation des Travaux` puis `Utiliser un numero de compte spécifique`. On valide . On refait de même sur les autres imprimantes.
Il est maintenant possible d'écrire sur les copieurs.

Concrêtement, Kyocera Print Panel a ajouté des lignes à un fichier de configuration situé dans /home/login/.cups/lpoptions
contenant entre autres le code utilisatur dans la partir " KmManagment=12345".

A chaque connexion d'utilisateur, le fichier /home/login/.cups/lpoptions est recrée puis effacé!, Il faut donc refaire la manip avec `Kyocera Print Panel` à chaque fois.

On peut contourner cela en faisant ainsi:
On va modifier le script de logon_perso de la sorte

```sh
nano /home/netlogon/clinets-linux/bin/logon_perso
```

On ajoute les lignes suivantes (à adapter bien sur à votre réseau) dans la partie `ouverture_perso`

```
#on va créer le fichier lpoptions dans un partage réseau existant lisible uniquement par l'utilisateur (ex doc).
touch  "$REP_HOME"/Documents/.lpoptions
mkdir -p "$REP_HOME/.cups"
#On créer un lien symbolique pour que le fichier puisse être modifiable par kyodialog.
ln -s  "$REP_HOME"/Documents/.lpoptions "$REP_HOME"/.cups/lpoptions

#installation es imprimantes de la sdp

On installe les imprimantes concernées

if appartient_au_parc "sprof1" "$NOM_HOTE"; then
    # La machine appartient au parc sprof1
lpadmin -p copieur-sdp3 -v socket://172.20.71.102:9100 -E -P /usr/share/ppd/kyocera/Kyocera_TASKalfa_4501i.ppd
lpadmin -p copieur-sdp-couleur -v socket://172.20.71.100:9100 -E -P /usr/share/ppd/kyocera/Kyocera_TASKalfa_4550ci.ppd
lpadmin -p copieur-sdp2 -v socket://172.20.71.101:9100 -E -P /usr/share/ppd/kyocera/Kyocera_TASKalfa_4501i.ppd
else
# La machine n'appartient pas au parc S121, on supprime les imprimantes(inutile sauf si on enleve une machine d'un parc.).
lpadmin -x copieur-sdp3
lpadmin -x copieur-sdp-couleur
lpadmin -x copieur-sdp2
    
fi

```

Maintenant, lorsque un utilisateur va entrer ses codes dans le logiciel, ils seront enregistrés dans le fichier .lpoptions

## Imprimante par défaut

Si plusieurs imprimantes sont installées sur un client, pour faire en sorte que l'imprimante NOM-IMPRIMANTE soit l'imprimante par défaut, il faut exécuter, en console `root` sur le client :

```sh
lpadmin -d NOM-IMPRIMANTE
```

Par précaution, s'il y a une seule imprimante d'installée sur un client, déclarez-la par défaut.


## Suppression d'une imprimante

Et pour supprimer l'imprimante :
```sh
lpadmin -x NOM-IMPRIMANTE
```

## Lister les imprimantes installées sur le poste

Pour lister les imprimantes installées sur le poste, afin de retouver par exemple leur nom :
```sh
lpstat -p
```

## Définir le paramétrage d'impression par défaut

Il peut être intéressant de modifier les paramètres d'impression par défaut, par exemple pour définir que l'impression se fasse en noir sur une imprimante couleur, activer l'impression recto-verso, etc.

Pour cela, il faut que l'imprimante ait été installée.

Récupérer la liste des paramètres d'impression disponibles :
```sh
lpoptions -p NOM-IMPRIMANTE -l
```

Rechercher parmi ces options celles qui nous intéressent. Par esemple, sur une imprimante Brother HL3170CDW, on peut repérer la ligne :
```sh
BRMonoColor/Color / Mono: *Auto FullColor Mono
```
Dans cette ligne, ce qui précède le premier `/` correspond au nom du paramètre, les valeurs possibles pour les paramètres se trouvent après les deux points `:`, et l'astérisque `*` précède la valeur actuellement sélectionnée.

Pour modifier ce paramètre, on lancera la commande suivante (par exemple avec un script unefois agissant sur un parc déterminé) :
```sh
lpadmin -p HL3170CDW -o "BRMonoColor=Mono"
```
Attention : si cette commande n'est pas lancée en tant que `root`, le paramètre est modifié dans le profil de l'utilisateur actuellement connecté, et non pas pour l'ensemble du système.


## CUPS

Une autre méthode est d'utiliser `CUPS` via un butineur.

Dans le butineur `Iceweasel`, utilisez cette url :
```sh
http://localhost:631/
```

Pour plus de précisions, voir les références ci-dessous.


## Références

Quelques référence pouvant être utiles :

* [le wiki debian : le système d'impression](https://wiki.debian.org/fr/SystemPrinting)
* [le wiki debian : CUPS](https://wiki.debian.org/fr/CUPS)

