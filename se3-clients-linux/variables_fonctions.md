#Des variables et des fonctions prêtes à l'emploi pour des scripts

Voici la liste des variables et des fonctions pouvant être utilisées dans le `logon_perso` et dans les scripts `unefois`.

 **Liste des variables**           | **Liste des fonctions**
-----------------------------------|-------------------------------------------------------
  [`SE3`](#se3)                    |  [`appartient_au_parc`](#appartient_au_parc)
  [`NOM_DE_CODE`](#nom_de_code)    |  [`afficher_liste_parcs`](#afficher_liste_parcs)
  [`ARCHITECTURE`](#architecture)  |  [`est_dans_liste`](#est_dans_liste)
  [`BASE_DN`](#base_dn)            |  [`appartient_au_groupe`](#appartient_au_groupe)
  [`NOM_HOTE`](#nom_hote)          |  [`afficher_liste_groupes`](#afficher_liste_groupes)
                                   |  [`est_utilisateur_local`](#est_utilisateur_local)
                                   |  [`est_connecte`](#est_connecte)
                                   |  [`activer_pave_numerique`](#activer_pave_numerique)

**Nota :** d'autres [variables et fonctions](variables_fonctions_logon.md) pourront être utiles pour le fichier `logon_perso`.


## `SE3`

Cette variable stocke l'adresse `IP` du serveur `se3`.

Elle a été récupérée automatiquement lors de l'installation du paquet `se3-clients-linux`.


## `NOM_DE_CODE`

Cette variable stocke ce qu'on appelle le « nom de code » de la distribution.

Par exemple, `jessie` dans le cas d'une `Debian Jessie`, `trusty` dans le cas d'une `Ubuntu Trusty`.


## `ARCHITECTURE`

Cette variable stocke l'architecture du système.

Par exemple, si le système repose sur une architecture 64 bits, alors la variable stockera la chaîne de caractères `x86_64`.


## `BASE_DN`

Cette variable contient le suffixe de base `LDAP` de l'annuaire du serveur `se3`.

Elle pourra vous être utile si vous souhaitez faire vous-même des requêtes `LDAP` particulières sur les clients à l'aide de la commande `ldapsearch`.


## `NOM_HOTE`

Cette variable stocke le nom du client `GNU/Linux` (celui qui se trouve dans le fichier de configuration `/etc/hostname`).

Par exemple, si vous avez pris l'habitude de choisir des noms de machines de la forme `<salle>-xxx` (comme dans `S121-PC04` ou même comme dans `S18-DELL-02`), alors vous pourrez récupérer le nom de la salle où se trouve le client `GNU/Linux` par l'intermédiaire de la variable `NOM_HOTE` comme ceci :
```sh
SALLE=$(echo "$NOM_HOTE" | cut -d'-' -f1)

if [ "$SALLE" = "S121" ]; then
    # Les trucs à faire si on est dans la salle 121.
fi

if [ "$SALLE" = "S18" ]; then
    # Les trucs à faire si on est dans la salle 18.
fi
# etc.
```


## `appartient_au_parc`

Cette fonction permet de savoir si une machine appartient à un parc donné.

Pour ce faire, la fonction `ppartient_au_parc` interroge l'annuaire du serveur via une requête `LDAP`.

Voici un exemple d'utilisation :
```sh
if appartient_au_parc "S121" "$NOM_HOTE"; then
    # La machine appartient au parc S121
else
    # La machine n'appartient pas au parc S121
fi
```


## `afficher_liste_parcs`

Un exemple vaudra mieux qu'un long discours :
```sh
liste_parcs=$(afficher_liste_parcs "S121-LS-P")
```

Dans cet exemple, la fonction effectue une requête `LDAP` auprès du serveur `se3` afin de connaître les noms de tous les parcs auxquels appartient la machine `S121-LS-P`.

Si la machine `S121-LS-P` appartient aux parcs `S121` et `PostesProfs`, alors la variable `liste_parcs` contiendra deux lignes, la première contenant `S121` et la deuxième contenant `PostesProfs`.

L'idée est de stocker tous les parcs d'une machine dans une variable, le tout en une seule requête `LDAP`.

Enfin, à la place de `S121-LS-P` comme argument de la fonction, on aurait pu utiliser `$NOM_HOTE`, comme dans l'exemple ci-dessous qui sera plus éclairant sur la manière dont on peut exploiter de telles listes.


## `est_dans_liste`

Là aussi, illustrons cette fonction par un exemple :
```sh
# On récupère la liste des parcs auxquels
# appartient la machine cliente.
liste_parcs=$(afficher_liste_parcs "$NOM_HOTE")

if est_dans_liste "$liste_parcs" "PostesProfs"; then
    # Si la machine est dans le parc "PostesProfs"
    # alors faire ceci...
elif est_dans_liste "$liste_parcs" "CDI"; then
    # Si la machine est dans le parc "CDI"
    # alors faire ceci...
else
    # Sinon faire cela...
fi
```

L'idée, ici, est qu'une seule requête `LDAP` est effectuée (lors de la première instruction). Ensuite, les tests `if` ne sollicitent pas le réseau puisque la liste des parcs est déjà stockée dans la variable `liste_parcs`.


----

Les fonctions suivantes sont moins pertinentes dans les scripts `*.unefois` qui, rappelons-le, sont exécutés **juste après le démarrage du système**. Mais elles restent toutefois disponibles également et donc figurent quand même dans ce tableau.

En revanche, nous verrons, lors [de la personnalisation du script de `logon`](script_logon.md#personnaliser-le-script-de-logon), que ces fonctions sont également disponibles à des moments beaucoup plus pertinents, comme par exemple au moment de **l'ouverture de session d'un utilisateur** sur le système.

----


## `appartient_au_groupe`

Cette fonction permet de savoir si le login d'un utilisateur correspond à un compte qui appartient à un groupe donné.

Pour ce faire, la fonction `appartient_au_groupe` interroge l'annuaire du serveur via une requête `LDAP`.

Voici un exemple :
```sh
if appartient_au_groupe "Classe_1ES2" "toto"; then
    # Le compte toto appartient à la classe 1ES2.
else
    # Le compte toto n'appartient pas à la classe 1ES2.
fi
```


# `afficher_liste_groupes`

Un exemple vaudra mieux qu'un long discours :
```sh
liste_groupes_toto=$(afficher_liste_groupes "toto")
if est_dans_liste "$liste_groupes_toto" "Eleves"; then
    # toto est un élève alors faire ceci...
fi
```

Dans cet exemple, la fonction effectue une requête `LDAP` auprès du serveur `se3` afin de connaître le nom des groupes auxquels le compte utilisateur `toto` appartient.

Si, par exemple, ce compte appartient aux groupes `Eleves` et `Classe_1ES2`, alors la variable `liste_groupes_toto` contiendra deux lignes, la première contenant `Eleves` et la deuxième contenant `Classe_1ES2`.

L'idée est de stocker tous les groupes d'un compte donné dans une variable, le tout en une seule requête `LDAP`.


# `est_utilisateur_local`

Cette fonction permet de tester si un compte est local (c'est-à-dire contenu dans le fichier `/etc/passwd` du client `GNU/Linux`) ou non (c'est-à-dire un compte du domaine contenu dans l'annuaire du serveur `se3`).

```sh
if est_utilisateur_local "toto"; then
    # toto est un compte local, alors faire ceci...
fi
```

# `est_connecte`

Cette fonction permet de tester si un compte est actuellement connecté au système (c'est-à-dire s'il a ouvert une session).

```sh
if est_connecte "toto"; then
    # toto est actuellement connecté au système,
    # alors faire ceci...
fi
```

# `activer_pave_numerique`

Cette fonction, qui ne prend pas d'argument, permet simplement d'activer le pavé numérique du client `GNU/Linux`.

