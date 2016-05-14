# Migration de se3-squeeze vers se3-wheezy

* [Présentation](#présentation)
* [Préparation du `se3 Squeeze`](#préparation-du-se3-squeeze)
    * [Configurer `apt`](#configurer-apt)
    * [Mise à jour du `se3` ?](#mise-à-jour-du-se3)
    * [Supprimer les profiles ?](#supprimer-les-profiles)
    * [Supprimer les montages de disques externes](#supprimer-les-montages-de-disques-externes)
    * [Prévenir les collègues…](#prévenir-les-collègues…)
* [Migration vers un `se3-Wheezy`](#migration-vers-wheezy)
    * [Utilisation une session `screen`](#utiliser-une-session-screen)
    * [Utilisation du script de migration](#utilisation-du-script-de-migration)
    * [Redémarrer à la fin ?](#redémarrer-à-la-fin)
* [Réparer `Grub` ?](#réparer-Grub)
    * [Télécharger et graver `boot-repair`](#télécharger-et-graver-boot-repair)
    * [Démarrer le `se3` sur le DVD](#Démarrer-le-se3-sur-le-dvd)
* [Post-migration](#post-migration)
    * [Module `se3-pla`](#module-se3-pla)
    * [Remettre en place les disques de sauvegarde](#remettre-en-place-les-disques-de-sauvegarde)



## Présentation

Cet article est une synthèse, en cours d'élaboration, à partir des messages parus sur la liste de dicussion de l'académie de Cæn `l-samba-edu@ac-caen.fr` : il est donc en évolution en fonction des questions et des réponses apparues lors de la discussion sur cette liste.

**Remarque :** toutes les infos de l'échange ne sont pas encore intégrées ; cela prend un certain temps…

Si des intérrogations surgissent au cours de la lecture de cet article, n'hésitez pas à les partager sur la liste.


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
inutile, cela sera fait par le script de migration ; cependant, pour les angoissés, voici quelques commandes utiles pour cette mise à jour :
```sh
aptitude update
aptitude safe-upgrade
aptitude -P full-upgrade # selon la réponse, validez
bash /usr/share/se3/scripts/se3_update_system.sh
```


### Supprimer les profiles ?
 (pour Windows7)
```sh
rm -rf /home/profiles/*
```
> En faisant ça, les raccourcis firefox  dégagent, non ?
Si cela fait partie de l'arborescence `/home/profiles/`, oui, en effet. Cependant, il me semble qu'il est plutôt dans le `/home` de l'utilisateur : il n'est donc pas touché. À vérifier !

### Prévenir les collègues…
De toute façon, il est prudent de les prévenir en leur demandant de procéder à une sauvegarde de leurs données… Ce qu'ils devraient toujours faire.

Par ailleurs, il faut que le `se3` ne soit pas utilisé pendant la migration.

### Supprimer les montages de disques externes
Souvent, on a mis en place les sauvegardes backuppc et sauveserveur. Il vaut mieux les démonter pour éviter des surprises lors de l'exécution du script de migration.
```sh
umount /var/lib/backuppc
umount /sauveserveur
```
…et on débranche pour éviter un remontage automatique. Voir ci-dessous. 


## Migration vers un `se3-Wheezy`

### Utilisation une session `screen`
(peut-être faut-il plus détailler ?
`screen` est une session particulière en ce sens que vous pouvez la quitter sans que le processus soit arrêté, contrairement à une session normale. Vous trouverez sans doute de la doc sur la toile. Sinon, il faudrait que je retrouve un mémo écrit par François Lafont.
```sh
screen
```

### Utilisation du script de migration
```sh
bash /usr/share/se3/sbin/se3_upgrade_wheezy.sh
```

Une première utilistaion de ce script a lieu puis il faudra le relancer pour poursuivre la migration : les messages donnés à l'écran précisent tout cela très clairement.


### Redémarrer à la fin ?
reboot


## Réparer `Grub` ?
 (si nécessaire)

il se peut que `Grub` soit cassé à la suite de la migration
il suffit de le réparer

### Télécharger et graver `boot-repair`
https://sourceforge.net/p/boot-repair/home/fr/


graver DVD (pas fait, je n'en ai pas eu besoin) 


### Démarrer le `se3` sur le DVD


## Post-migration

### Module `se3-pla`
(module d'exploration de l'annuaire Ldap)
aptitude install se3-pla


### Remettre en place les disques de sauvegarde
backuppc et sauveserveur

