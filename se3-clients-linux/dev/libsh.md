# La petite boîte à outils `lib.sh`


## Principe général

Afin d'éviter autant que possible la duplication de code, le
fichier `src/home/netlogon/clients-linux/lib.sh` est une
petite boîte à outils de fonctions shell réutilisables dans
d'autres scripts shell, sous deux conditions. En effet, lors
du build du package :

- si un script shell se trouve dans `src/`,
- et s'il contient la ligne `###LIBSH###`

alors cette ligne sera ni plus ni moins remplacée par le
contenu du fichier `lib.sh`.



## Quelques bonnes pratiques à mettre en place dans `lib.sh`


### Que des déclarations de fonctions, rien d'autre

Le contenu de `lib.sh` ne devra **rien exécuter du tout** et
faire **uniquement des déclarations** de fonctions (une
*déclaration* de fonction, c'est toujours inoffensif).


### Déclarer les fonctions avec la syntaxe POSIX

Peut-être que le fichier `lib.sh` sera amené à être inclus
ailleurs que dans du shell bash, par exemple dans du shell
`/bin/sh`. Par conséquent, ne pas utiliser cette déclaration
de fonction :

```sh
function my_function () {
    # ...
}
```

Utiliser cette forme de déclaration (qui est POSIX) :

```sh
my_function () {
    # ...
}
```

D'une manière générale, éviter le plus possible les syntaxes
propres à bash. Un bon moyen de tester son code sur ce point
là consiste à juste changer le shebang du script et mettre
`#!/bin/sh` au lieu de `#!/bin/bash`.


### Faire des fonctions sans effets de bord

C'est sans doute le point le plus important. Les fonctions
ne doivent pas changer l'état du script appelant (le script
« appelant » d'une fonction est simplement le script qui
lance l'exécution de la fonction). Par exemple ceci est à
éviter impérativement :

```sh
my_function () {

    var='xxxxx'

    #...
}
```

En effet, la variable `var` ici n'est pas locale à la
fonction. Par exemple, imaginez qu'il y ait plus loin dans
le code ceci :

```sh
var='valeur-super-importante'

# Appel de la fonction.
my_function

echo "$var"
```

Le `echo` affichera `xxxxx` et non pas
`valeur-super-importante` comme on pourrait le penser de
prime abord, car l'exécution de la fonction a changé la
valeur de la variable `var` du script appelant. Pour éviter
cela, déclarez dans les fonctions **uniquement** des
variables **locales** avec le mot clé `local` :


```sh
my_function () {

    local var='xxxxx'

    # Rq: la syntaxe suivante est également possible
    #     et totalement équivalente.
    #
    #       local var
    #       var='xxxxx'

    #...
}
```

Cette fois-ci, si une variable `var` est déjà définie au
niveau du script appelant, celle-ci ne sera pas modifiée par
l'exécution de la fonction `my_function` (il s'agit de deux
variables qui certes portent le même nom même mais qui se
trouvent dans des zones de la mémoire RAM différentes).

Si jamais vous avez besoin qu'une fonction utilise une
variable du script appelant, passez-la en argument de la
fonction. Par exemple, dans `lib.sh` :

```sh
my_function () {

    # $1 est le premier argument qui est passé à la fonction.
    # Il est vide s'il n'y a pas d'argument. $2 est le deuxième
    # argument passé à la fonction, et ainsi de suite.
    local var="$1"

    # Remarquez au passage que la variable var est bien locale
    # à la fonction. Elle contiendra simplement une copie de
    # l'argument qui est passé à la fonction.

    # Code où l'on fait usage de la variable local var...
}
```

Et dans le script appelant, on pourra alors utiliser la
fonction ainsi :


```sh
var='valeur-super-importante'

# Appel de la fonction. L'argument var est ici une variable
# du script appelant. La fonction va juste copier son
# contenu dans sa variable locale var.
my_function "$var"
```

Si vous souhaitez changer la valeur d'une variable du script
appelant, vous pouvez faire comme ceci :

```sh
# Dans lib.sh.
update_var () {

    local var="$1"

    # Du code où var est modifiée etc...

    # Ceci est globalement équivalent à un « echo "$var"
    # mais en plus robuste.
    printf '%s\n' "$var"

}


# Dans le script appelant.
var='a_default_value'

# On met à jour la valeur de "var". La modification de la
# valeur de "var" est explicitement faite au niveau du
# script appelant, elle n'est pas enfouie dans le corps de
# la fonction "update_var".
var=$(update_var "$var")
```


### Code de retour d'une fonction

Faire en sorte que le code de retour de la fonction reflète
le bon déroulement ou non de son exécution. Pour cela
utilisez l'instruction `return`. Une fonction shell doit :

* retourner 0 si tout s'est bien passé (c'est d'ailleurs ce
  que font toutes les commandes du shell comme grep par exemple),
* retourner un entier entre 1 et 255 (inclus) si tout ne s'est
  pas bien passé.

Voici un exemple mais ce n'est pas la seule façon de faire :

```sh
my_function () {

    cmd1
    cmd2

    if truc1_pas_ok
    then
        return 1
    fi

    if truc2_pas_ok
    then
        return 1
    fi

    # ...

    # Bon, tout est Ok alors on peut renvoyer 0.
    return 0
}
```

**Remarque :** si on ne précise pas d'instruction `return`,
le code de retour de la fonction sera celui de sa dernière
commande exécutée (ce qui peut être pratique parfois). Par
exemple avec :

```sh
my_function() {
    # Le code de retour de la fonction sera celui de la
    # commande cmd3.
    cmd1
    cmd2
    cmd3
}
```


### Ne pas confondre le code de retour d'une fonction et sa sortie

Pour le code de retour d'une fonction, voir le point
ci-dessus. La sortie d'une fonction n'a rien à voir a
priori. La sortie est simplement ce qu'une fonction affiche.
C'est important car cela permet de récupérer de nouvelles
valeurs et de les stocker dans des variables du script
appelant. Par exemple :

```sh
generate_password() {

    local passwd
    # Du code...

    echo "$passwd"

    # Inutile ici, le code de retour sera celui de la
    # commande echo, c'est-à-dire 0 a priori.
    #
    #return 0

}
```

Et dans le script appelant :

```sh
# La variable "passwd" contiendra la valeur de la variable
# locale "passwd" de la fonction generate_password.
passwd=$(generate_password)
```

Ici, on a donc la fonction `generate_password` :

* dont le code de retour est 0,
* dont la sortie affiche un mot de passe (qui est
  récupéré dans la variable "passwd" du script appelant).

Pour récupérer la sortie d'une fonction (et de n'importe
quelle commande en général), on fait :

```sh
var=$(my_function)
```

Et pour récupérer le code de retour d'une fonction (et de
n'importe quelle commande en général), on peut utiliser la
variable spéciale `$?` qui contient toujours le code de
retour de la *dernière* commande exécutée.




