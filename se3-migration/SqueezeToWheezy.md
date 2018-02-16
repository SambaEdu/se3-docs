# Migration de `se3/squeeze` vers `se3/wheezy`

* [Présentation](#présentation)
* [Préparation du `se3 Squeeze`](#préparation-du-se3-squeeze)
    * [Configurer `apt`](#configurer-apt)
    * [Mise à jour du `se3` ?](#mise-à-jour-du-se3-)
    * [Assez de place dans le répertoire `/` ?](#assez-de-place-dans-le-répertoire--)
    * [Supprimer les profiles ?](#supprimer-les-profiles-)
    * [Supprimer les montages de disques externes](#supprimer-les-montages-de-disques-externes)
    * [Dernière précaution](#dernière-précaution)
    * [Prévenir les collègues…](#prévenir-les-collègues)
    * [Isoler le `se3` du réseau](#isoler-le-se3-du-réseau)
    * [Temps à prévoir](#temps-à-prévoir)
* [Migration vers un `se3-Wheezy`](#migration-vers-un-se3-wheezy)
    * [Utilisation d'une session `screen`](#utilisation-dune-session-screen)
    * [Utilisation du script de migration](#utilisation-du-script-de-migration)
    * [Redémarrer à la fin ?](#redémarrer-à-la-fin-)
* [Réparer `Grub` ?](#réparer-grub-)
    * [Télécharger et graver `boot-repair`](#télécharger-et-graver-boot-repair)
    * [Démarrer le `se3` sur le DVD gravé](#démarrer-le-se3-sur-le-dvd-gravé)
    * [Autre solution](#autre-solution)
    * [`Grub` et partitions `GPT`](#grub-et-partitions-gpt)
* [Configurer l'onduleur](#configurer-londuleur)
* [Post-migration](#post-migration)
    * [Annuaire incompatible](#annuaire-incompatible)
    * [Compléments sur la compatibilité de l'annuaire `ldap`](#compléments-sur-la-compatibilité-de-lannuaire-ldap)
    * [Plus de réseau](#plus-de-réseau)
    * [Les modules](#les-modules)
    * [Remettre en place les disques de sauvegarde](#remettre-en-place-les-disques-de-sauvegarde)
    * [Quelques vérifications](#quelques-vérifications)
    * [Cas d'un `se3 32-bits`](#cas-dun-se3-32-bits)
* [Utiliser les scripts de sauvegarde/restauration](#utiliser-les-scripts-de-sauvegarderestauration)
    * [Une solution alternative](#une-solution-alternative)
    * [Correction du problème de l'annuaire](#correction-du-problème-de-lannuaire)
    * [Cas éventuel des encodages](#cas-éventuel-des-encodages)



## Présentation

Cet article propose une procédure qui vous permettra de migrer, en toute sénérité, votre `se3-squeeze` vers un `se3-wheezy`.

Cet article est une synthèse réalisée à partir d'échanges collaboratifs parus sur la liste de dicussion de l'académie de Cæn `l-samba-edu@ac-caen.fr` : il est donc en évolution en fonction des questions, des réponses et précisions apparues lors de la discussion sur cette liste.

**Remarque 1 :** il se peut que les infos des derniers échanges ne soient pas encore intégrées ; cela prend un certain temps…

Si des intérrogations surgissent au cours de la lecture de cet article, n'hésitez pas à les partager sur la liste.

**Remarque 2 :** Si vous avez encore un `se3-lenny` ou une version antérieure, le mieux est d'utiliser les script de sauvegarde/restauration : [cela est détaillé ci-dessous](#utiliser-les-scripts-de-sauvegarderestauration) avec la méthode alternative qui est valable aussi pour migrer d'un `se3-squeeze` vers un `se3-wheezy`.

**Remarque 3 :** Vous pourrez vous entraîner sur un réseau `se3 virtuel`, ce qui vous permettra de le faire ensuite plus sereinement sur votre précieux `se3` si cela vous semble nécessaire. Bien sûr, ce n'est pas obligatoire et le script fonctionne très bien maintenant. L'article ci-dessous, un peu ancien et il faudrait le mettre à jour, vous guidera pour la mise en place d'un réseau virtuel.
> http://wiki.dane.ac-versailles.fr/index.php?title=Installer_un_r%C3%A9seau_SE3_avec_VirtualBox

**Remarque 4:** Si vous n'êtes pas zen à l'idée de lancer la procédure de migration, vous pouvez fabriquer une image de votre serveur actuel avec un disque dur externe et le logiciel open-source 'Clonezilla'. Ainsi, en cas de problème, il sera possible de restaurer facilement et rapidement le se3 dans sa configuration d' avant migration.
Plus d'informations [ici](https://github.com/SambaEdu/se3-docs/blob/master/se3-sauvegarde/clonerse3.md#cloner-un-se3).


## Préparation du `se3 Squeeze`

### Configurer `apt`
→ avoir corrigé les divers sources.list : normalement la mise à jour récente du se3 devrait le faire.

Sur un `se3-squeeze` à jour (*Version 2.4.9299* à la date de rédaction de cet article), **/etc/apt/sources.list** contient :
```sh
deb http://archive.debian.org/debian squeeze main contrib non-free
deb http://archive.debian.org/debian squeeze-lts main contrib non-free
```

…et **/etc/apt/sources.list.d/se3.list** contient :
```sh
# sources pour se3
deb http://wawadeb.crdp.ac-caen.fr/debian squeeze se3

#### Sources testing desactivee en prod ####
#deb http://wawadeb.crdp.ac-caen.fr/debian squeeze se3testing

#### Sources XP desactivee en prod ####
#deb http://wawadeb.crdp.ac-caen.fr/debian squeeze se3XP
```

→ créer le fichier **/etc/apt/apt.conf** (normalement, il n'existe pas)
```sh
touch /etc/apt/apt.conf
```
→ l'éditer (avec `nano` par exemple)
```sh
nano /etc/apt/apt.conf
```
…et y coller la ligne suivante :
```sh
Acquire::Check-Valid-Until false;
```

### Mise à jour du `se3` ?
Inutile, cela sera fait par le script de migration ; cependant, pour les angoissés, voici quelques commandes utiles pour cette mise à jour :
```sh
aptitude update
aptitude safe-upgrade
aptitude -P full-upgrade # selon la réponse, validez
bash /usr/share/se3/scripts/se3_update_system.sh
```

**Remarque :** si le `se3-squeeze` est à jour, vous disposerez, de ce fait, de la dernière version du script. D'ailleurs, le script de migration vérifie que le `se3` est bien à jour et, sinon, il le met à jour ; c'est pour cette raison que vous devez le relancer pour bénéficier de la version la plus à jour du script de migration.


### Assez de place dans le répertoire `/` ?

Dans l'inteface web, entrée `Informations système/Espace disques`, le répertoire racine `/` est en orange ou en rouge : il n'y aura sans doute pas assez de place pour mener à bien le changement de version.

Si vous êtes dans ce cas, **pas de panique**, consultez [la page spéciale "je manque de place"](AugmenterRacine.md#faire-de-la-place-pour-passer-en-wheezy).


### Supprimer les profiles ?
*Franck : "le script supprime immédiatement celui du compte admin et les autres sont supprimés en arrière plan. Cela étant je vais peut être modifier cela pour être certain qu'il ne traîne plus rien à la fin du script."*
Il n'est pas interdit de le faire préventivement.
```sh
rm -rf /home/profiles/*
```


> En faisant ça, les raccourcis firefox  dégagent, non ?

> Si cela fait partie de l'arborescence `/home/profiles/`, oui, en effet. Cependant, il me semble qu'il est plutôt dans le `/home` de l'utilisateur : il n'est donc pas touché.

>Précision de Franck : seuls, les favoris `IE` passent à la trappe.

Sur les données utilisateurs, vous perdrez peu de choses : les favoris
Windows, les favoris internet explorer (IE), tout ce qui est dans le profil V2.

**NB :** comme cette opération de suppression risque d'être assez longue, il vaut mieux la lancer en utilisant une session `screen` ; [voir ci-dessous pour sa mise en œuvre](#utilisation-dune-session-screen).


### Supprimer les montages de disques externes
En accord avec une bonne pratique de sauvegarde des données, vous avez mis en place les sauvegardes `backuppc` et `sauveserveur` (pour cette dernière, la plus importante, voir ci-dessous la solution alternative). Il vaut mieux les démonter pour éviter des surprises lors de l'exécution du script de migration.
Le script démonte le disque monté sur `/var/lib/backuppc` mais pas celui monté sur `/sauveserveur`.
```sh
umount /var/lib/backuppc
umount /sauveserveur
```
…et on débranche pour éviter un remontage automatique. Voir ci-dessous. 


### Dernière précaution
Si cela n'est déjà en place, nous vous recommendons chaudement de procéder à la sauvegarde du type `sauveserveur` dont nous avons parlé ci-dessus et qui est documentée dans la solution alternative ci-dessous, avant de lancer le script de sauvegarde ; vous ferez plus sereinement la migration.


### Prévenir les collègues…
De toute façon, il est prudent de les prévenir en leur demandant de procéder à une sauvegarde de leurs données… Ce qu'ils devraient toujours faire.


### Isoler le `se3` du réseau
Par ailleurs, il faut que le `se3` ne soit pas utilisé pendant la migration.

Le mieux est de couper le `se3` du reste du réseau (si cela est possible) pour éviter que des utilisateurs tentent de s'y connecter ; je pense cela préférable vu qu'à la fin du script de migration s'exécute en arrière plan un script qui efface tous les profils et réencode les home en `UTF-8`, c'est très long !

Pour couper le `se3` du reste du réseau vous pouvez utiliser un commutateur (ou switch) sur lequel vous branchez uniquement le `se3`, la passerelle (par exemple `l'Amon`) et un ordinateur pour ouvrir une session `root` sur le `se3` via un `terminal`. Bien entendu, sur l'ordinateur utilisé, ouvrir une session locale…

Ou alors, faites la migration lorsque vous êtes sûr qu'aucune personne ne sera présente pour ouvrir une session et que tous les clients (linux ou windows) seront éteints.

Ou alors, désactiver le `dhcp` en étant sûr que les bails ont tous expirés et qu'aucun utilisateur n'aura l'idée de mettre son client en ip fixe.

Si on dispose d'un serveur owncloud relié au ldap du se3, alors il faut également l'éteindre pour éviter un usage des fichiers de session de l'extérieur.

### Temps à prévoir
Il vous faut une journée pour être sûr que tout soit bien fait.


## Migration vers un `se3-Wheezy`

### Utilisation d'une session `screen`
`screen` est une session particulière en ce sens que vous pouvez la quitter sans que le processus soit arrêté, contrairement à une session normale.

Vous trouverez une brêve [documentation de l'utilisation d'une session `screen`](../dev-clients-linux/screen.md#utilisation-dune-session-screen) qui vous permettra de découvrir cet outil, indispensable dans certaine situation.

L'utilisation de `screen` est d'ailleurs suggérée par le script.




### Utilisation du script de migration
Dans une session `screen`, lancez la commande suivante :
```sh
bash /usr/share/se3/sbin/se3_upgrade_wheezy.sh
```

Une première utilisation de ce script a lieu puis il faudra le relancer pour poursuivre la migration : les messages donnés à l'écran précisent tout cela très clairement.

Pendant cette première utilisation, le script vérifie qu'il a la dernière version stable avec cette `url` :
> http://wawadeb.crdp.ac-caen.fr/majse3/se3_upgrade_wheezy.sh

C'est une des raisons pour lesquelles le script doit être relancé. Avec la 2ème utilisation du script, on sera donc avec la version stable de ce script.

**Remarque :** il existe une version de dev' (qui sera bientôt transférée en version stable) et qui est, quant à elle, désormais sur le `github` :
> https://github.com/SambaEdu/maintscripts/blob/master/migration/se3_upgrade_wheezy.sh

Cette version de dev' ajoute quelques fonctions au script comme la possibilité d'utiliser des options afin de se trouver dans différents modes : debug, pas de téléchargement ou encore préchargement des paquets dans le cache `apt`.

Les voici (ces options ne servant que pour la mise au point du script, vous n'avez pas à les utiliser) :
* --download | -d : préparer la migration sans la lancer en téléchargeant uniquement les paquets nécessaires
* --no-update     : ne pas vérifier la mise à jour du script de migration sur le serveur centrale mais utiliser la version locale
* --debug         : lancer le script en outrepassant les tests de taille et de place libre des partitions. **À NE PAS UTILISER EN PRODUCTION**


### Redémarrer à la fin ?
Il n'est pas nécessaire de redémarrer…

Mais ce n'est pas interdit ;-) C'est comme vous voulez.
```sh
reboot
```

## Réparer `Grub` ?
Il se peut que `Grub` soit cassé à la suite de la migration ; il suffit de le réparer.

Cependant, il faudrait voir dans quel cas cela arrive pour palier ce problème.


### Télécharger et graver `boot-repair`
Récupérer l'archive `iso` de `boot-repair` :
> https://sourceforge.net/p/boot-repair/home/fr/

Graver un DVD (pas fait, je n'en ai pas eu besoin) avec cette archive `iso`.


### Démarrer le `se3` sur le DVD gravé
Il suffit d'accepter la réparation proposée par boot-repair : au redémarrage du se3, grub devrait être réparé.

**À noter :**
Si la réparation proposée par `boot-repair` ne résout toujours pas le problème `grub` du `se3`, il est toujours possible, **dans l'attente de trouver une solution alternative**, d'utiliser `super-grub2` pour faire booter son se3.

Pour cela, téléchargez puis gravez l'iso disponible à l'adresse suivante :
> http://www.supergrubdisk.org/category/download/supergrub2diskdownload/

Bootez sur le cd `super-grub2` : le `se3` devrait alors se lancer.


### Autre solution
> *Marc : "`grub-repair` n'avait pas marché (deux jours de chaos au lycée). J'avais réussi à réinstaller `grub` en suivant la procédure en `chroot` du site ci-dessous (j'avais fait les deux techniques de cette partie… Les deux m'indiquaient un message d'échec mais c'était reparti !)"*

> https://wiki.debian-fr.xyz/Réinstaller_Grub2


### `Grub` et Partitions `GPT`
Si l'installation du `se3` a été faite sur un disque de taille importante (2To...donc en format [`GPT`](https://fr.wikipedia.org/wiki/GUID_Partition_Table)) avec des partitions classiques, alors la partition de 100 Mio servant au démarrage n'a pas été créée par l'installateur Debian sur le disque contenant la racine.

La mise à jour du `Grub` va donc échouer pour donner une invite `>grub rescue` après un reboot. Aucune des solutions précédentes ne marchera tant que la partition de boot ne sera pas présente.

La seule solution pour faire repartir le serveur dans ce cas est donc:
* Créer une image `Clonezilla` du disque contenant la racine au cas où,
* Utiliser une version de `Gparted` récente à partir d'un live cd (`sysrescuecd` par exemple). Le format `XFS` des partitions `/home` et `/var/se3` doit être reconnu. Si un trinagle d'alerte arrive, alors il faut prendre une version plus récente,
* Diminuer la taille de la partition `sda1` de façon à liberer environ 100 Mio en début de disque. Valider pour que la modification se fasse,
* Créer une nouvelle partition avec ce petit espace liberé en début de disque. Ne pas la formater mais lui donner le drapeau `bios-grub`,
* Redémarrer avec le dvd `boot-repair` et faire "réparer le grub". Tout devrait repartir.


## Configurer l'onduleur

Normalement, la migration ne doit pas modifier la configuration de l'onduleur.

D'ailleurs, si cette configuration n'a pas était faite sur votre `se3-squeeze`,une fois la migration effectuée il sera plus que temps de la mettre en chantier, en vous aidant des indications de l'article suivant. Là, vous n'aurez pas d'excuses en cas de pépin…
> http://www.samba-edu.ac-versailles.fr/Configurer-l-onduleur

Cependant, il vaudra mieux configurer l'onduleur **avant la migration** car s'il y a un problème sur l'alimentation électrique ou des micro-coupures, ce sera plus chaud pour vous ;-) Mais vous aurez pris, de toute façon, la précaution d'avoir une sauvegarde de type `sauveserveur` à jour (voir la remarque 2 de la présentation ci-dessus ou bien la solution alternative ci-dessous) avant de passer aux choses sérieuses…


## Post-migration

### Annuaire incompatible
Si après le passage à Wheezy il est impossible d'ouvrir une session, sauf celle du compte admin et si dans l'interface web le bouclier de vérification du compte adminse3 d'intégration des comptes est au rouge, c'est que votre annuaire n'est pas compatible.

La cause est un défaut de structure de l'annuaire : le GID des utilisateurs n'est pas correctement renseigné.

Pour régler temporairement cette situation, le temps de rendre compatible l'annuaire, il suffit de changer un paramètre de Yes à No dans le fichier `/etc/samba/smb.conf`. Dans ce fichier, trouvez la ligne correspondant à `ldapsam:trusted` et changez `Yes` en `No`.

Ensuite, **il faut rendre compatible l'annuaire ldap**. Indispensable !

Pour cela, voici une procédure, proposée par François-Xavier Vial :

- Modifier (ou vérifier) sur l'interface pour le groupe lcs-users le GID Number à 5005
- Modifier (ou vérifier) sur l'interface dans Configuration générale - Paramètres serveur la valeur de la ligne Groupe par défaut à 5005
- Dans l'annuaire en utilisant PhpLdapAdmin, vérifier que le groupe lcs-users a bien 5005 commme gidNumber
- Vérifier que tous les utilisateurs ont bien un gidNumber positionné à 5005. Si ce n'est pas le cas, utiliser le script `se3-corrige-gidNumber.sh` qui va redresser les choses
- re-modifier le fichier `/etc/samba/smb.conf` avec un `ldapsam:trusted = Yes`
- redémarrer samba
- vérifier que ça fonctionne

### Compléments sur la compatibilité de l'annuaire `ldap`
Il faut exporter en ldif pour y regarder de plus près. Le plus souvent c'est une incohérence entre Guidnumber / Mappage du groupe par défaut.

**La bonne valeur, c'est 5005 pour tout le monde** qui lui même correspond à `lcs-users` qui doit être mappé sur le groupe windows "utilisateurs du domaine" dont le primary group SID se termine par 513.

**Exemple :**
Sur un compte lambda `hugov`, on devrait obtenir :
```sh
# ldapsearch -xLLL uid=hugov gidnumber sambaPrimaryGroupSID
dn: uid=hugov,ou=People,ou=stage,ou=ac-rouen,ou=education,o=gouv,c=fr
gidNumber: 5005
sambaPrimaryGroupSID: S-1-5-21-3271951266-3673128075-3782327119-513
```

Et pour le groupe lcs-users, on devrait obtenir :
```sh
# getent group lcs-users
lcs-users:x:5005:admin
```

À comparer avec :
```sh
# net groupmap list | grep lcs-users
Utilisateurs du domaine (S-1-5-21-3271951266-3673128075-3782327119-513) -> lcs-users
```

On notera que le SID des "Utilisateurs du domaine" du domaine est le même que celui déclaré dans l’attribut sambaPrimaryGroupSID de l'utilisateur.

Si tu as juste un ldif, tu ne pourras pas faire "net groupmap" mais tu vas trouver ceci dans ton ldif (toujours dans le même exemple) :

```
dn: cn=lcs-users,ou=Groups,ou=stage,ou=ac-rouen,ou=education,o=gouv,c=fr
objectClass: posixGroup
objectClass: top
objectClass: sambaGroupMapping
cn: lcs-users
gidNumber: 5005
memberUid: admin
sambaSID: S-1-5-21-3271951266-3673128075-3782327119-513
sambaGroupType: 2
displayName: Utilisateurs du domaine
description: Domain Unix group
```

Là dans mon exemple tout est cohérent et donc tout va bien.

S'il y a visiblement un de ces éléments qui ne va pas, reste à trouver lequel. En général c'est gidNumber qui ne correspond pas. Pour corriger cela, voir ci-dessus la procédure proposée par François-Xavier.


### Plus de réseau
Après migration, impossible de faire un ping sur la passerelle `Amon` ou sur une adresse externe. Je me suis alors aperçu que la carte réseau `eth0` était maintenant devenue `eth1`.

Il a fallut éditer le fichier `/etc/network/interfaces` et remplacer `eth0` par `eth1`. Un reboot a été nécéssaire (la commande */etc/init.d/networking restart* ne marchait pas complètement).


### Les modules
Presque tous les modules ont été reportés sur `Wheezy`. Mais `se3-unattended` a disparu (voir ci-dessous) et `se3-internet` est en testing pour l'instant.
> http://wawadeb.crdp.ac-caen.fr/versions-paquets-se3.html

**Module `se3-pla` :** c'est le nouveau paquet permettant l'exploration de l'annuaire Ldap. À vous de l'installer :
```sh
aptitude install se3-pla
```

**Module `se3-ocs` :** il est désinstallé et purgé lors de la migration. Il est ré-installable ensuite. `se3-ocs`, version `Wheezy`, sera vierge comme l'a précisé Franck. Tout est effacé du passage de `se3-squeeze` à `se3-wheezy` pour éviter des problèmes de base de donnée.

**Module `se3-maintenance` :** il a disparu (peut-être sera-t-il remis).

**Module `se3-unattended` :** ce module n'est pas supprimé lors de la migration contrairement à `se3-ocs`. Par conséquent si vous l'avez installé sous `se3-squeeze` vous conserverez cette version sous `se3-wheezy`. Simplement le module n'étant plus maintenu, il n'a pas été reporté sous `Wheezy` dans une nouvelle version.

**Le paquet wpkg `wsuoffline` :** *Laurent : "pour ce paquet wpkg, j'ai l'impression qu'il ne fait pas les mises à jour correctement sur W7 de manière automatique. Il faudrait que je jette un œil sur un poste pour en être sûr".*


**Remarque :** ne vous embêtez pas à mettre votre `se3-Wheezy` en testing, la branche stable est suffisamment bien peuplé.


### Remettre en place les disques de sauvegarde
Il suffit de rebrancher les disques et deux solutions se présentent :

* soit redémarrer le serveur si des entrées dans le fichier `/etc/fstab` concernent ces disques,
* soit de les monter conformément aux indications de la documentation.

**Remarque :** toutes les machines `bakuppc` sauvegardées antérieurement disparaissent mais il suffit de les recréer avec un nom identique pour retrouver les sauvegardes antérieures.


### Quelques vérifications
Un certain nombre de vérifications sont nécessaires :

* vérifier la présence du paquet `rsyslog`
```sh
apt-cache policy rsyslog
```
On devrait obtenir ceci :
```sh
rsyslog:
  Installé : 5.8.11-3+deb7u2
  Candidat : 5.8.11-3+deb7u2
 Table de version :
     7.6.3-2~bpo70+1 0
        100 http://ftp.fr.debian.org/debian/ wheezy-backports/main i386 Packages
 *** 5.8.11-3+deb7u2 0
        500 http://ftp.fr.debian.org/debian/ wheezy/main i386 Packages
        500 http://security.debian.org/ wheezy/updates/main i386 Packages
        100 /var/lib/dpkg/status
```

**Si le paquet est absent**, on devrait obtenir ceci :
```sh
rsyslog:
  Installé : (aucun)
  Candidat : 5.8.11-3+deb7u2
 Table de version :
     5.8.11-3+deb7u2 0
        500 http://ftp.fr.debian.org/debian/ wheezy/main i386 Packages
        500 http://security.debian.org/ wheezy/updates/main i386 Packages
```

Il faut alors l'installer :
```sh
apt-get install rsyslog
```


### Cas d'un `se3 32-bits`

Si à la suite de la migration d'un `se3 32-bits` `squeeze` vers `wheezy` il est impossible de se connecter sur les postes, alors que tout est vert sur l'interface de diagnostique, il se peut que le paquet `samba-vfs-modules` ne soit pas installé sur le serveur.

La commande suivante devrait résoudre le problème :
```sh
apt-get install samba-vfs-modules
```


## Utiliser les scripts de sauvegarde/restauration

### Une solution alternative

Au lieu d'utiliser le script de migration ci-dessus, une autre solution est la suivante :

* créer le répertoire /run/lock (nécessaire au fonctionnement du script `sauve_se3.sh`)
* sauvegarder votre serveur (script `sauve_se3.sh`)
* installer un `se3-wheezy`, par la méthode de votre choix
* configurer les modules adaptés à votre situation
* restaurer votre serveur (script `restaure_se3.sh`)

Cette méthode sera à utiliser si vous avez une version antérieure à celle de `se3-squeeze`.

Ces deux scripts (`sauve_se3.sh` et `restaure_se3.sh`) sont proposés sur le site ci-dessous, ainsi que la documentation d'utilisation.

Il est à noter que ces deux scripts ne sont pas sur votre `se3-squeeze` dans une version la plus à jour possible (et tenant compte des divers correctifs et modifications apportés). Il faudra donc utiliser [les versions les plus récentes](../../../../se3master/tree/master/usr/share/se3/sbin) dont vous pourrez consulter [la doc d'utilisation](../se3-sauvegarde/sauverestaure.md#sauvegarder-et-restaurer-un-serveur-se3).

**Remarque :** le répertoire `/run/lock/` n'est disponible qu'à partir de la version `Wheezy` et sert à poser un verrou pour éviter de lancer le script `sauve_se3.sh` si une sauvegarde est toujours en cours. La création de ce répertoire ne sera plus nécessaire pour les versions à partir de `Wheezy`. Pour la création de ce répertoire, on pourra utiliser la commande suivante :
```sh
mkdir -p /run/lock
```


### Correction du problème de l'annuaire

Il se peut qu'un problème concerne l'annuaire `Ldap` après la restauration : des messages d'erreurs apparaissent lorsqu'on se connecte sur l'interface web du se3.

Voici comment corriger cela :

* Éditer avec "nano" ou "vi" le fichier `/etc/ldap.secret`
* Relever le mot de passe contenu dans ce fichier afin de remplacer celui
de **adminPw** (administrateur de l'annuaire) dans les paramètres `LDAP` de
l'interface web du mode sans échec (http://IP_SE3:909/setup)
* Ne pas oublier de valider les modifications (bouton situé en bas de
l'interface setup)


### Cas éventuel des encodages

Sur `se3-wheezy` on est full `utf8`, et `samba 4` n'aime pas du tout les noms de fichiers avec des accents codés en `iso`. Cela fait quelques versions que nous sommes en `utf8` côté `samba` mais, pour autant, s'il y a eu des versions successives, il y a de fortes chances que de le codage `iso` traîne encore dans `/home` et `/var/se3`.

**La solution à ce problème s'il apparaît**, c'est de réencoder avec `/usr/bin/convmv`. Cela fonctionne très bien mais demande d'analyser tous les fichiers.

Les deux commandes ci-dessous réencodent en `utf8` et ont été intégrées au script de restauration dans sa version la plus récente :
```sh
/usr/bin/convmv --notest -f iso-8859-15 -t utf-8 -r /home 2>&1 | grep -v Skipping >> rapport_home.log
/usr/bin/convmv --notest -f iso-8859-15 -t utf-8 -r /var/se3 2>&1 | grep -v Skipping >> rapport_varse3.log
```


