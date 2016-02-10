# La gestion des profils


Dans cette documentation, on appellera « profil » le contenu
**ou une copie du contenu** du `home d'un utilisateur`.

Par exemple, le profil de `toto` est le contenu du répertoire
`/home/toto/`).

* [Le partage `netlogon-linux`](#le-partage-netlogon-linux)
* [Les différentes copies du profil par défaut](#les-différentes-copies-du-profil-par-défaut)
* [Le mécanisme des profils](#le-mécanisme-des-profils)
* [Exemple de modification du profil par défaut avec Firefox](#exemple-de-modification-du-profil-par-défaut-avec-firefox)
* [Personnaliser le profil en fonction de l'utilisateur](#personnaliser-le-profil-en-fonction-de-lutilisateur)


## Le partage `netlogon-linux`

Pour bien comprendre le mécanisme des
profils, il faut avoir en tête ces deux éléments :

1. Le serveur Samba offre un partage CIFS dont le chemin
réseau est `//SERVEUR/netlogon-linux/` et qui correspond sur
le serveur au répertoire `/home/netlogon/clients-linux/`.
2. Sur chaque client GNU/Linux intégré au domaine, le
répertoire `/mnt/netlogon/` est un point de montage (en
lecture seule) du partage CIFS `//SERVEUR/netlogon-linux/`.

**Conclusion à bien avoir en tête :** sur un client
GNU/Linux intégré au domaine, visiter le répertoire local
`/mnt/netlogon/` revient en fin de compte à visiter le
répertoire `/home/netlogon/clients-linux/` du serveur Samba.

Dans le tableau ci-dessous, les trois « adresses » suivantes
désignent finalement **la même zone de stockage** qui se trouve
sur le serveur se3 :

Chemin réseau          | Chemin local sur le serveur     | Chemin local sur un client GNU/Linux
---------------------- | ------------------------------- | ------------------------------------
`//SE3/netlogon-linux` | `/home/netlogon/clients-linux/` | `/mnt/netlogon/`


## Les différentes copies du profil par défaut

Revenons maintenant à nos profils. En fin de compte, pour un
client GNU/Linux donné qui a été intégré au domaine, il
existe plusieurs copies du profil par défaut des
utilisateurs.

Par exemple, **Dans le cas des clients sur Debian Jessie**, il y a :

1. Le profil par défaut **distant** qui est unique et
centralisé sur le serveur. Il est accessible de plusieurs
manières. Les trois « adresses » ci-dessous accèdent toutes
à ce même profil par défaut **distant** :

    * à travers le réseau via le partage CIFS :
    `//SERVEUR/netlogon-linux/distribs/jessie/skel/`
    * sur le serveur directement à l'adresse :
    `/home/netlogon/clients-linux/distribs/jessie/skel/`
    * sur chaque client Jessie intégré au domaine via le chemin :
    `/mnt/netlogon/distribs/jessie/skel/`

2. Le profil par défaut **local** qui se trouve sur chaque
client intégré au domaine dans le **répertoire local**
`/etc/se3/skel/` (ce répertoire n'est pas un point de
montage, c'est un répertoire local au client GNU/Linux).


## Le mécanisme des profils

Voici comment fonctionne le mécanisme des profils du point
de vue d'un client GNU/Linux sous Debian Jessie (sous une
autre distribution, c'est exactement la même chose) :

1. **Au moment de l'affichage de la fenêtre de connexion**
du système (c'est-à-dire soit juste après le démarrage du
système ou soit juste après chaque fermeture de session).
    
    le client GNU/Linux va comparer le contenu de deux fichiers :
    
    1. le fichier `/etc/se3/skel/.VERSION` de son profil par défaut **local**
    
    2. le fichier `/mnt/netlogon/distribs/jessie/skel/.VERSION` du profil par défaut **distant**.
    
    Si ces deux fichiers ont un contenu totalement identique,
    alors le client GNU/Linux ne fait rien car il estime que son
    profil par défaut **local** et le profil par défaut
    **distant** sont identiques.
    Si en revanche les deux fichiers ont un contenu différent,
    alors le client va modifier son profil par défaut **local**
    afin qu'il soit identique au profil par défaut **distant**.
    Autrement dit, il va synchroniser 3 son profil par défaut **local**
    par rapport au profil par défaut **distant**.
    
    **Note :** Le terme de synchronisation est bien adapté car
    c'est justement la commande `rsync` qui est utilisée pour
    effectuer cette tâche.

2. **Au moment de l'ouverture de session** d'un compte du
domaine, (c'est-à-dire juste après une saisie correcte du
login et du mot de passe d'un compte du domaine).
    
    Appelons ce compte toto, le client GNU/Linux va créer le répertoire
    (local) vide `/home/toto/` et le remplir en y copiant dedans
    le contenu de son profil par défaut local (c'est-à-dire le
    contenu du répertoire `/etc/se3/skel/`) afin de compléter le
    home de `toto`.

3. **Au moment de la fermeture de session**
    
    tous les liens symboliques situés dans `/home/toto/`
    qui permettent d'atteindre les différents partages
    auxquels `toto` peut prétendre sont supprimés.

4. **Au moment du prochain affichage de la fenêtre de connexion**
(c'est-à-dire ou bien juste après la fermeture
de session de `toto` s'il n'a pas choisi d'éteindre le poste
client ou bien au prochain démarrage du système).
    
    À ce moment, **le répertoire `/home/toto/` est tout simplement effacé**.


## Exemple de modification du profil par défaut avec Firefox

Du point de vue de l'utilisateur, cette gestion des profils
est assez contraignante.

Par exemple notre cher `toto` aura
beau modifier son profil durant sa session (changer le fond
d'écran, ajouter un lanceur sur le bureau), après une
fermeture puis réouverture de session, il retrouvera
inlassablement le même profil par défaut et toutes ses
modifications auront disparu.

De plus, tous les comptes du
domaine (que ce soit les comptes professeur ou les comptes
élève) possèdent exactement le même profil par défaut.

**Note :** Cette restriction pourra, dans une certaine
mesure, être levée lorsqu'on abordera [la personnalisation du
script de logon](script_logon.md#personnaliser-le-script-de-logon).

Seule la liste des partages réseau accessibles sera
différente d'un compte à l'autre.

Mais ceci étant dit, cette
gestion des profils présente tout de même deux avantages
importants :

1. **Ouverture de session rapide :**
    
    En effet, au moment de l'ouverture de session
    d'un compte du domaine, la création du home ne sollicite pas
    le réseau puisqu'elle passe par une simple copie locale
    du contenu de `/etc/se3/skel/` qui est copié dans `/home/toto/`.

2. **Modification du profil par défaut (pour tous les utilisateurs) simple et rapide :**
    
    En effet, il devient très facile de modifier le profil par défaut des utilisateurs,
    car, si vous avez bien suivi, c'est le profil par défaut
    **distant** (celui sur le serveur) qui sert de modèle à tous
    les profils par défaut **locaux** des clients GNU/Linux. Une
    modification du profil par défaut **distant** accompagnée
    d'une modification du fichier `.VERSION` associé sera
    impactée sur chaque profil par défaut **local** de tous les
    clients GNU/Linux.

Prenons un exemple avec le navigateur `Firefox` (`Iceweasel` pour `Debian`) : vous
souhaitez imposer un profil par défaut particulier au niveau
de Firefox pour tous les utilisateurs du domaine sur les
clients GNU/Linux de type `Precise Pangolin`.

Pour commencer,vous devez ouvrir une session sur un client GNU/Linux
`Precise Pangolin` et lancer `Firefox` afin de le configurer
exactement comme vous souhaitez qu'il le soit pour tous les
utilisateurs (page d'accueil, proxy, etc).

Une fois le paramétrage effectué, pensez bien sûr à fermer l'application
`Firefox`. Ensuite, il vous suffit de suivre la procédure
ci-dessous.

Pour la suite, on admettra que la session
utilisée pour fabriquer le profil Firefox par défaut est
celle du compte `toto`.

1. Il faut copier le répertoire `/home/toto/.mozilla/` (et
tout son contenu bien sûr.
    En effet, c'est ce répertoire qui
    contient tous les réglages concernant Firefox que vous avez
    effectués) dans le profil par défaut **distant** du serveur,
    et cela tout en veillant à ce que les droits sur la copie
    soient corrects. Pour ce faire, vous avez deux méthodes
    possibles :
    
    * **Méthode graphique :** vous copiez le répertoire `/home/toto/.mozilla/`
    sous une clé USB puis vous fermez la session de `toto` pour en rouvrir une
    avec le compte `admin` du domaine. Ensuite, vous double-cliquez sur le lien
    symbolique `clients-linux` qui se trouve sur le bureau puis vous vous
    rendez successivement dans `distribs/` → `precise/` → `skel/` pour enfin,
    via un glisser-déposer, copier dans `skel/` le répertoire `.mozilla/` qui
    se trouve dans la clé USB (le dossier `skel/` devra donc contenir un
    répertoire `.mozilla/`).
    
    Attention, en général, les répertoires dont le nom
    commence par un point sont cachés par défaut et pour qu'ils
    s'affichent dans l'explorateur de fichiers il faudra sans
    doute activer une option du genre « `afficher les fichiers
    cachés` ».
    
    Enfin, comme vous avez ajouté des fichiers dans le
    répertoire `clients-linux/` du serveur, il faut reconfigurer
    les droits des fichiers. Pour ce faire, vous double-cliquez
    sur le lien symbolique `clients-linux` qui se trouve sur le
    bureau puis vous vous rendez dans `bin/` et vous
    double-cliquez sur le fichier `reconfigure.bash` (vous
    devrez saisir le mot de passe `root` du serveur).
    
    * **Méthode via la ligne de commandes :** sur la session de `toto`
    restée ouverte, vous ouvrez un terminal et vous lancez les commandes
    suivantes :
    ```sh
    # Répertoire du client GNU/Linux à copier sur le serveur.
    SOURCE="/home/toto/.mozilla/"
    
    # Destination sur le serveur.
    DESTINATION="/home/netlogon/clients-linux/distribs/precise/skel/"
    
    # Copie du répertoire local (et de tout son contenu) vers le serveur.
    scp -r "$SOURCE" root@IP-SERVEUR:"$DESTINATION"
    ```
    
    À ce stade, le répertoire `.mozilla/` a bien été copié
    sur le serveur mais les droits Unix sur la copie ne sont pas
    encore corrects. Pour les reconfigurer, il faut exécuter la
    commande « `dpkg-reconfigure se3-clients-linux` » en tant
    que `root` sur le serveur. Là aussi, cela peut se faire
    directement du client GNU/Linux, sans bouger, via ssh avec
    la commande :
    ```sh
    # Avec ssh, en étant sur le client GNU/Linux, on peut exécuter notre commande
    # à distance sur le serveur tant que root.
    ssh -t root@IP-SERVEUR "dpkg-reconfigure se3-clients-linux"
    ```

2. Modifiez le fichier `.VERSION` du profil par défaut **distant**.
    
    Ce fichier `.VERSION` est un simple fichier texte, vous
    pouvez le modifier avec un simple éditeur. S'il contient la
    chaîne « 1 » par exemple, alors éditez-le et écrivez « 2 » à
    la place. Si vous préférez, vous pouvez très bien indiquer
    la date du moment comme dans « Le 13 décembre 2013 à
    15h04 ». Le but est simplement, qu'une fois modifié, le
    fichier `.VERSION` du serveur possède un contenu différent
    de chacun des fichiers `.VERSION` locaux aux machines
    clientes. Dans notre exemple, le fichier se trouve dans le
    répertoire `/home/netlogon/clients-linux/precise/skel/` du
    serveur. Là aussi, deux méthodes s'offrent à vous pour le
    modifier :
    
    **Note :** Ne pas oublier cette étape, sans quoi les
    clients GNU/Linux estimeront que le profil par défaut
    distant n'a pas été modifié et la mise à jour du profil par
    défaut local n'aura pas lieu.
    
    * **La méthode graphique :** si ce n'est pas déjà fait, vous fermez
    la session de `toto` pour vous connecter sur le client
    GNU/Linux avec le compte `admin` du domaine. Ensuite, vous
    double-cliquez sur le lien symbolique `clients-linux` qui se
    trouve sur le bureau puis vous vous rendez successivement
    dans `distribs/` → `precise/` → `skel/`. Faites en sorte
    d'activer l'option « `afficher les fichiers cachés` » afin
    de voir apparaître le fichier `.VERSION` qui se trouve à
    l'intérieur du dossier `skel/`. Éditez ce fichier afin
    simplement de modifier son contenu. Bien sûr, pensez à
    enregistrer la modification. Pas besoin ici de reconfigurer
    les droits car le fait de modifier le contenu du fichier
    `.VERSION` ne change pas les droits sur ce fichier qui, a
    priori, étaient déjà corrects.
    
    * **Méthode via la ligne de commandes :** sur la session de
    `toto` restée ouverte, vous ouvrez un terminal et vous
    lancez les commandes suivantes :
    
    ```sh
    # Le fichier sur le serveur qu'il faut modifier.
    CIBLE="/home/netlogon/clients-linux/distribs/precise/skel/.VERSION"
    
    ssh root@IP-SERVEUR "echo Version du 10 janvier 2012 à 15h04 > $CIBLE"
    # Maintenant le fichier contient "Version du 10 janvier 2012 à 15h04".
    ```

Dès le prochain affichage de la fenêtre de connexion, les
profils par défaut **locaux** de tous les clients `Precise Pangolin`
seront modifiés afin d'être identiques au profil
par défaut **distant** du serveur. Dès lors, les
utilisateurs bénéficieront des paramétrages de Firefox que
vous avez effectués.

De la même manière que précédemment, sur le profil par
défaut **distant**, vous pouvez parfaitement définir le
contenu du bureau des utilisateurs : au lieu de copier un
répertoire `.mozilla/` sur le serveur, ce sera un répertoire
`Bureau/`, mais le principe reste le même.

**Note :** D'une distribution à une autre, les versions des
logiciels n'étant pas forcément identiques, chaque
distribution prise en charge possède son propre profil par
défaut **distant**.

Sur le serveur Samba, on a donc :

* le répertoire `/home/netlogon/clients-linux/distribs/jessie/skel/`
pour les Debian Jessie.
* le répertoire `/home/netlogon/clients-linux/distribs/precise/skel/`
pour les Ubuntu Precise Pangolin.


## Personnaliser le profil en fonction de l'utilisateur

La rigidité de la gestion du profil telle qu'elle est
décrite à la section précédente peut cependant être
contournée en modifiant le script de `logon`.

Pour comprendre cela, poursuivons avec l'exemple de la modification du
profil par défaut de `Mozilla`.

Imaginons que vous souhaitiez
que les enseignants disposent d'un navigateur dont la
configuration diffère de celle à laquelle accèdent les
élèves (extensions particulières, favoris différents, etc.).

**Note :** Le fonctionnement du script de logon est décrit
[à cette page](script_logon.md#le-script-de-logon).

Dans ce cas, vous copierez sur le répertoire `/skel` du
serveur le répertoire `/home/toto/.mozilla` après l'avoir
renommé en `/.mozilla-prof`.

Évidemment, dans ce cas, si un enseignant ouvre une session
et lance son navigateur, la configuration prise en compte
par le système sera toujours celle du répertoire
`/.mozilla`. Il faut donc, pour achever ce processus,
modifier le fichier `logon_perso` pour qu'au moment de
l'ouverture de session, le répertoire `/.mozilla` soit
remplacé par `/.mozilla-prof` si et seulement si c'est un(e)
enseignant(e) qui se connecte.

Pour ce faire, vous utiliserez [les variables prêtes à l'emploi](variables_fonctions.md#des-variables-et-des-fonctions-prêtes-à-lemploi),
et indiquerez dans la fonction `ouverture_perso` les lignes suivantes :

```sh
    # chargement du profil mozilla pour les profs
    if est_dans_liste "$LISTE_GROUPES_LOGIN" "Profs"; then
        rm -rf "$REP_HOME/.mozilla"
        mv "$REP_HOME/.mozilla-prof" "$REP_HOME/.mozilla"
    fi
```

Ainsi, à l'ouverture de session, si l'utilisateur qui se
connecte est un(e) enseignant(e), le `logon_perso`
commencera par supprimer le répertoire `.mozilla`, puis
renommera `/.mozilla-prof` en `/.mozilla`, permettant ainsi
au système de prendre en compte ce répertoire pour la
configuration du navigateur.

Vous imaginez la suite : on
peut, avec cette méthode, personnaliser la configuration de
tous les logiciels et de l'environnemnet de bureau pour
chaque profil, voire pour chaque utilisateur.


