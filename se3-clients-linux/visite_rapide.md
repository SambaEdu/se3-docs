#Visite rapide du répertoire clients-linux/ du serveur

Afin de faire un rapide tour d'horizon du paquet `se3-clients-linux`, voici ci-dessous un schéma du contenu du répertoire `/home/netlogon/clients-linux/` du serveur.

Les noms des répertoires possèdent un slash à la fin, sinon il s'agit de fichiers standards.

* [Arborescence du répertoire clients-linux/](#arborescence-du-répertoire-clients-linux)
* [Quelques commentaires rapides](#quelques-commentaires-rapides)
    * [Le répertoire `bin/`](#le-répertoire-bin)
    * [Le répertoire `distribs/`](#le-répertoire-distribs)
    * [Le répertoire `divers/`](#le-répertoire-divers)
    * [Le répertoire `unefois/`](#le-répertoire-unefois)

Certains fichiers ou répertoires, dont vous n'avez pas à vous préoccuper, ont été omis afin d'alléger le schéma et les explications qui vont avec. Notamment le répertoire `save` dont le contenu est essentiel lors de l'intégration des clients-linux.

Les fichiers ou répertoires que vous êtes libre de modifier pour les adapter à vos besoins sont mis en évidence ci-dessous par des `**...**`. À l'inverse, vous ne devez pas modifier tous les autres fichiers ou répertoires.

**Note :** En fait, vous pouvez le faire bien sûr car vous êtes `root` sur le serveur. Mais les modifications effectuées sur les fichiers/répertoires qui ne sont pas mis en évidence ci-dessous par des `**...**` sur le schéma ne survivront pas à une réinstallation ou à une mise à jour du `paquet se3-clients-linux`. Par contre, les fichiers/répertoires qui sont mis en évidence ci-dessous par des `**...**` ne seront pas affectés par une mise à jour du paquet `se3-clients-linux`.


## Arborescence du répertoire clients-linux/

**Schéma de l'arborescence du répertoire clients-linux/**
```
    ── clients-linux/
       ├── bin/
       │   ├── connexion_ssh_serveur.bash
       │   ├── logon
       │   ├── **logon_perso**
       │   └── reconfigure.bash
       │
       ├── distribs/
       │   ├── jessie/
       │   │   ├── integration/
       │   │   │   └── integration_jessie.bash
       │   │   └── **skel**/
       │   │
       │   ├── precise/
       │   │   ├── integration/
       │   │   │   ├── desintegration_precise.bash
       │   │   │   └── integration_precise.bash
       │   │   └──  **skel**/
       │   │
       │   ├── squeeze/
       │   │   ├── integration/
       │   │   │   ├── desintegration_squeeze.bash
       │   │   │   └── integration_squeeze.bash
       │   │   └── **skel**/
       │   │
       │   ├── trusty/
       │   │   ├── integration/
       │   │   │   └── integration_trusty.bash
       │   │   └── **skel**/
       │   │
       │   └── wheezy/
       │       ├── integration/
       │       │   └── integration_wheezy.bash
       │       └── **skel**/
       │
       ├── **divers**/
       │
       └── **unefois**/
```


## Quelques commentaires rapides


### Le répertoire `bin/`

* **Le répertoire `bin/` contient en premier lieu le fichier `logon` qui est le script de logon**

Ce fichier `logon` est véritablement le chef d'orchestre de tous les clients GNU/Linux intégrés au domaine. C'est lui qui contient les instructions exécutées systématiquement par les clients GNU/Linux juste avant l'affichage de la fenêtre de connexion, au moment de l'ouverture de session et au moment de la fermeture de session.

Ce fichier `logon` est expliqué à la section [logon-script](script_logon.md).

En principe, vous ne devez pas modifier ce fichier `logon`. En revanche, vous pourrez modifier le fichier `logon_perso` juste à côté.

Ce fichier `logon_perso` vous permettra d'affiner le comportement du script `logon` afin de l'adapter à vos besoins. Vous trouverez toutes les explications nécessaires dans la section [personnalisation](script_logon.md#personnaliser-le-script-de-logon).

* **Le répertoire `bin/` contient également le fichier `connexion_ssh_serveur.bash`**

Il s'agit simplement d'un petit script exécutable qui, lorsque sous serez connecté(e) avec le compte `admin` sur un client GNU/Linux et que vous double-cliquerez dessus, vous permettra d'ouvrir une connexion SSH sur le serveur en tant que `root` (autrement dit une console à distance sur le serveur en tant que `root`).

C'est une simple commodité. Bien sûr, il vous sera demandé de fournir le mot de passe du compte `root` sur le serveur.

Pour fermer proprement la connexion SSH, il vous suffira de taper sur la console la commande `exit`.

* **Enfin, le répertoire `bin/` contient le fichier `reconfigure.bash`**

Il s'agit d'un fichier exécutable très pratique qui vous permettra de remettre les droits par défaut sur l'ensemble des fichiers du paquet `se3-clients-linux` se trouvant sur le serveur et d'insérer le contenu du fichier `logon_perso` (votre fichier personnel que vous pouvez modifier afin d'ajuster le comportement des clients GNU/Linux selon vos préférences) à l'intérieur du fichier `logon` qui est le seul fichier lu par les clients GNU/Linux.

Vous pourrez lancer cet exécutable `reconfigure.bash` à partir du compte `admin` du domaine sur un client GNU/Linux intégré.

Cet exécutable utilise une connexion SSH en tant que `root` et à chaque fois il faudra donc saisir le mot de passe `root` du serveur se3.


## Le répertoire `distribs/`

Le répertoire `distribs/` contient un sous-répertoire par distribution GNU/Linux prise en charge par le paquet et, dans chacun d'eux, il y a notamment un répertoire `integration/` et un répertoire `skel/`.

* Le dossier `integration/`

Ce répertoire contient le `script d'intégration`.

C'est ce script qu'il faudra exécuter en tant que `root` sur chaque client que l'on souhaite intégrer au domaine du serveur. Pour l'utilisation de ce script, voir la section [Intégration d'un client GNU/Linux](impatients.md#intégration-dun-client-gnulinux).

Les options disponibles dans ce script d'intégration sont décrites dans la section [options-integration](options_scripts.md).

* Le dossier `skel/`

Ce répertoire contient **le profil par défaut** de tous les utilisateurs du domaine sur la distribution concernée.

**Note :** Certains fichiers et répertoires de ce dossier sont cachés. Pour les afficher, vous pouvez utiliser la combianiason de touches `Ctrl+h`.

Si vous voulez modifier la page d'accueil du navigateur de tous les utilisateurs du domaine ou bien si vous voulez ajouter des icônes sur le bureau, c'est dans ce dossier `skel/` qu'il faudra faire des modifications. Vous trouverez toutes les explications nécessaires dans la section [profils](gestion_profils.md).


### Le répertoire `divers/`

Le répertoire `divers/` ne contient pas grand chose par défaut et vous pourrez à priori y mettre ce que vous voulez.

L'intérêt de ce répertoire est que, si vous y placez des fichiers (ou des répertoires), ceux-ci seront accessibles uniquement par le compte `root` local de chaque client GNU/Linux et par le compte `admin` du domaine.

En particulier, vous aurez accès au contenu du répertoire `divers/` à travers le script de logon et à travers les scripts `unefois` (évoqués ci-dessous) qui sont tous les deux exécutés par le compte `root` local de chaque client GNU/Linux. Vous trouverez un exemple d'utilisation possible de ce répertoire dans la section [imprimante](imprimantes.md).


### Le répertoire `unefois/`

Le répertoire `unefois/` sert à gérer l'exécution de scripts une seule fois sur toute une famille de clients GNU/Linux intégrés au domaine.

Ce répertoire peut s'avérer utile pour effectuer des tâches administratives sur les clients GNU/Linux. Toutes les explications nécessaires sur ce répertoire se trouvent dans la section [unefois](repertoire_unefois.md).

