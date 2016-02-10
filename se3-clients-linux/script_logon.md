#Le script de logon


Comme vous pourrez le constater, le script de `logon` est un peu le « chef d'orchestre » de chacun des clients `GNU/Linux`.

* [Les 3 phases d'exécution du script de `logon`](#les-3-phases-dexécution-du-script-de-logon)
    * [initialisation](#linitialisation)
    * [ouverture](#louverture)
    * [fermeture](#la-fermeture)
* [Emplacement du script de `logon`](#emplacement-du-script-de-logon)
* [Synchronisation entre un `logon` local et le `logon` distant](#synchronisation-entre-un-logon-local-et-le-logon-distant)
* [Personnalisation du script de `logon`](#le-logon_perso)


## Les 3 phases d'exécution du script de `logon`

Le script de logon est un script `bash` qui est exécuté par les clients `GNU/Linux` lors de trois phases différentes.

Pour plus de commodité dans les explications, nous allons donner un nom à chacune de ces trois phases une bonne fois pour toutes :

* l'initialisation
* l'ouverture
* la fermeture


### L'initialisation

Cette phase se produit **juste avant l'affichage de la fenêtre de connexion**.

Attention, cela correspond en particulier au démarrage du système, certes, mais *pas seulement*. L'initialisation se produit aussi juste après la fermeture de session d'un utilisateur, avant que la fenêtre de connexion n'apparaisse à nouveau (sauf si, bien sûr, l'utilisateur a choisi d'éteindre ou de redémarrer la machine).

**Description rapide des tâches exécutées par le script lors de cette phase :**

* le script efface les homes (s'il en existe) de tous utilisateurs qui ne correspondent pas à des comptes locaux
* le script vérifie si le partage `CIFS` `//SERVEUR/netlogon-linux` du serveur est bien monté sur le répertoire `/mnt/netlogon/` du client `GNU/Linux` et, si ce n'est pas le cas, le script exécute ce montage.
* le script procède, **le cas écheant**, à la synchronisation du profil par défaut local sur le profil par défaut distant
* le script lance les exécutions des `*.unefois` si l'initialisation correspond en fait à un redémarrage du système.

**Note :** Un compte local est un compte figurant dans le fichier /etc/passwd du client `GNU/Linux`.


### L'ouverture

Cette phase se produit **à l'ouverture de session d'un utilisateur** juste après que celui-ci ait saisi ses identifiants.

**Description rapide des tâches exécutées par le script lors de cette phase :**

* le script procède à la création du home de l'utilisateur qui se connecte (via une copie du profil par défaut local)
* le script exécute le montage de certains partages du serveur auxquels l'utilisateur peut prétendre (comme par exemple le partage correspondant aux données personnelles de l'utilisateur).


### La fermeture

Cette phase se produit **à la fermeture de session d'un utilisateur**.

**Description rapide des tâches exécutées par le script lors de cette phase :**

Le script ne fait rien qui mérite d'être signalé dans cette documentation. Cependant, on pourra l'utiliser en fonction des besoins des utilisateurs.


## Emplacement du script de `logon`

À la base, le script de logon se trouve localement à l'adresse `/etc/se3/bin/logon` de chaque client `GNU/Linux`. Mais il existe une version centralisée de ce script sur le serveur à l'adresse :

1. `/home/netlogon/clients-linux/bin/logon` si on est sur le serveur
2. `/mnt/netlogon/bin/logon` si on est sur un client `GNU/Linux`

Nous avons donc, comme pour le profil par défaut, des versions locales du script de `logon` (sur chaque client `GNU/Linux`) et une unique version distante (sur le serveur `se3`).


## Synchronisation entre un `logon` local et le `logon` distant

Au niveau de la synchronisation entre un `logon` local et le `logon` distant, les choses fonctionnent de manière très similaire aux profils par défaut.

**Lors de l'initialisation d'un client GNU/Linux :**

* Si le contenu du script de `logon` local est identique au contenu du script de `logon` distant, alors c'est le script de `logon` local qui est exécuté par le client `GNU/Linux`.
* Si en revanche les contenus diffèrent (ne serait-ce que d'un seul caractère), alors c'est le script de `logon` distant qui est exécuté. Mais dans la foulée, le script de `logon` local est écrasé puis remplacé par une copie de la version distante. Du coup, il est très probable qu'à la prochaine initialisation du client GNU/Linux ce soit à nouveau le script de `logon` local qui soit exécuté parce que identique à la version distante (on retombe dans le cas précédent).

À priori, cela signifie donc que, pour peu que vous sachiez parler (et écrire) le langage du script de `logon` (il s'agit du `Bash`), vous pouvez modifier uniquement le script de `logon` distant (celui du serveur se3 donc) afin de l'adapter à vos besoins.

Vos modifications seraient alors impactées sur tous les clients GNU/Linux dès la prochaine phase d'initialisation.

Seulement, **il ne faudra pas procéder ainsi** et cela pour une raison simple : après la moindre mise à jour du paquet `se3-clients-linux` ou éventuellement après une réinstallation, toutes vos modifications sur le script de logon seront effacées.

Pour pouvoir modifier le comportement du script de `logon` de manière pérenne, il faudra utiliser le fichier `logon_perso` qui se trouve dans le même répertoire que le script de logon.


## Le `logon_perso`

Le `logon_perso` permet la personnalisation du script de `logon` : Une partie importante du script de `logon` est gérée par le `logon_perso` qui permet d'aptater son fonctionnement aux besoins des utilisateurs.

Pour en savoir davantage sur le `logon_perso`, reportez-vous à [la page de personnalisation du logon](logon_perso.md).
