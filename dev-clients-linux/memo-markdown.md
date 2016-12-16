# Memo sur le formatage markdown (fichiers `.md`)

Vous trouverez ci-dessous quelques indications sur le formatage `markdown` qui est utilisé pour écrire la documentation du projet.

* [Présentation](#présentation)
* [Mise en forme de base](#mise-en-forme-de-base)
* [Les liens vers une page markdown avec une ancre](#les-liens-vers-une-page-markdown-avec-une-ancre)
* [Insérer du code](#insérer-du-code)
* [Insérer une image](#insérer-une-image)

## Présentation

Le site Github est capable d'interpréter correctement des
fichiers de type `markdown` (ie des fichiers avec l'extension
`.md` comme celui que vous êtes en train de lire
présentement) ce qui permet d'écrire des documentations
assez facilement (via une syntaxe très simple) tout en ayant
un rendu vraiment convenable.

En fait, tout est parfaitement résumé
[ici](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)
mais voici quelques syntaxes fondamentales ci-dessous.


## Mise en forme de base

* Pour faire un titre : `# Titre` (en début de ligne).
* Pour faire un sous-titre : `## Sous titre` (en début de ligne).
* Pour faire un sous-sous-titre : `### Sous sous titre` (en début de ligne).
* Pour mettre en gras  : `**du gras**`.
* Pour faire une liste à puce : `* Premièrement...`.
* Pour faire un lien : `Consultez [cette page](<url relative ou absolue>)`,
si la cible du lien est un fichier interne au dépôt, il faut
toujours privilégier une url relative.


## Les liens vers une page markdown avec une ancre

Concernant les liens vers des pages markdown, il peut être
pratique parfois de créer un lien vers un titre en
particulier d'une page markdown (notamment si la page est
longue, afin d'avoir le lien le plus précis possible). Pour
ce faire, allez sur la page en question avec votre
navigateur Web et faites survoler le curseur de la souris au
niveau du titre sur lequel vous voulez faire un lien. Vous
verrez apparaître une ancre sur le côté gauche du titre. Si
vous cliquez dessus (via un simple clic gauche), vous aurez
alors dans la barre d'adresses de votre navigateur l'url
complet correspondant au titre. Toute la partie de l'url
située *après* le caractère `#` correspond à l'identifiant
de l'ancre. Grâce à cet identifiant, vous pouvez créer un
lien non seulement vers la page mais précisément vers un
titre en particulier de la page. Voici deux exemples :

* Avec le code `un résumé se trouve [ici](../README.md#résumé-et-avertissement).`,
vous obtenez « un résumé se trouve [ici](../README.md#résumé-et-avertissement). »

* Le lien peut parfaitement pointer vers le titre de la
page sur laquelle vous vous trouvez déjà. Par exemple avec
le code `pour l'installation de Git, voir [ici](#installation).`,
vous obtenez « pour l'installation de Git, voir [ici](#installation). »
Comme vous pouvez voir, dans ce cas particulier de lien
relatif, seul l'identifiant de l'ancre est indiqué (avec le
caractère `#` inclus).


## Insérer du code

Pour insérer du code sur une ligne de texte ou dans un bloc,
tout est expliqué
[ici](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet#code-and-syntax-highlighting).
Voici tout de même deux exemples simples. D'abord un
exemple de code dans le texte :

```
Mettez à jour via la commande `apt-get update && apt-get dist-upgrade`...
```

ce qui donnera :

* * *
Mettez à jour via la commande `apt-get update && apt-get dist-upgrade`...
* * *

Enfin voici un exemple dans le cas d'un code shell
dans un bloc :

<pre>
Afin de chercher les fichiers `.sh`, lancez la commande :

```sh
# Un petit commentaire...
find /dir -type f -name '*.sh'
```

Blabla blabla...
</pre>

ce qui donnera ceci :

* * *
Afin de chercher les fichiers `.sh` lancez la commande :

```sh
# Un petit commentaire...
find /dir -type f -name '*.sh'
```

Blabla blabla...
* * *

Le `sh` juste après les 3 backquotes est optionnel mais il
permet d'avoir une coloration syntaxique du code adaptée au
langage (le langage shell ici) ce qui rend les extraits de
codes nettement plus jolis.

## Insérer une image

Pour insérer une image, on pourra utiliser cette syntaxe
ci-dessous, qui n'est rien d'autre que la syntaxe utilisée
pour un lien mais précédée du caractère `!` :

```
Blabla blabla Blabla blabla Blabla blabla Blabla blabla
Blabla blabla Blabla blabla Blabla blabla Blabla blabla

![Texte alternatif](images/bidul.png)

Blabla blabla Blabla blabla Blabla blabla Blabla blabla
Blabla blabla Blabla blabla Blabla blabla Blabla blabla
```

En revanche, avec le code ci-dessus :

* l'image est forcément alignée sur la marge de gauche
* et on ne peut pas redéfinir la taille de l'image.


**Remarque :** si jamais vous souhaitez centrer votre image
et aussi redéfinir sa taille, alors il faudra écrire un bout
de code html au sein du fichier markdown comme ceci :

```
Blabla blabla Blabla blabla Blabla blabla Blabla blabla
Blabla blabla Blabla blabla Blabla blabla Blabla blabla

<p align="center">
  <img src="images/bidul.png" width="50%" alt="Texte alternatif" title="Info lors du survol">
</p>

Blabla blabla Blabla blabla Blabla blabla Blabla blabla
Blabla blabla Blabla blabla Blabla blabla Blabla blabla
```

Dans l'exemple ci-dessus :

* `src="images/bidul.png"` correspond au chemin relatif du
fichier image par rapport au fichier markdown qu'on est en
train d'éditer.
* Pour être respectueux de la norme html, il faut bien mettre
les attributs d'une balise sous la forme `name="value"` comme
dans `width="50%"` avec la valeur entre doubles quotes.
* Dans la balise `img`, l'attribut `alt` est obligatoire (en
fait ça marchera sans mais dans ce cas on ne respecte plus la
norme html). Il s'agit d'un texte affiché à la place de l'image
si celle-ci n'est pas trouvée par le serveur.
* L'attribut `title` définit du texte (court) qui sera affiché
lors du survol de la souris au niveau de l'image. Cet attribut
est complètement optionnel.
* L'attribut `width="50%"` permet de redimensionner la taille
de l'image. Dans le cas présent, l'image occupera la moitié
(ie 50%) de la largeur du texte des paragraphes (éviter de
préciser des tailles d'images en pixels `px`, un pourcentage
par rapport à la largeur du texte est un bien meilleur choix).


