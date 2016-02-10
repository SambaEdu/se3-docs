# Personnaliser le script de `logon`

Une partie importante du script de `logon` est gérée par le `logon_perso` qui permet d'aptater son fonctionnement aux besoins des utilisateurs.

* [Personnaliser à l'aide du `logon_perso`](#personnaliser-le-script-de-logon)
    * [Structure du `logon_perso`](#structure-du-fichier-logon_perso)
    * [Conséquences sur le comportement du `logon`](#conséquences-du-logon_perso-sur-le-comportement-du-script-de-logon)
    * [Incorporer le `logon_perso` au `logon`](#incorporer-le-logon_perso-dans-le-logon)
* [Variables et fonctions utiles pour le `logon_perso`](#quelques-variables-et-fonctions-prêtes-à-lemploi)
* [Gestion du montage des partages réseau](#gestion-du-montage-des-partages-réseau)
    * [Un exemple](#un-exemple)
    * [Un autre exemple](#un-autre-exemple)
    * [Syntaxe de la fonction `monter_partage`](#syntaxe-de-la-fonction-monter_partage)
    * [Montage limité à un utilisateur](#montage-limité-à-un-utilisateur)
    * [Montage limité à un groupe](#montage-limité-à-un-groupe)
    * [Le montage `home` d'un utilisateur](#le-montage-home-dun-utilisateur)
    * [La fonction `creer_lien`](#la-fonction-creer_lien)
* [Gérer les profils pour `Iceweasel`](#gérer-les-profils-pour-iceweasel)
    * [à l'aide de `rsync`](#méthode-à-laide-de-rsync)
    * [à l'aide d'un partage ou d'un lien](#méthode-à-laide-dun-partage)
* [Quelques bricoles pour les perfectionnistes](#quelques-bricoles-pour-les-perfectionnistes)
    * [Changer les icônes](#changer-les-icônes-représentants-les-liens-pour-faire-plus-joli)
    * [Changer le papier peint](#changer-le-papier-peint-en-fonction-des-utilisateurs)
    * [L'activation du pavé numérique](#lactivation-du-pavé-numérique)
    * [Incruster un message sur le Bureau](#incruster-un-message-sur-le-bureau-des-utilisateurs-pour-faire-classe)
    * [Exécuter des commandes au démarrage](#exécuter-des-commandes-au-démarrage-tous-les-30-jours)



## Personnaliser le script de `logon`

Le fichier `logon_perso` va vous permettre d'affiner et personnaliser le comportement du [script de `logon`](script_logon.md) afin de l'adapter à vos besoins.

Et, très important, **cette adaptation sera pérenne dans le temps** (les modifications persisteront notamment après une mise à jour du paquet `se3-clients-linux`).


### Structure du fichier `logon_perso`

À la base, le fichier `logon_perso` est un fichier texte encodé en `UTF-8` avec des fins de ligne de type Unix . Il contient du code `Bash` et possède, par défaut, la structure suivante :

```sh
function initialisation_perso ()
{
    # …
}

function ouverture_perso ()
{
    # …
}

function fermeture_perso ()
{
    # …
}
```
**Note importante :** Attention d'utiliser un éditeur de texte respectueux de l'encodage et des fins de ligne lorsque vous modifierez le fichier `logon_perso`.


### Conséquences du `logon_perso` sur le comportement du script de `logon`

Revenons au contenu du fichier `logon_perso` pour comprendre de quelle manière il permet de modifier le comportement du script `logon`.

Dans le fichier `logon_perso`, on peut distinguer trois fonctions :

1. Tout le code que vous mettrez dans la fonction `initialisation_perso` sera exécuté lors de la phase d'initialisation des clients, **en dernier**, c'est-à-dire après que le script de logon ait effectué toutes les tâches liées à la phase d'initialisation qui sont décrites brièvement [ci-dessus](#linitialisation).

2. Tout le code que vous mettrez dans la fonction `ouverture_perso` sera exécuté lors de la phase d'ouverture des clients uniquement lorsqu'un utilisateur du domaine se connecte. Le code est exécuté **juste après** la création du « home » de l'utilisateur qui se connecte. Typiquement, c'est dans cette fonction que vous allez gérer les montages de partages réseau en fonction du type de compte qui se connecte (son appartenance à tel ou tel groupe etc).

    Vous pourrez consulter avec profit la partie de cette documentation dédiée à [la gestion des montages de partages réseau à l'ouverture de session](#gestion-du-montage-des-partages-réseau).

3. Tout le code que vous mettrez dans la fonction `fermeture_perso` sera exécuté lors de la phase de fermeture des clients, **en dernier**, c'est-à-dire après que le script de logon ait effectué toutes les tâches liées à la phase de fermeture qui sont décrites brièvement [ci-dessus](#la-fermeture).

Vous pouvez bien sûr définir dans le fichier `logon_perso` des fonctions supplémentaires, mais, pour que celles-ci soient au bout du compte exécutées par le script de `logon`, il faudra les appeler dans le corps d'une des trois fonctions `initialisation_perso`, `ouverture_perso` ou `fermeture_perso`.


### Incorporer le `logon_perso` dans le `logon`

Il faut bien avoir en tête que le contenu de `logon_perso` doit être ni plus ni moins inséré dans le script `logon` pour qu'il soit pris en compte.

En conséquence, après modification de `logon_perso`, **il faut toujours mettre à jour le fichier `logon`**

Cette mise à jour peut se faire de 2 façons :

* via  la commande « `dpkg-reconfigure se3-clients-linux` » en console `root` sur le serveur se3.

* via le fichier `reconfigure.bash` : **si vous avez ouvert une session sur un client-linux avec le compte `admin`**, vous pourrez double-cliquer sur le fichier `reconfigure.bash` accessible en passant par le lien symbolique `clients-linux` sur le bureau puis par le répertoire `bin/` (le mot de passe root du serveur se3 sera demandé). Voir le schéma de [l'arborescence du répertoire `clients-linux/`](visite_rapide.md#arborescence-du-répertoire-clients-linux).


## Quelques variables et fonctions prêtes à l'emploi

Vous trouverez, dans cette documentation, la [liste des variables et des fonctions](variables_fonctions_logon.md) que vous pourrez utiliser dans le fichier `logon_perso` et qui seront susceptibles de vous aider à affiner le comportement du script de logon.


## Gestion du montage des partages réseau

Comme cela a déjà été expliqué, c'est vous qui allez gérer les montages de partages réseau en éditant le contenu de la fonction `ouverture_perso` qui se trouve dans le fichier `logon_perso`.

Évidemment, si la gestion par défaut des montages vous convient telle quelle, alors vous n'avez pas besoin de toucher à ce fichier.


### Un exemple

Commençons par un exemple simple, concernant le répertoires des classes :
```sh
function ouverture_perso ()
{
    …
    monter_partage "//$SE3/Classes" "Classes" "$REP_HOME/Bureau/Répertoire Classes"
    …
}
```

Ici la fonction `monter_partage` possède trois **arguments qui devront être délimités par des doubles quotes** (`"`) :

1. Le premier argument représente **le chemin `UNC` du partage à monter**.

    Vous reconnaissez sans doute la variable `SE3` qui stocke l'adresse IP du serveur. Par exemple si l'adresse IP du serveur est `172.20.0.2`, alors le premier argument sera automatiquement développé en :
    `//172.20.0.2/Classes`.
    
    Cela signifie que c'est le partage `Classes` du serveur `172.20.0.2` qui va être monté sur le clients GNU/Linux.
    
    **Attention**, sous GNU/Linux un chemin UNC de partage s'écrit avec des slashs (`/`) et non avec des antislashs (`\`) comme c'est le cas sous Windows.

2. Maintenant, **il faut un répertoire local pour monter un partage**. C'est le rôle du deuxième argument.

    Quoi qu'il arrive (vous n'avez pas le choix sur ce point), le partage sera monté dans un sous-répertoire du répertoire `/mnt/_$LOGIN/`.
    
    Par exemple si c'est `toto` qui se connecte sur le poste client, le montage sera fait dans un sous répertoire de `/mnt/_toto/`.
    
    Le deuxième argument spécifie le nom de ce sous-répertoire. Ici nous avons décidé assez logiquement de l'appeler `Classes`. Par conséquent, en visitant le répertoire `/mnt/_toto/Classes/` sur le poste client, notre cher `toto` aura accès au contenu du partage `Classes` du serveur.
    
    **Attention**, dans le choix du nom de ce sous-répertoire, vous êtes limité(e) aux **caractères a-z, A-Z, 0-9, le tiret (`-`) et le tiret bas (`_`)**. C'est tout. En particulier **pas d'espace ni accent**. Si vous ne respectez pas cette consigne le partage ne sera tout simplement pas monté et une fenêtre d'erreur s'affichera à l'ouverture de session.
    
    Vous serez sans doute amené(e) à monter plusieurs partages réseau pour un même utilisateur (via plusieurs appels de la fonction `monter_partage` au sein de la fonction `ouverture_perso`). Donc il y aura plusieurs sous-répertoires dans `/mnt/_$LOGIN/`. Charge à vous d'éviter les doublons dans les noms des sous-répertoires, sans quoi certains partages ne seront pas montés.

3. À ce stade, notre cher `toto` pourra accéder au partage `Classes` du serveur en passant par `/mnt/_toto/Classes/`. Mais cela n'est pas très pratique. L'idéal serait d'**avoir accès à ce partage directement via un dossier sur le bureau** de `toto`. C'est exactement ce que fait le troisième argument.
    
    Si `toto` ouvre une session, l'argument `"$REP_HOME/Bureau/Répertoire Classes"` va se développer en `"/home/toto/Bureau/Répertoire Classes"` si bien qu'un raccourci (sous GNU/Linux on appelle ça un lien symbolique) portant le nom `Répertoire Classes` sera créé sur le bureau de `toto`.
    
    Donc en double-cliquant sur ce raccourci (ce genre de raccourci ressemble à un simple dossier), sans même le savoir, `toto` visitera le répertoire `/mnt/_toto/Classes/` qui correspondra au contenu du partage `Classes` du serveur.
    
    Vous n'êtes pas limité(e) dans le choix du nom de ce raccourci. Les espaces et les accents sont parfaitement autorisés (**évitez par contre le caractère double-quote**). En revanche, ce raccourci doit forcément être créé dans le home de l'utilisateur qui se connecte. **Donc ce troisième argument devra toujours commencer par `"$REP_HOME/..."`** sans quoi le lien ne sera tout simplement pas créé.


### Un autre exemple

Tout n'a pas encore été dévoilé concernant cette fonction `monter_partage`. En fait, vous pouvez créer autant de raccourcis que vous voulez. Il suffit pour cela d'ajouter un quatrième argument, puis un cinquième , puis un sixième etc.

Voici un exemple, toujours à propos du répertoires de classes :
```sh
function ouverture_perso ()
{
    …
    monter_partage "//$SE3/Classes" "Classes" \<Touche ENTRÉE>
        "$REP_HOME/Bureau/Lecteur réseau Classes" \<Touche ENTRÉE>
        "$REP_HOME/Lecteur réseau Classes"
    …
}
```

**Remarque :** normalement il faut mettre une fonction avec ses arguments sur une même ligne car un saut de ligne signifie la fin d'une instruction aux yeux de l'interpréteur `Bash`. Mais ici la ligne serait bien longue à écrire et dépasserait la largeur de la page de ce document. La combinaison antislash (`\`) puis ENTRÉE permet simplement de passer à la ligne tout en signifiant à l'interpréteur `Bash` que l'instruction entamée n'est pas terminée et qu'elle se prolonge sur la ligne suivante.

Le premier argument correspond toujours au **chemin `UNC` du partage réseau** et le deuxième argument au **nom du sous-répertoire dans `/mnt/_$LOGIN/` associé à ce partage**.

Ensuite, nous avons cette fois-ci un troisième **et un quatrième argument** qui correspondent aux raccourcis pointant vers le partage : l'un est créé sur le bureau et l'autre est créé à la racine du home de l'utilisateur qui se connecte.

Il est possible de créer autant de raccourcis que l'on souhaite, il suffit d'empiler les arguments 3, 4, 5 etc. les uns à la suite des autres.


### Syntaxe de la fonction `monter_partage`

La syntaxe de la fonction `monter_partage` est donc la suivante :
```sh
monter_partage "<partage>" "<répertoire>" ["<raccourci>"]...
```

où seuls les deux premiers arguments sont obligatoires :

* `<partage>` est le chemin `UNC` du partage à monter.

Il est possible de se limiter à un sous-répertoire du partage, par exemple comme dans `//$SE3//administration/docs` où l'on montera uniquement le sous-répertoire `docs/` du partage administration du serveur.

* `<répertoire>` est le nom du sous-répertoire de `/mnt/_$LOGIN/` qui sera créé et sur lequel le partage sera monté.

Seuls les caractères `-_a-zA-Z0-9` sont autorisés.

* Les arguments `<raccourci>` sont optionnels.

Ils représentent les chemins absolus des raccourcis qui seront créés et qui pointeront vers le partage. Ils doivent toujours se situer dans le home de l'utilisateur qui se connecte, donc ils doivent **toujours commencer par `"$REP_HOME/..."`**. Si ces arguments ne sont pas présents, alors le partage sera monté mais aucun raccourci ne sera créé.

**Attention :** le montage du partage réseau se fait avec les droits de l'utilisateur qui est en train de se connecter. Si l'utilisateur n'a pas les droits suffisants pour accéder à ce partage, ce dernier ne sera tout simplement pas monté.

**Remarque 1 :** au final, si vous placez bien vos raccourcis, l'utilisateur n'aura que faire du répertoire `"/mnt/_$LOGIN/"`. Il utilisera uniquement les raccourcis qui se trouvent dans son home. Peu importe pour lui de savoir qu'ils pointent en réalité vers un sous-répertoire de `"/mnt/_$LOGIN/"`, il n'a pas à s'en préoccuper.

**Remarque 2 :** je vous conseille de toujours créer au moins un raccourci à la racine du home de l'utilisateur qui se connecte. En effet, lorsqu'un utilisateur souhaite enregistrer un fichier via une application quelconque, très souvent l'explorateur de fichiers s'ouvre au départ à la racine de son home. C'est donc un endroit privilégié pour placer les raccourcis vers les partages réseau. Il me semble que doubler les raccourcis à la fois à la racine du home et sur le bureau de l'utilisateur est une bonne chose. Mais bien sûr, tout cela est une question de goût...


### Montage limité à un utilisateur

Étant donné que le montage d'un partage se fait avec les droits de l'utilisateur qui se connecte, certains partages devront être montés uniquement dans certains cas.

Prenons l'exemple du partage `netlogon-linux` du serveur. Celui-ci **n'est accessible qu'au compte `admin`** du domaine.

Pour pouvoir monter ce partage seulement quand c'est le compte admin qui se connecte, il va falloir ajouter ce bout de code dans la fonction `ouverture_perso` du fichier `logon_perso` :
```sh
function ouverture_perso ()
{
    …
    # Montage du partage "netlogon-linux" seulement dans le cas
    # où c'est le compte "admin" qui se connecte.
    if [ "$LOGIN" = "admin" ]; then
        # Cette partie là ne sera exécutée qui si c'est admin qui se connecte.
        monter_partage "//$SE3/netlogon-linux" "clients-linux" \<Touche ENTRÉE>
            "$REP_HOME/clients-linux" \<Touche ENTRÉE>
            "$REP_HOME/Bureau/clients-linux"
    fi
    …
}
```

**Remarque :** attention, en `Bash`, le crochet ouvrant au niveau du `if` doit absolument être précédé et suivi d'un espace et le crochet fermant doit absolument être précédé d'un espace.


### Montage limité à un groupe

Autre cas très classique, celui d'un partage **accessible uniquement à un groupe**.

Là aussi, une structure avec un `if` s'impose :
```sh
function ouverture_perso ()
{
    …
    # On décide que le montage du partage "administration" sera seulement effectué si
    # c'est un compte qui appartient au groupe "Profs" qui se connecte.
    if est_dans_liste "$LISTE_GROUPES_LOGIN" "Profs"; then
        monter_partage "//$SE3/administration" "administration" \<Touche ENTRÉE>
        "$REP_HOME/administration sur le réseau" \<Touche ENTRÉE>
        "$REP_HOME/Bureau/administration sur le réseau"
    fi
    …
}
```

L'instruction « `if est_dans_liste "$LISTE_GROUPES_LOGIN" "Profs"; then` » doit s'interpréter ainsi : « si dans la liste des groupes dont est membre le compte qui se connecte actuellement il y a le groupe `Profs`, autrement dit si le compte qui se connecte actuellement appartient au groupe `Profs`, alors... »

**Attention :** le test `if` ci-dessus est sensible à la casse si bien que le résultat ne sera pas le même si vous mettez `"Profs"` ou `"profs"`. Par conséquent, prenez bien la peine de regarder le nom du groupe qui vous intéresse avant de l'insérer dans un test `if` comme ci-dessus afin de bien respecter les minuscules et les majuscules.

**Astuce :** Si vous voulez savoir le nom des partages disponibles pour un utilisateur donné, par exemple `toto`, il vous suffit de lancer la commande suivante sur le serveur en tant que root :
```sh
smbclient --list localhost -U toto
# Il faudra alors saisir le mot de passe de toto.
```


### Le montage `home` d'un utilisateur

Parmi la liste des partages, l'un d'eux est affiché sous le nom de `home`. Il correspond au home de `toto` sur le serveur.

Ce partage `home` est un peu particulier car il pointera vers un répertoire différent en fonction du compte qui tente d'y accéder.

Par exemple, si `titi` veut accéder à ce partage, alors il sera rédirigé vers le répertoire `/home/titi/` du serveur.

Chaque utilisateur a le droit de monter ce partage, mais attention le chemin `UNC` est en fait `//SERVEUR/homes` (avec un « s » à la fin et d'ailleurs dans le fichier de configuration Samba ce partage est bien défini par la section `homes`).

A priori, on pourra monter ce partage pour tous les comptes du domaine donc pas besoin de structure `if` pour ce partage :
```sh
function ouverture_perso ()
{
    …
    # Montage du sous-répertoire "Docs" du partage "homes" pour tout le monde.
    monter_partage "//$SE3/homes/Docs" "Docs" \<Touche ENTRÉE>
        "$REP_HOME/Documents de $LOGIN sur le réseau" \<Touche ENTRÉE>
        "$REP_HOME/Bureau/Documents de $LOGIN sur le réseau"
    …
}
```

Dans l'exemple ci-dessus, on ne monte pas le partage `homes` mais uniquement le sous-répertoire `Docs` de ce partage.

**Note :** Comme d'habitude sous GNU/Linux, respectez bien la casse des noms de partages et de répertoires.


### La fonction `creer_lien`

Pour l'instant, de par la manière dont la fonction `monter_partage` est définie, on peut créer uniquement des liens qui pointent vers la racine du partage associé. Mais on peut vouloir par exemple monter un partage et créer des liens uniquement vers des sous-répertoires de ce partage (et non vers sa racine). C'est tout à fait possible avec la fonction `creer_lien`.

Voici un 1er exemple :
```sh
function ouverture_perso ()
{
    …
    # Montage du partage "homes" pour tout le monde, mais ici on ne créé pas de
    # lien vers la racine de ce partage (appel de la fonction avec seulement deux
    # arguments).
    monter_partage "//$SE3/homes" "home"

    # Ensuite on crée des liens mais ceux-ci ne pointent pas à la racine du partage.
    creer_lien "home/Docs" "$REP_HOME/Documents de $LOGIN sur le réseau"
    creer_lien "home/Bureau" "$REP_HOME/Bureau de $LOGIN sous Windows"
    …
}
```

* Le premier argument de la fonction `creer_lien` est **la cible du ou des liens à créer**.

Cette cible peut s'écrire sous la forme d'un chemin absolu, c'est-à-dire un chemin qui commence par un antislash (ce qui n'est pas le cas ci-dessus). Si le chemin ne commence pas par un antislash, alors la fonction part du principe que c'est un chemin relatif qui part de `/mnt/_$LOGIN/`. (Du coup, mettre `"home/Docs"` ou mettre `/mnt/_$LOGIN/home/Docs` comme premier argument revient exactement
au même.).

* Le deuxième argument et les suivants (autant qu'on veut) sont **les chemins absolus du ou des liens qui seront créés**.

Ces chemins doivent impérativement tous commencer par `"$REP_HOME/..."`.

Voici un 2ème exemple :

```sh
function ouverture_perso ()
{
    …
    # Montage du partage « perso » pour tout le monde.
     monter_partage "//$SE3/homes/Docs" "Docs" \
         "$REP_HOME/Documents de $LOGIN sur le réseau" \
         "$REP_HOME/Bureau/Documents de $LOGIN sur le réseau"
     # lien vers les documents de l'utilisateur sur le réseau
     # quand on clique sur Documents dans le navigateur de fichiers
     rm -Rf "$REP_HOME/Documents"
     creer_lien "Docs" "$REP_HOME/Documents"
     # On suppose que le partage "perso" est déjà monté et qu’un
     # lien vers ce partage a déjà été créé sur le bureau...
     changer_icone "$REP_HOME/Bureau/Documents de $LOGIN sur le réseau" \
         "$REP_HOME/.icons/Documents.png"
    …
}
```
Dans cet exemple, nous avons rajouté un lien entre le répertoire local *Documents* et le répertoire *Docs* de l'utilisateur. Ainsi, lorsque l'utilisateur clique sur le raccourcis *Documents* du navigateur de fichiers, il se trouve dans le répertoire de ses documents sur le serveur `se3`. Nous avons aussi rajouté l'utilisation de la fonction de changement d'icône qui est décrite ci-dessous.


## Gérer les profils pour Iceweasel

### Méthode à l'aide de `rsync`

J'ai testé une solution via rsync, proposée par Frédéric Sauvage sur la liste de discusion de Cæn, en rajoutant les lignes suivantes dans le `logon_perso` :

* dans la fonction ouverture_perso :
```sh
function ouverture_perso ()
{
    …
    # Synchronisation des préférences, favoris, historique... des applis
    # Le tout est enregistré dans un répertoire caché appelé .profile-linux
    # ce répertoire est stocké dans le répertoire Documents de la session de l'utilisateur.
    # On utilise rsync pour des questions de droits. (Voir page de manuel de rsync pour les options)
    # On crée (s'il n'existe pas) le répertoire .profile-linux/.mozilla
    # afin d'éviter des effets indésirables…
    # Récupération serveur → home local
    
    if est_dans_liste "$LISTE_GROUPES_LOGIN" "Profs"
    then
        [ ! -e /mnt/_$LOGIN/Docs/.profile-linux/.mozilla ] && mkdir -p /mnt/_$LOGIN/Docs/.profile-linux/.mozilla
        rsync -az --delete /mnt/_$LOGIN/Docs/.profile-linux/.mozilla/ /home/$LOGIN/.mozilla/
        chown -R $LOGIN:5005 /home/$LOGIN/.mozilla
    fi
    …
}
```

* dans la fonction fermeture perso :
```sh
function fermeture_perso ()
{
    …
    # Synchronisation des préférences, favoris, historique... des applis
    # Le tout est enregistré dans un répertoire caché appelé .profile-linux
    # Sauvegarde home local → serveur
    if est_dans_liste "$LISTE_GROUPES_LOGIN" "Profs"
    then
        rsync -az --delete /home/$LOGIN/.mozilla/ /mnt/_$LOGIN/Docs/.profile-linux/.mozilla/
    fi
    …
}
```

Cette méthode fonctionne bien mais il peut y avoir *des effets de bord* lors de la transition entre le .mozilla du skel et celui de l'utilisateur. Pour l'instant je n'ai eu qu'un seul cas dont la gestion s'est faite *à la mano*.


### Méthode à l'aide d'un partage

J'avais gardé en mémoire une autre méthode. Je crois me souvenir qu'elle avait été proposée par Stéphane Boiron (À confirmer…). Elle permet d'utiliser le même profil entre les différents clients.

La voici :

* ajouter un partage dans le logon_perso, uniquement pour les profs :

```sh
function ouverture_perso ()
{
    …
    if est_dans_liste "$LISTE_GROUPES_LOGIN" "Profs"
    then
        rm -Rf "$REP_HOME/.mozilla/firefox"
        monter_partage "//$SE3/homes/profil/appdata/Mozilla/Firefox" "ProfilFirefox" \
            "$REP_HOME/.mozilla/firefox"
    fi
    …
}
```

Je l'ai testé sur un réseau virtuel. Cette méthode est nettement plus simple que la précédente.

On peut modifier cette méthode à l'aide d'un lien si on veut séparer les profils windows et linux, comme cela est proposé ci-dessous en utilisant le partage Docs déjà monté :

* ajouter un lien dans le logon_perso, uniquement pour les profs :

```sh
function ouverture_perso ()
{
    …
    if est_dans_liste "$LISTE_GROUPES_LOGIN" "Profs"
    then
        rm -Rf "$REP_HOME/.mozilla"
        [ ! -e "/mnt/_$LOGIN/Docs/.profile-linux/.mozilla" ] && mkdir -p /mnt/_$LOGIN/Docs/.profile-linux/.mozilla
        creer_lien "Docs/.profile-linux/.mozilla" "$REP_HOME/.mozilla"
    fi
    …
}
```


## Quelques bricoles pour les perfectionnistes

### Changer les icônes représentants les liens pour faire plus joli

C'est quand même plus joli quand on a des icônes évocateurs comme ci-dessous pour nos liens vers les partages, non ?

![Jolies icônes](/doc/images/jessie_01.png)

Et bien, ça tombe bien, car c'est facile à faire avec la fonction `changer_icone`.

Voici un exemple :
```sh
function ouverture_perso ()
{
    …
    # On suppose que le partage "Classe" est déjà monté et qu'un
    # lien vers ce partage a déjà été créé sur le bureau...
    changer_icone "$REP_HOME/Bureau/Classes sur le réseau" "$REP_HOME/.mes_icones/classe.jpg"
    …
}
```

La fonction prend toujours deux arguments.

Le premier est le chemin absolu du fichier dont on veut changer l'icône. Cela peut être n'importe quel fichier (ce n'est pas forcément un des raccourcis qu'on a créé), mais par contre il doit impérativement se trouver dans le home de l'utilisateur qui se connecte (donc il devra toujours commencer par `"$REP_HOME/..."`).

Ensuite, le deuxième argument est le chemin absolu de n'importe quel fichier image (du moment que le compte qui se connecte peut y avoir accès en lecture).

Une idée possible (parmi d'autres) est de modifier le profil par défaut des d'utilisateurs et d'y placer un répertoire `.mes_icones/` dans lequel vous mettez tous les icônes dont vous avez besoin pour habiller vos liens. Ensuite, vous pourrez aller chercher vos icônes dans le home de l'utilisateur qui se connecte (dans `"$REP_HOME/.mes_icones/"` précisément) de manière similaire à ce qui est fait dans exemple ci-dessus.

**Attention :** la fonction `changer_icone` n'a aucun effet sous la distribution **Xubuntu** qui utilise l'environnement de bureau Xfce. Cela vient du fait que personnellement je ne sais pas changer l'image d'un icône en ligne de commandes sous Xfce. Si vous savez, n'hésitez pas à me donner l'information par l'intermédiaire des forums' (`l-samba-edu@ac-caen.fr` ou `news://news.ac-versailles.fr/ac-versailles.assistance-technique.samba-edu` ) car je pourrais ainsi étendre la fonction `changer_icone` à l'environnement de bureau Xfce.


### Changer le papier peint en fonction des utilisateurs

Ça pourrait être sympathique d'avoir un papier différent suivant le type de compte… Et bien c'est possible avec la fonction `changer_papier_peint`.

Voici un exemple :
```sh
function ouverture_perso ()
{
    …
    if [ "$LOGIN" = "admin" ]; then
        changer_papier_peint "$REP_HOME/.backgrounds/admin.jpg"
    fi
    …
}
```

Le seul et unique argument de cette fonction est le chemin absolu (sur la machine cliente) du fichier image servant pour le fond d'écran. Il faut bien sûr que ce fichier image soit au moins accessible en lecture pour l'utilisateur qui se connecte.

Là aussi, comme pour les icônes, l'idée est de placer dans le profil par défaut distant un répertoire `.backgrounds/` (par exemple) qui contiendra les deux ou trois fichiers images dont vous avez besoin pour faire vos fonds d'écran.

[Ci-dessus](#changer-les-icônes-représentants-les-liens-pour-faire-plus-joli), vous avez un exemple, dans le cas de `Debian/Jessie` pour le compte `admin`, voici un exemple dans le cas d'un compte de type `professeur` et pour `Ubuntu` :

![Exemple bureau prof](/doc/images/bureau-message.png)

En plus du changement de fond d'écran, il y a un petit message personnalisé qui s'affiche en haut à droite du bureau. Pour mettre en place ce genre de message, voir la section [incruster un message sur le Bureau](#incruster-un-message-sur-le-bureau-des-utilisateurs-pour-faire-classe).


### L'activation du pavé numérique

Pour activer le pavé numérique du client GNU/Linux au moment de l'affichage de la fenêtre de connexion du système, en principe ceci devrait fonctionner :
```sh
function initialisation_perso ()
{
    …
    # On active le pavé numérique au moment de la phase d'initialisation.
    activer_pave_numerique
    …
}
```

Vous pouvez remarquer que, cette fois-ci, c'est le contenu de la fonction `initialisation_perso` qui a été édité.

En revanche, pour activer le pavé numérique au moment de l'ouverture de session, procéder exactement de la même façon à l'intérieur de la fonction `ouverture_perso` risque de ne pas fonctionner, et cela **pour une raison de timing**.

En effet, au moment où la fonction `ouverture_perso` sera lancée, l'ouverture de session ne sera pas complètement terminée (Et c'est normal qu'il en soit ainsi puisque l'ouverture de session de termine après l'exécution du script de logon, même pas immédiatement après, mais 1 ou 2 secondes après selon la rapidité de la machine hôte) et l'activation du pavé numérique risque d'être annulée lors de la fin de l'ouverture de session.

L'idée est donc de programmer l'appel de la fonction `activer_pave_numerique` **après** l'exécution du script de `logon`, seulement au bout de quelques secondes (par exemple 5 s), afin de lancer l'activation du pavé numérique une fois l'ouverture de session achevée :
```sh
function ouverture_perso ()
{
    …
    #On ajoute un argument à l'appel de la fonction activer_pave_numerique.
    #Ici, cela signifie que l'activation du pavé numérique sera lancée 5
    #secondes après que le script de logon soit terminé, ce qui laissera
    #le temps à l'ouverture de session de se terminer.
    activer_pave_numerique "5"
    …
}
```


### Incruster un message sur le bureau des utilisateurs pour faire classe

Pour incruster un message sur le bureau des utilisateurs, il faudra d'abord que **le paquet `conky` soit installé** sur le client GNU/Linux.

Pour installer `conky`, vous pouvez par exemple lancer l'installation via un script `*.unefois` qui contiendrait à peu de choses près l'instruction `apt-get install --yes conky`.

Ensuite, vous créerez une fonction `lancer_conky` dans le fichier `logon_perso` :

```sh
function lancer_conky ()
{
    # On crée un fichier de configuration .conkyrc dans le home de l'utilisateur.
    # précisant le contenu du message ainsi que certains paramètres (comme la
    # taille de la police par exemple).
    cat > "$REP_HOME/.conkyrc" <<FIN
use_xft yes
xftfont Arial:size=10
double_buffer yes
alignment top_right
update_interval 1
own_window yes
own_window_transparent yes
own_window_argb_visual yes
override_utf8_locale yes
text_buffer_size 1024
own_window_hints undecorated,below,sticky,skip_taskbar,skip_pager
TEXT
Bonjour $NOM_COMPLET_LOGIN,

Pensez bien à enregistrer vos données personnelles
dans le dossier :

    Documents de $LOGIN sur le réseau

qui se trouve sur le bureau, et uniquement dans ce
dossier, sans quoi vos données seront perdues une
fois votre session fermée.

    Cordialement.
    Les administrateurs du réseau pédagogique.

FIN
    
    # On fait de "$LOGIN" le propriétaire du fichier .conkyrc.
    chown "$LOGIN:" "$REP_HOME/.conkyrc"
    chmod 644 "$REP_HOME/.conkyrc"

    #On lancera conky à la fin, une fois l'exécution du script logon terminée.
    #Pour être sûr que l'ouverture de session est achevée, on laisse un délai
    #de 5 secondes entre la fin du script de logon et le lancement de la
    #commande conky (avec ses arguments).
    executer_a_la_fin "5" conky --config "$REP_HOME/.conkyrc"
}
```

Enfin, vous rajouterez l'appel de cette fonction dans la fonction `ouverture_perso` :

```sh
function ouverture_perso ()
{
    …
    # Incruster un message sur le bureau des utilisateurs pour faire "classe" :
    lancer_conky
    …
}
```

En principe, vous devriez voir apparaître un message incrusté sur le bureau des utilisateurs en haut à droite. Ce message sera légèrement personnalisé puisqu'il contiendra le nom de l'utilisateur connecté.


### Exécuter des commandes au démarrage tous les 30 jours

Toutes les commandes que vous mettrez à l'intérieur de la fonction `initialisation_perso` du fichier `logon_perso` seront exécutées à chaque phase d'initialisation du système ce qui peut parfois s'avérer un peu trop fréquent à votre goût.

Voici un exemple de fonction `initialisation_perso` qui vous permettra d'exécuter des commandes (peu importe lesquelles ici) au démarrage du système tous les 30 jours (pour peu que le système ne reste pas éteint indéfiniment bien sûr) :

```sh
function initialisation_perso ()
{
    …
    local indicateur
    indicateur="/etc/se3/action_truc"
    # Si le fichier n'existe pas alors il faut le créer.
    [ ! -e "$indicateur" ] && touch "$indicateur"
    
    # On teste si la phase d'initialisation correspond à un démarrage du système.
    if "$DEMARRAGE"; then
        # On teste si la date de dernière modification du fichier est > 29 jours.
        if find "$indicateur" -mtime +29 | grep -q "^$indicateur$"; then
            echo "Les conditions sont vérifiées, on lance les actions souhaitées."
            action1
            action2
            # etc.
            
            # Si tout s'est bien déroulé, alors on peut mettre à jour la date
            # de dernière modification du fichier avec la commande touch.
            if [ "$?" = "0" ]; then
                touch "$indicateur"
            fi
        fi
    fi
    …
}
```

L'idée de ce code est plus simple qu'il n'y paraît.

Chaque client GNU/Linux intégré au domaine possède un répertoire local `/etc/se3/` (accessible en lecture et en écriture au compte `root` uniquement).

Dans ce répertoire, le script y place un fichier texte vide qui se nomme `action_truc` (c'est un exemple) et dont le seul but est de fournir une date de dernière modification.

Au départ, cette date de dernière modification coïncide au moment où le fichier est créé. Si, lors d'un prochain démarrage, cette date de dernière modification est vieille de 30 jours ou plus, alors les actions sont exécutées et la date de dernière modification du fichier `action_truc` est modifiée artificiellement en la date du jour avec la commande `touch`.


