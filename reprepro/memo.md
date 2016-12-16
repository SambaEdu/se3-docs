# Petit memo sur `reprepro`


* [Installation basique sans signer les paquets](#installation-basique-sans-signer-les-paquets)
* [Utiliser une clé gpg pour signer les paquets de son dépôt](#utiliser-une-clé-gpg-pour-signer-les-paquets-de-son-dépôt)
 


## Installation basique sans signer les paquets

```sh
apt-get install reprepro

** Le répertoire conf/ servira à stocker la conf du dépôt.**
mkdir /repository
mkdir /repository/{conf,incoming}
```

Dans le dossier `conf/` placer le fichier `distributions`
contenant ceci :

```
Origin: Francois Lafont
Label: Francois Lafont
Suite: stable
Codename: lenny
Version: all
Architectures: i386 amd64
Components: main
Description: personnal repository.

Origin: Francois Lafont
Label: Francois Lafont
Suite: stable
Codename: squeeze
Version: all
Architectures: i386 amd64
Components: main
Description: personnal repository.

Origin: Francois Lafont
Label: Francois Lafont
Suite: stable
Codename: wheezy
Version: all
Architectures: i386 amd64
Components: main
Description: personnal repository.
```

Dans le champ `Architectures`, on pourrait aussi ajouter
`source` mais ici on va se contenter de stocker des `.deb`.

Pour l'instant, on est en train de faire un dépôt sans
authentification ce qui provoquera un message
d'avertissement à chaque installation d'un paquet de ce
dépôt. On verra plus loin comment authentifier notre dépôt.

**Pour ajouter un `.deb` dans le dépôt** :

```sh
reprepro --verbose --basedir /repository includedeb lenny /le/package/xxxx.deb
```

À répéter avec les autres distributions si nécessaire. On
peut voir le résultat avec un `tree /repository`.
Maintenant, pour rendre accessible le dépôt sur le Web :

```sh
apt-get install apache2
ln -s /repository /var/www/debian
```

Sur une machine Debian, il n'y a plus qu'à rajouter dans le
`sources.list` (ou dans un `sources.list.d/truc.list`) la
ligne :

```sh
### dans le cas d'une Wheezy
deb http://le-nom-fqdn-du-depot/debian/ wheezy main
```

Ensuite l'installation pourra se faire de manière classique :

```sh
apt-get update && apt-get install le-paquet
```

Les mises à jour se feront sans souci à condition bien sûr
que la version du paquet augmente. Reste toute même un
souci. À chaque installation ou MAJ, on a le message :

```
WARNING: The following packages cannot be authenticated!
  snmpd-extend
Install these packages without verification [y/N]?
```




## Utiliser une clé gpg pour signer les paquets de son dépôt

Nous allons authentifier notre dépôt. Déjà, il faut se créer
une paire de clés gpg. La paire de clés gpg est stockée dans
le répertoire `~/.gnupg/`. La paire de clés doit donc être
générée par le même compte Unix que celui qui gère le dépôt
APT, ie le compte Unix qui lance les commandes `reprepro`
pour ajouter/supprimer etc. des paquets dans le dépôt. Dans
notre cas il s'agit du compte root mais c'est n'est pas
nécessaire. Un compte Unix dédié sans droit particulier, ni
même le droit de se connecter au système  est une bien
meilleure idée :

```sh
gpg --gen-key # ne pas mettre de passphrase
```

**Remarque :** ne pas mettre de passphrase car avec une
passphrase je n'ai pas réussi à faire marcher reprepro
ensuite. Au passage, la commande à besoin d'entropie, donc
il faut éventuellement faire des saisies pipeau au clavier
etc. pour accélérer la commande.

Au niveau de la paire de clés, j'ai choisi "DSA and Elgamal"
mais en fait, j'ignore le meilleur choix. J'ai mis comme ID
pour la paire clés :

```conf
# La commande ci-dessus nous demande d'abord de saisir un
# nom (« Francois Lafont » ci-dessous), un commentaire
# (« personnal repository » ci-dessous) et un mail
# (« francois.lafont@domain.tld.fr » ci-dessous). De
# ces trois éléments, la commande `gpg --gen-key` génère
# l'ID suivant :
Francois Lafont (personnal repository) <francois.lafont@domain.tld>
```

Ensuite on peut bien voir la clé publique avec la commande :

```sh
~$ gpg --list-public-keys
/root/.gnupg/pubring.gpg
------------------------
pub   2048D/D36BF915 2013-07-11
uid                  Francois Lafont (personnal repository) <francois.lafont@domain.tld>
sub   2048g/11715478 2013-07-11
```

La valeur D36BF915, l'identifiant numérique de la clé
publique, est à retenir.

**Remarque :** ci-dessus, notre paire de clé gpg est
importée dans le « trousseau » du compte root, ie dans le
répertoire `~/.gnupg/`. En particulier, la clé publique se
trouve dans `~/.gnupg/pubring.gpg`. Il est parfaitement
possible d'avoir des informations sur une clé gpg publique
sans pour autant qu'elle soit importée dans notre trousseau.
Par exemple avec les commandes :

```sh
cd /tmp && wget http://repository.flaf.fr/pub-key.gpg
gpg --list-packets pub-key.gpg
```

Dans le fichier `/repository/conf/distrubtions`, pour chaque
distribution (en clair, dans chaque paragraphe de ce fichier
de configuration), rajouter le champ suivant :

```
SignWith: D36BF915
```

Ensuite, il faut mettre à jour notre dépôt afin que celui-ci
contiennent les fichiers (gpg) permettant son
authentification :

```sh
# À faire pour chaque distribution.
reprepro --verbose --basedir /repository export wheezy
```

Maintenant on a progressé car, sur un client APT de notre
dépôt, on a désormais :

```
~# apt-get update

[...]

W: GPG error: http://shinken.domaine.priv wheezy 
Release: The following signatures couldn't be verified because the public key
is not available: NO_PUBKEY 783FBC83D36BF915
```

Il faut donc rendre notre clé publique disponible à tous les
utilisateurs de notre dépôt. Déjà, si on veut ajouter la clé
publique dans la configuration APT de notre machine perso, il
faut faire :

```sh
gpg --export D36BF915 > key-repository-pub.gpg
apt-key add key-repository-pub.gpg

# ou bien plus élégamment :
gpg --export D36BF915 | apt-key add -
```

**Remarque :** si on veut mettre la clé publique dans un format
ASCII alors faire plutôt :

```sh
gpg --export -a D36BF915 > key-repository-pub.gpg
```
Comme indiqué dans la page man de gpg :

```
Create ASCII armored output. The default is to create
the binary OpenPGP format.
```

Et il ne restera plus qu'à mettre le fichier
`key-repository-pub.gpg` à la racine de notre dépôt APT,
afin que n'importe qui puisse le télécharger.


Et maintenant, après un petit `apt-get update`, plus de message nous
signalant qu'on souhaite installer un paquet non authentifié.

**Remarque :** si un jour on ne souhaite plus utiliser notre dépôt :
- on supprime le dépôt du sources.list
- et on supprime la clé publique associé avec :

```sh
apt-key del D36BF915
```

**Remarque:** voir la page man de reprepro, mais il est aussi possible
de supprimer un paquet du dépôt et de faire bien d'autres choses.
Par exemple pour supprimer un package :

```sh
reprepro --verbose --basedir /repository remove wheezy le-package
```

Dans un dépôt debian la `distribution` s'appelle aussi
le `codename` ou on utilise aussi l'expression `target`
qui est plus générale car en vérité cette « section »
ne correspond pas nécessairement à une distribution.
Par exemple dans :

```
deb http://repository.crdp.ac-versailles.fr/debian/ xia main
```

la target est `xia` qui ne correspond pas à une distribution
(ça peut être un logiciel ou une famille de logiciels).

Supposons qu'on veuille changer une target de notre dépôt
parce qu'on veut lui ajouter une architecture par exemple.
Par exemple on ajoute l'architecture i386 à cette target :

```
Origin: Francois Lafont
Label: Francois Lafont
Suite: stable
Codename: xia
Version: all
Architectures: i386 amd64
Components: main
Description: personnal repository.
```

**Remarque :** attention pas de virgule pour séparer le nom des
architectures.

On édite le fichier de conf de reprepro pour avoir la target
`xia` comme ci-dessus :

```sh
vim /repository/conf/distributions
```

Ensuite on lance la commande suivante qui va mettre au
propre la base de données de reprepro en fonction des
différences constatées entre le fichier de conf et
l'arborescence des fichiers constituant le dépôt :

```sh
reprepro --verbose --basedir /repository clearvanished
```

Si jamais il y a du nettoyage à faire alors il faudra
rejouer la commande avec l'option --delete :

```sh
reprepro --verbose --basedir /repository --delete clearvanished
```

Ensuite on liste les paquets contenus dans la target `xia` :

```sh
reprepro --verbose --basedir /repository list xia
```

En fonction de la liste obtenue, on supprime tous les
paquets de cette liste :

```sh
reprepro --verbose --basedir /repository remove xia paquet1 paquet2...
```

Ensuite, on vide le répertoire :

```sh
rm -r /repository/dists/xia/*
```

On peut maintenant repartir sur un répertoire clean
qu'on peut exporter :

```sh
reprepro --verbose --basedir /repository export xia
```

Et voilà, c'est fini. On a une target toute nouvelle
et propre mais vide ausi et il faudra donc la peupler
de paquets.


