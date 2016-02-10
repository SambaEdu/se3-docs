#Le répertoire unefois/

* [Principe de base](#principe-de-base)
* [Détails du mécanisme](#le-mécanisme-en-détail)
* [La locale lors de l'exécution des scripts](#réglage-de-la-locale-durant-lexécution-des-scripts--unefois-)
* [Des variables et des fonctions](#des-variables-et-des-fonctions-prêtes-à-lemploi)


## Principe de base

Si vous souhaitez faire des interventions ponctuelles sur les clients GNU/Linux sans vous déplacer devant les postes, alors le répertoire `/home/netlogon/clients-linux/unefois/` du serveur Samba peut vous intéresser.

En effet, des fichiers exécutables placés dans ce répertoire seront susceptibles d'être lancés une seule fois sur les clients GNU/Linux lors du démarrage.

En pratique, vous allez créer un sous-répertoire à la racine du répertoire `unefois/` du serveur se3.

Exemples :

* Si le nom de ce sous-répertoire est `dell740`

Alors les exécutables se trouvant dans ce sous-répertoire seront lancés une fois au démarrage de tous les clients GNU/Linux dont le nom de machine **contient à la casse près** la chaîne de caractères `dell740`.

* Si le nom de ce sous-répertoire est `^S121-`

**Remarque :** oui, il s'agit bien d'un répertoire dont le nom commence par un accent circonflexe.

Alors les exécutables se trouvant dans ce sous-répertoire seront lancés une fois au démarrage de tous les clients GNU/Linux dont le nom de machine **commence, à la casse près**, par la chaîne de caractères `S121-`.

* Si le nom de ce sous-répertoire est `prof$`

Alors les exécutables se trouvant dans ce sous-répertoire seront lancés une fois au démarrage de tous les clients GNU/Linux dont le nom de machine **se termine à la casse près** par la chaîne de caractères `prof`.

* Si le nom de ce sous-répertoire est `^S121-HP-P$`

Alors les exécutables se trouvant dans ce sous-répertoire seront lancés une fois au démarrage du client GNU/Linux dont le nom de machine **est identique, à la casse près**, à la chaîne de caractères `S121-HP-P`.

Si jamais cela évoque quelque chose pour vous, sachez qu'en réalité le nom des sous-répertoires est interprété par le client GNU/Linux comme *une expression régulière étendue*.

Vous pouvez donc choisir comme nom de sous-répertoire n'importe quelle [expression régulière étendue](http://fr.wikipedia.org/wiki/Expression_rationnelle) pour filtrer les noms de machines qui sont censées exécuter une fois vos scripts ou vos fichiers binaires.

Voici un dernier exemple de nom de sous-répertoire possible (et donc d'expression régulière possible) : `^.` (le nom de ce sous-répertoire est constitué d'un accent circonflexe puis d'un point).

Cette expression régulière signifie : « n'importe quelle chaîne de caractères qui commence par un caractère quelconque ».

Autrement dit, les exécutables se trouvant dans ce sous-répertoire seront lancés une fois au démarrage de **tous les clients GNU/Linux sans exception**.

Bien sûr, le répertoire `unefois/` du serveur peut parfaitement contenir plusieurs sous-répertoires. Dans ce cas, si le nom de machine d'un client correspond par exemple avec trois noms de sous-répertoires `regex1/`, `regex2/` et `regex3/`, alors le client devra lancer une seule fois au démarrage tous les exécutables contenus dans chacun des sous-répertoires `regex1/`, `regex2/` et `regex3/`.

**Note :** Après avoir créé vos sous-répertoires et vos fichiers exécutables dans le répertoire `unefois/` du serveur, n'oubliez pas de réajuster les droits sur les fichiers comme expliqué à la section [TODO]

**Attention**, les fichiers exécutables d'un sous-répertoire donné doivent vérifier certains critères :
* Le nom d'un exécutable **ne doit pas commencer par un point**.
* Le nom d'un exécutable **doit se terminer par** `.unefois` (comme dans `mon-script.unefois`).
* Si le fichier exécutable est un script (autrement dit si ce n'est pas un fichier binaire), **il doit impérativement comporter un `shebang`** : cela peut-être un script `Bash`, `Perl`, `Python`, peu importe (du moment que l'interpréteur du langage est installé sur les clients GNU/Linux) mais il faut que le `shebang` soit présent.

**Note :** Le `shebang` est la première ligne d'un script qui commence par `#!` comme dans « `#! /bin/bash` » ou dans « `#! /usr/bin/python` »

**Le critère pour que les clients GNU/Linux se souviennent d'avoir exécuté un fichier donné (afin de l'exécuter une seule fois) est le nom de ce fichier** et rien que le nom (pas le contenu).

Par exemple, si un client GNU/Linux a exécuté le script `toto.unefois`, alors ce client n'exécutera plus jamais de fichier s'appellant `toto.unefois`.

**Note :** En fait, comme vous allez le voir juste après, cette règle n'est pas complètement immuable.

Si vous avez un script que vous souhaitez exécuter non pas une seule fois, mais quelques fois de manière très ponctuelle (une fois par an par exemple), pensez à insérer la date du jour dans le nom du script (comme dans `1sept2012-maj.unefois` ou dans `maj_20120901.unefois`) et le cas échéant, en modifiant la date dans le nom du fichier (par exemple en le renommant `3sept2013-maj.unefois` ou bien `maj_20120915.unefois`), celui-ci sera à nouveau candidat à l'exécution du côté des clients GNU/Linux.


## Le mécanisme en détail

Voici le mécanisme effectué par les clients GNU/Linux au niveau du répertoire `unefois/` **au moment du démarrage du système** uniquement (le démarrage est le seul instant où les clients GNU/-Linux se préoccupent du répertoire `unefois/`) :

1. Le client regarde le contenu de tous les sous-répertoires de `/mnt/netlogon/unefois/` 11 dont les noms correspondent à son nom de machine. Par exemple, si le client s'appelle `S18-DELL-03`, il va regarder le contenu du sous-répertoire `^S18-` mais il va ignorer le sous-répertoire `-HP-`. Dans chaque sous-répertoire qu'il n'a pas ignoré (s'il en existe), le client va y chercher tous les fichiers de la forme `*.unefois`, afin d'obtenir toute une liste (éventuellement vide) de fichier `*.unefois`.

    **Note :** Rappelons à nouveau que le répertoire `/mnt/netlogon/unefois/` sur les clients GNU/Linux correspond en réalité au répertoire `/home/netlogon/clients-linux/unefois/` du serveur Samba.

2. Si, dans cette liste de fichiers `*.unefois`, certains noms figurent déjà dans le répertoire local `/etc/se3/unefois/`, c'est que les fichiers en question ont déjà été exécutés par le client GNU/-Linux et ils ne le sont donc pas une deuxième fois. En revanche, les fichiers de cette liste dont le nom ne figure pas dans `/etc/se3/unefois/` sont copiés dans ce répertoire local puis les copies locales sont exécutées.

    **Note :** Les clients GNU/Linux ne tiennent compte que du nom des fichiers, pas de leur contenu. La casse dans le nom des fichiers est prise en compte.

C'est donc le répertoire `/etc/se3/unefois/` qui constitue la « mémoire » du client GNU/Linux : il contient la liste des noms de fichiers déjà exécutés. Il y a toutefois deux exceptions au mécanisme décrit ci-dessus :

1. Au moment du démarrage du système, si le client détecte la présence d'un fichier nommé `PAUSE` à la racine du répertoire `/mnt/netlogon/unefois/`, alors le client ne fait strictement rien au niveau des fichiers `*.unefois` et donc il n'exécute absolument rien, quoi qu'il arrive.

2. Au moment du démarrage du système, si le client ne repère pas la présence du fichier `PAUSE` précédent mais qu'en revanche il détecte la présence du fichier `BLACKOUT` , toujours à la racine du répertoire local `/mnt/netlogon/unefois/`, alors le client GNU/Linux efface le contenu du répertoire `/etc/se3/unefois/`. Ainsi, au prochain démarrage, si les fichiers `PAUSE` et `BLACKOUT` ne sont pas présents, le client exécutera tous les exécutables `*.unefois` qui le concerne, peu importe leur nom étant donné que la « mémoire » du client GNU/Linux concernant tout ce qui a déjà été exécuté a été effacée.

**Note :** Le nom du fichier `PAUSE` ou `BLACKOUT` doit être en majuscules uniquement et peu importe le contenu de ce fichier qui peut être totalement vide. Attention, les droits de ce fichier doivent être corrects une fois celui-ci créé.

**Important :** Au moment du démarrage, la recherche par les clients GNU/Linux des fichiers `*.unefois` à exécuter (ainsi que leur copie en local le cas échéant) entraîne(nt) forcément du trafic réseau. Lorsque vous ne souhaitez pas faire usage de ce mécanisme (ce qui en principe sera le cas 90% du temps), n'hésitez pas à placer le fichier `PAUSE` à la racine du répertoire `unefois/` du serveur afin d'éviter ce travail de recherche aux clients GNU/Linux qui solliciteraient inutilement le réseau. Là encore, lorsque vous créerez ce fichier `PAUSE`, attention de bien reconfigurer les droits des fichiers comme expliqué à section [TODO].

Les scripts `*.unefois` sont tous exécutés, en tant que `root`, en arrière-plan et cela dès l'affichage de la fenêtre de connexion lors du démarrage. Si vous souhaitez qu'un script `*.unefois` se lance un peu après (parce que, par exemple, vous avez besoin d'attendre que certains services soient lancés), vous pouvez parfaitement utiliser des instructions comme « `sleep 20` » afin de forcer le script à attendre pendant 20 secondes avant de commencer réellement son travail. Enfin sachez que dans le répertoire local `/etc/se3/unefois/`, chaque exécutable `truc.unefois` est accompagné de son homologue nommé `truc.unefois.log` qui contient simplement l'ensemble des messages (d'erreur ou non) du fichier l'exécutable.


## Réglage de la locale durant l'exécution des scripts « unefois »

Avant de déployer un script bash via le répertoire `unefois/` du serveur, il sera sans doute nécessaire de le tester sur un client localement.

Sachez que les scripts `bash`, lorsqu'ils sont exécutés par le client GNU/Linux au démarrage, ont la variable d'environnement `LC_ALL` définie comme étant égale à `C` et non pas égale à `fr_FR.utf8`.

Cela implique que tous les messages de sortie des commandes système lancées dans le script seront en anglais avec des caractères ASCII uniquement.

**Note :** Cette valeur règle le système, le temps de l'exécution des scripts, sur la locale standard `C` qui est la seule locale parfaitement normalisée et a priori disponible sur n'importe quel système de type `Unix`.

Pour avoir une idée de l'influence de la locale sur les commandes système, vous pouvez ouvrir un terminal `bash` et tester ceci :

```sh
# On paramètre le terminal sur une locale française qui doit être très
# probablement la locale par défaut déjà définie sur votre système.
export LC_ALL="fr_FR.utf8"
# Puis on teste une commande. En principe, l'entête du résultat de la
# commande est en français.
df -h

# Maintenant, on paramètre le terminal sur la locale C.
export LC_ALL="C"

# Et on teste à nouveau la même commande. Cette fois-ci, l'entête du
# résultat de la commande est en anglais.
df -h
```

Par conséquent, si jamais vous souhaitez exploiter le résultat de certaines commandes système dans vos scripts `bash` `*.unefois`, sachez que la locale peut avoir une incidence sur le comportement du script.

Si jamais vous tenez à avoir une locale française lors de l'exécution de votre script, alors il vous suffit de placer juste en dessous du `shebang` l'instruction :

```sh
export LC_ALL="fr_FR.utf8"
```

En revanche, si vous ne souhaitez pas forcer le réglage sur une locale particulière et préférez conserver la valeur par défaut (avec la locale standard `C`), alors durant vos tests afin de valider un script bash à déployer, il faudra le lancer de la manière suivante :

```sh
LC_ALL="C" ./monscript.bash.unefois
```

De cette manière, le script héritera de la locale `C` et il se comportera de la même manière que lors d'une exécution via le mécanisme « unefois ». Alors que si vous lancez le script ainsi :

```sh
./monscript.bash.unefois
```

celui-ci hériterait de la locale du système, qui est très probablement `fr_FR.utf8`, et il se comporterait légèrement différemment que lors d'une exécution via la mécanisme « unefois », si bien que vos tests seraient légèrement biaisés.


## Des variables et des fonctions prêtes à l'emploi

Si jamais vous utilisez le langage `Bash` pour écrire des script de la forme `*.unefois`, vous pouvez alors utiliser certaines variables ou fonctions prédéfinies qui pourront peut-être vous faciliter le travail d'écriture des scripts. [Voici la liste toutes ces variables et fonctions](variables_fonctions.md).

