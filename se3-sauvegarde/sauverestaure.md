# Sauvegarder et restaurer un serveur `se3`

* [Présentation](#présentation)
* [Les scripts](#les-scripts)
* [Où sauvegarder ?](#où-sauvegarder-)
* [Réseau pédagogique et passerelle `Amon`](#réseau-pédagogique-et-passerelle-amon)
* [La sauvegarde](#la-sauvegarde)
    * [Les étapes de la mise en place](#les-étapes-de-la-mise-en-place)
    * [Préparation du disque dur externe](#préparation-du-disque-dur-externe)
    * [Montage du disque externe sur le répertoire `/sauvese3`](#montage-du-disque-externe-sur-le-répertoire-sauvese3)
    * [Utilisation du script en mode test](#utilisation-du-script-en-mode-test)
    * [Utilisation manuelle du script en mode verbeux](#utilisation-manuelle-du-script-en-mode-verbeux)
    * [Utilisation programmée du script](#utilisation-programmée-du-script)
    * [Montage automatique du disque dur externe de sauvegarde](#montage-automatique-du-disque-dur-externe-de-sauvegarde)
    * [Utilisation d'un `NAS`](#utilisation-dun-nas)
    * [Utilisation conjointe du script de sauvegarde et du module `Backuppc`](#utilisation-conjointe-du-script-de-sauvegarde-et-du-module-backuppc)
* [La restauration](#la-restauration)
    * [Conditions d'utilisation](#conditions-dutilisation)
    * [Montage du disque dur externe `usb` ou du `NAS`](#montage-du-disque-dur-externe-usb-ou-du-nas)
    * [Lancement du script de restauration en mode test](#lancement-du-script-de-restauration-en-mode-test)
    * [Lancement du script de restauration en mode restauration](#lancement-du-script-de-restauration-en-mode-restauration)
* [Des problèmes ?](#des-problèmes-)
    * [Erreur lors de l'envoi du courriel](#erreur-lors-de-lenvoi-du-courriel)
    * [Problèmes rencontrés lors d'une restauration](#problèmes-rencontrés-lors-dune-restauration)
        * [Accès à l'interface `setup` mais pas à l'interface `web`](#accès-à-linterface-setup-mais-pas-à-linterface-web)
        * [Un message d'erreur indique que l'annuaire ne peut être joint et que la base `DN` est correcte](#un-message-derreur-indique-que-lannuaire-ne-peut-être-joint-et-que-la-base-dn-est-correcte)
    * [En cas de problème insoluble](#en-cas-de-problème-insoluble)



## Présentation

Nous vous proposons une solution de sauvegarde et de restauration *clé en main* pour votre serveur `se3`.

Il s'agit de pouvoir restaurer un `se3` rapidement à la suite d'un crash disque ou pour migrer sur un nouveau serveur ou une nouvelle version de `se3`.

La solution proposée ici est indépendante du module `Backuppc` du serveur `se3`. D'ailleurs, on pourra utiliser, en complément, les fonctionnalités du module `Backuppc` qui permettent de récupérer des documents effacés par mégarde par les utilisateurs.


## Les scripts

Les scripts, de sauvegarde `sauve_se3.sh` et de restauration `restaure_se3.sh`, seront maintenant disponibles directement sur votre serveur `se3`.

Les 2 scripts se trouveront dans le répertoire `/usr/share/se3/sbin` du `se3` dans la prochaine mise à jour prévue en octobre 2016.

Si vous n'êtes pas en `Wheezy` mais dans une version antérieure, telle que `Lenny` ou `Squeeze`, il faudra mettre en place le script `sauve_se3.sh` en le téléchargeant. Cependant, certaines commandes utilisées dans cet article ne seront pas disponibles sur un `se3` en `Lenny` mais on pourra utiliser des commandes de remplacement telles que `parted` ou `fdisk`. Si ces commandes ne vous sont pas familières, utilisez le forum versaillais ou la liste de discussion de Cæn pour leur utilisation.

Les [versions en développement des scripts](../../../../se3master/tree/master/usr/share/se3/sbin) sont aussi disponibles et correspondent à cette documentation.


## Où sauvegarder ?

Il y a plusieurs possibilités pour stocker la sauvegarde :

* sur un disque externe usb
* sur un `NAS`
* sur un serveur distant

Les indications ci-dessous sont données pour l'utilisation d'un disque dur externe usb et vous trouverez aussi quelques indications concernant l'utilisation d'un `NAS`.

L'utilisation d'un serveur distant est possible mais n'est pas documentée : il suffira d'adapter ce qui est indiqué pour un `NAS`.


## Réseau pédagogique et passerelle `Amon`

Si la passerelle de votre réseau pédagogique est un `Amon`, il est nécessaire d'avoir [paramétré l'envoi des courriels](http://www.samba-edu.ac-versailles.fr/spip.php?article60).


## La sauvegarde

### Les étapes de la mise en place

Voici les grandes lignes de la mise en place de la sauvegarde, certaines étapes sont détaillées par la suite :

- préparer le disque dur externe
- créer le répertoire `/sauvese3`
- monter le disque dur externe dans le répertoire `/sauvese3`
- lancer le script `sauve_se3.sh` en mode test pour vérifier que tout est en place
- lancer le script `sauve_se3.sh` en mode silencieux à l'aide de {crontab} pour réaliser une sauvegarde programmée


### Préparation du disque dur externe

Si cela est nécessaire, il faudra formater le disque dur en `ext3`.

Voici une procédure pour réaliser ce formatage :

* Avant de brancher le disque dur externe, repérez les disques et partitions disponibles, à l'aide de la commande suivante :
```sh
lsblk
```

* Brancher le disque dur sur un port usb puis relancez la commande précédente.
Par comparaison, vous devriez trouver comment est repéré le disque branché.


Dans l'exemple ci-dessus, le disque dur externe est repéré par `/dev/sdb1`.

* Vérifiez que la partition repérée n'est pas montée, à l'aide de la commande suivante :
```sh
mount | grep ^/dev | gawk -F" " '{print $1" "$2" "$3}'
```

Ce qui peut donner ceci :
> /dev/sda2 on /

> /dev/sda6 on /home

> /dev/sda3 on /var

> /dev/sda5 on /var/se3


**Remarque :** si elle est montée (/dev/sdb1 apparaîtrait dans la réponse précédente), la démonter à l'aide de la commande suivante :
```sh
umount /dev/sdb1
```

* Formatez le disque dur externe à l'aide de la commande suivante :
```sh
mkfs.ext3 /dev/sdb1
```

### Montage du disque externe sur le répertoire `/sauvese3`

Le disque étant repéré par `/dev/sdb1` (voir ci-dessus), il s'agit de le monter sur le répertoire `/sauvese3`. Voici comment faire cette opération :

* Créez le répertoire `/sauvese3`
```sh
mkdir /sauvese3
```
Et le disque externe usb étant préparé (voir ci-dessus), on peut le monter :

* Montez le disque externe `/dev/sdb1`
```sh
mount /dev/sdb1 /sauvese3
```

### Utilisation du script en mode test

Il s'agit de vérifier que tout est en place pour la sauvegarde : pour cela, utilisez le script en mode test ; ce qui correspond à **l'option -t** du script.

La commande est la suivante :
```sh
sauve_se3.sh -t
```

Une fois le script terminé, vous pourrez vérifier, par la méthode de votre choix, la présence des deux dossiers de sauvegarde sur le disque externe.

En plus de l'affichage à l'écran, le script fait parvenir un courriel comme pour une sauvegarde en mode verbeux ou en mode silencieux (voir ci-dessous).

Si un problème est détecté, reprenez les étapes de la mise en place ci-dessus ou décrivez votre problème sur le forum (avec *force détails*).


### Utilisation manuelle du script en mode verbeux

L'utilisation du script de sauvegarde en mode verbeux ou en mode silencieux (ce mode est plutôt prévu pour une utilisation programmée via `crontab`) sera assez longue, notamment la première fois : prévoir 2 heures ou plus selon la masse des données à sauvegarder.

La commande est la suivante :
```sh
sauve_se3.sh -v
```

**Conseil :** si vous utilisez manuellement le script, [nous vous conseillons d'utiliser **screen**](../dev-clients-linux/screen.md#utilisation-dune-session-screen), ce qui vous permettra de vous déconnecter sans interrompre le déroulement du script, ce qui peut être assez long.


### Utilisation programmée du script

L' option **-s** permet de lancer régulièrement le script en mode silencieux (aucun affichage à l'écran sauf en cas d'erreur) via le `crontab`.

* Entrez dans l'éditeur de crontab
```sh
crontab -e
```

* Ajoutez l'action à programmer

Par exemple pour une sauvegarde tous les jours à 4h du matin
```sh
 0 4 * * * /usr/share/se3/sbin/sauve_se3.sh -s
```

* Sauvegardez et quittez

Pour cela, et si l'éditeur choisi est `nano` (c'est celui par défaut ; et si l'éditeur n'est pas `nano`, il est raisonnable de penser que vous savez faire…), utilisez la combinaison de 2 touches `Ctrl`+`o` et tapez sur `Entrée`, puis la combinaison de 2 touches `Ctrl`+`x` et tapez sur `Entrée`.

La sauvegarde est désormais opérationnelle et s’effectuera selon la tâche planifiée que vous aurez mise en place. Un courriel vous parviendra à la fin de chaque sauvegarde.

**Conseil :** informez-vous [sur la syntaxe de crontab](http://fr.wikipedia.org/wiki/Crontab).

**Remarque :** il se peut, lors de la 1ère sauvegarde notamment, qu'une sauvegarde se lance alors que la précédente ne soit pas terminée : *pas de panique*, le script `sauve_se3.sh` détectera cette situation et s'arrêtera avant de lancer la sauvegarde.


### Montage automatique du disque dur externe de sauvegarde

En cas de redémarrage de votre serveur `se3`, il est possible de remonter automatiquement le disque dur externe usb qui stocke la sauvegarde de votre serveur.

Pour cela, il suffit d'utiliser le fichier `/etc/fstab`.

* Éditez le fichier `/etc/fstab`
```sh
nano /etc/fstab
```

* Ajoutez la ligne de montage

À la fin du fichier, rajouter la ligne suivante :
```sh
UUID=xxx /sauvese3 ext3 defaults 0 0
```
Dans cette ligne, vous remplacerez xxx par la valeur de l'UUID du disque dur externe.

* Sauvegardez la modification et quittez l'éditeur de fichier

Pour cela, utilisez la combinaison de 2 touches `Ctrl`+`o` et tapez sur `Entrée`, puis la combinaison de 2 touches `Ctrl`+`x` et tapez sur `Entrée`.

**Remarque :** pour connaître la valeur de l'UUID du disque dur externe, vous pouvez utiliser la commande suivante :
```sh
blkid | grep /dev/sdb1
```
où `/dev/sdb1` est à adapter en fonction de votre situation (voir ci-dessus).


### Utilisation d'un `NAS`

À la place d'un disque dur externe `usb`, on peut utiliser un `NAS`. Il suffira de monter la partie du `NAS` qui doit recevoir la sauvegarde sur le répertoire `/sauvese3` du `se3` et ensuite d'utiliser le script `sauve_se3.sh` comme cela est expliqué ci-dessus.

**Recommendations :** pour éviter les problèmes concernant les propriétaires des fichiers :
- s'assurer que la partage `NFS` a l'option **pas de mappage**
- décocher l'option **NFS4** au niveau du `NAS` et du partage qui doit accueillir la sauvegarde `se3`
- ajouter l'option **nfsvers=3** lors du montage du partage sur le se3 :
```sh
mount -t nfs -o nfsvers=3 192.168.1.5:/volume1/sauveserveur /sauvese3
```
Dans cette commande, `192.168.1.5` est l'ip du `NAS`, `/volume1/sauveserveur` est la partie du `NAS` qui doit recevoir la sauvegarde et `/sauvese3` est le répertoire du `se3` dans lequel est monté le `NAS`.


### Utilisation conjointe du script de sauvegarde et du module `Backuppc`

Si, parallèlement au script `sauve_se3.sh` vous utilisez le module `Backuppc` du `se3`, le plus simple est d'utiliser 2 disques durs externes usb ou bien 2 parties d''un `NAS`.

La cohabitation sur un seul disque dur externe `usb` entre ces deux types de sauvegarde ne pose pas de problème. Mais le mieux est d'utiliser un disque dur externe pour chacune de ces deux sauvegardes car, d'une part, elles sont indépendantes et, d'autre part, le prix actuel des disques dur externes `usb` est de l'ordre de 60 €.

Cependant, si vous tenez absolument à n'utiliser qu'un seul disque dur externe `usb`, il faudra utiliser le répertoire `/var/lib/backuppc` au lieu du répertoire `/sauvese3` et modifier, en conséquence, la valeur de la variable `MONTAGE` du script `sauve_se3.sh` en mettant **/var/lib/backuppc** au lieu de **/sauvese3**.

**Remarque :** cette modification du script sera à prévoir à chaque mise à jour du `se3`.

Si vous utilisez un `NAS`, il suffira de prévoir 2 partitions de votre `NAS`, chaque partition du `NAS` devant être montée sur la partition correspondante du serveur `se3`.


## La restauration

### Conditions d'utilisation

Le script de restauration `restaure_se3.sh` est prévu pour remettre en état l'ensemble des données et les fonctionnalités principales de votre ancien serveur `se3`.

En fonction des particularités de votre `se3`, il faudra prévoir de remettre en place manuellement ces particularités.

Les étapes de la restauration sont donc :

* Installez le nouveau serveur en prenant soin de bien renseigner les champs avec les paramètres de votre ancien serveur (même nom netbios, même mdp, même baseDN, etc.). Typiquement, il suffit de reprendre le fichier **setup_se3.data** de l'ancien serveur `se3`.

Pour rappel, [une procédure d'installation est disponible sur le site](http://www.samba-edu.ac-versailles.fr/spip.php?article19).

* Une fois l’installation terminée, activez tous les modules et les paramétrer comme sur l'ancien serveur ; notamment le plan d'adressage doit être compatible avec les adresses `ip` fixes et celles qui sont réservées.

* Vérifiez que votre `se3` accède bien au `web`.

* Branchez ou monter le disque dur externe `usb` ou le `NAS` contenant la sauvegarde à restaurer.

* Utilisez le script de restauration en mode test pour vérifier que tout est en place.

* Lancez enfin le script en mode restauration (utilisez une session `screen`).


### Montage du disque dur externe `usb` ou du `NAS`

**Si la sauvegarde se trouve sur un disque dur externe `usb`**, il suffira de le brancher sur un port `usb` du serveur `se3`.

Mais vous pouvez aussi le monter sur le répertoire `/restaurese3` après avoir créé ce répertoire :
```sh
mkdir /restaurese3
mount /dev/sdc1 /restaurese3
```
pour cette dernière commande, il faudra au préalable [avoir repéré le nom (via la commande `lsblk`)](#préparation-du-disque-dur-externe) avec lequel le disque externe a été nommé.

**Si la sauvegarde se trouve sur une partie d'un `NAS`**, vous monterez cette partie sur le répertoire `/restaurese3` après avoir créé ce répertoire :
```sh
mkdir /restaurese3
mount -t nfs -o nfsvers=3 192.168.1.5:/volume1/sauveserveur /restaurese3
```
pour cette dernière commande, voir [les recommendations faites dans la partie concernant la sauvegarde](#utilisation-dun-nas).


### Lancement du script de restauration en mode test

Le script de restauration comporte une option de test **-t** qui vous permettra de contrôler si les conditions d'utilisation du script sont bien en place et si la sauvegarde que vous possédez est bien disponible.

Lancez le script de restauration en mode test
```sh
/restaure_se3.sh -t
```
Celui-ci va vous poser quelques questions et vous proposera les sauvegardes disponibles. Vous pourrez en choisir une mais sa restauration ne sera pas effectuée.

À la fin du test, un courriel est envoyé à l'administrateur et un compte-rendu est disponible : **/root/restauration_date**.


### Lancement du script de restauration en mode restauration

Lorsque tout est prêt pour lancer la restauration, nous vous conseillons d'utiliser une session `screen` qui vous permettra de vous déconnecter sans interrompre le déroulement du script.

* Lancez le script de restauration en mode restauration
```sh
/restaure_se3.sh -r
```
Celui-ci va vous poser quelques questions et vous proposera les sauvegardes disponibles (comme dans le mode test) pour restaurer l'une d'elles.

Une fois la restauration lancée, il y aura la possibilité de ne pas restaurer les répertoires `/home` et `/var/se3`. Cela peut être utile en cas de problème (voir ci-dessous).

Lors de la phase de restauration des répertoires `/home` et `/var/se3` vous pouvez aller prendre un café ou deux : c'est assez long.

* Redémarrez bien le serveur en fin de script, comme cela est proposé.

À la fin de la restauration, un courriel est envoyé à l'administrateur. Un fichier  de log est disponible. Ce fichier est disponible sur le serveur `se3` : **/root/restauration_date**.


## Des problèmes ?

### Erreur lors de l'envoi du courriel

Lors du lancement du script **sauve_se3.sh -t** (en mode test), on obtient un message d'erreur concernant l'envoi du courriel.

Dans ce cas, il suffit de reconfigurer l'application `mailx` :
```sh
update-alternatives --config mailx
```

2 possibilités sont offertes :
> heirloom-mailx (proposition par défaut)

> mail.mailutils

Il suffit alors de choisir `mail.mailutils`.

Relancez le test (**sauve_se3.sh -t**) pour vérifier que l'erreur est corrigée.


### Problèmes rencontrés lors d'une restauration

#### Accès à l'interface `setup` mais pas à l'interface `web`

* Connectez-vous sur le nouveau serveur `se3` pour saisir la commande suivante :
```sh
tail -f /var/log/syslog
```
* Tentez une connexion sur l'interface `web`
* Regardez en même temps les messages sur le `se3`


#### Un message d'erreur indique que l'annuaire ne peut être joint et que la base `DN` est correcte

* Éditez, sur l'ancien serveur, le fichier `setup_se3.data` pour y récupérer le mot de passe d'origine du `LDAP`
* Recopiez-le dans le champ adéquat sur l'interface `setup` du nouveau `se3`
* Relancez la restauration sans la restauration de `/home` et de `/var/se3`
* Redémarrez le serveur
* Tentez une connexion


### En cas de problème insoluble

Si vous n'arrivez pas à résoudre un problème lors de l'utilisation des scripts de sauvegarde et de restauration, n'hésitez pas : exposez votre problème sur le [forum versaillais](http://web2news.ac-versailles.fr/tree.php?group_name=ac-versailles_assistance-technique_samba-edu).

Soyez le plus précis possible :-)

Et si vous avez eu un problème et que vous avez trouvé une solution, vous pouvez compléter cette doc :-)

