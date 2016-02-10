# Utiliser une branche git puis tester le package

Vous pouvez créer une branche git afin de tester des modifications.
Un package sera automatiquement créé afin que vous puissiez tester
vos changements, sans que cela impacte la branche `master` ie la
branche git par défaut.

Voici un exemple. On suppose que vous vous trouvez dans un répertoire
local de votre dépôt git. Déjà, vous mettez à jour votre dépôt :

```sh
git pull
```

Ensuite, vous allez créer localement une nouvelle branche. Pour
le nom de cette nouvelle branche, utilisez uniquement les caractères
`abc...z01...9` ainsi que le tiret (`-`), c'est tout.

```sh
git branch my-new-feature      # La branche `my-new-feature` est créée en local.
git checkout my-new-feature    # On bascule dans la nouvelle branche en local.
git push origin my-new-feature # On crée la nouvelle branche sur le dépôt distant aussi (ie sur Github)
```

À ce stade une nouvelle branche a été créée sur votre dépôt local
et sur le dépôt distant (ie GitHub). Attention, maintenant il faudra
bien commiter sur la nouvelle branche. N'hésitez pas à lancer les
commandes suivantes pour vous assurer que vous vous trouvez bien sur
la bonne branche :

```sh
git branch # la branche sur laquelle on se trouve actuellement est précédée d'un `*`

# Si jamais vous n'êtes pas sur la branche my-new-feature, vous pouvez
# y basculer via cette commande.
git checkout my-new-feature
```

Ensuite, une fois que vous êtes sur la bonne branche, vous pouvez
modifier les fichiers, commiter, pusher etc. comme vous le souhaitez.
Si jamais vous avez pushé un commit sur la nouvelle branche, le
package sera buildé sur le serveur `repository.flaf.fr`.

Par exemple, imaginons que vous venez de pusher un commit d'id
`656c693a71...` (pour voir l'id de son dernier commit, faire `git log`
et `q` pour sortir). **Si vous attendez 5 minutes**, la nouvelle version
de votre package sera disponible. Il suffit pour cela d'ajouter
la ligne suivante dans le `sources.list` de votre serveur Se3 de test :

```sh
# La syntaxe est toujours de la forme :
#
#   deb deb http://repository.flaf.fr se3-clients-linux <le-nom-de-ma-branche-git>
#
deb http://repository.flaf.fr se3-clients-linux my-new-feature
```

Il faudra aussi ajouter la clé publique gpg utilisée par le dépôt
pour signer les paquets :

```sh
# Ceci, tout comme la modification du sources.list, ne sera à faire qu'une
# seule fois sur votre serveur Se3 de test.
wget http://repository.flaf.fr/pub-key.gpg -O - | apt-key add -
```

Ensuite, pour installer ou mettre à jour le paquet dans sa
toute nouvelle version (celle correspondant à votre dernier commit) :

```sh
# Remplacer 0.$epoch~$commit_id par la version à installer.
apt-get update && apt-get install se3-clients-linux=0.$epoch~$commit_id
```

Penser à vérifier que le paquet installé sur votre serveur de test
correspond bien à la version de votre dernier commit :

```sh
dpkg-query -W se3-clients-linux
```

La version du paquet sera toujours de la forme `0.<epoch>~<commit-id>`
sachant que :

* `<epoch>` est simplement le nombre de secondes écoulées
entre le 1 janvier 1970 à minuit (UTC) et l'instant où le build
du package a été effectué;
* `<commit-id>` est l'id du commit sur lequel se trouvait le dépôt
git du serveur repository au moment du build du package (l'id est
tronqué aux 10 premiers caractères). Le serveur repository possède
son propre dépôt git de `se3-clients-linux` qu'il met à jour
juste avant chaque build afin de récupérer les commits qui ont été
pushés par les membres du projet.

Il est facile de convertir la date `epoch` en une date au format
classique :

```sh
# Par exemple l'epoch 1433160890 correspond au 1 juin 2015 à 14h14,
# ce qui veut donc dire qu'un package dont l'epoch dans le numéro
# version correspond à 1433160890 est un package qui a été buildé
# le 1 juin 2015 à 14h14 (et 50 secondes).
~$ date -d "@1433160890"
lundi 1 juin 2015, 14:14:50 (UTC+0200)
```

Soyez patient entre le moment où vous avez commité et pushé
une nouvelle modification sur votre branche et le moment où
le package dans sa nouvelle version sera disponible sur le
serveur repository. Il faut patienter au moins 5 minutes, tout
simplement parce qu'il y a une tâche cron qui tourne toutes les
5 minutes sur le serveur repository. Donc, si vous avez commité
puis pushé une modification sur votre branche à 14h46, il faudra
attendre 14h50 (et quelques secondes) avant que votre package
soit disponible dans sa dernière version. Vous pourrez voir la
version du package disponible en visitant la page (`F5` pour
la rafraîchir) :

```sh
branch='my-new-feature' # Mettre ici le nom de votre nouvelle branche.
http://repository.flaf.fr/dists/se3-clients-linux/${branch}/binary-amd64/Packages
```

Après vos tests, si vous êtes satisfait, alors vous pouvez merger
sur la branche `master` comme ceci :

```sh
# On bascule dans la branche master.
git checkout master

# On merge, ie on fusionne nos changements sur la branche master.
git merge my-new-feature

# Pour voir s'il y a des fichiers « unmerged », ie des conflits
# que git ne peut pas résoudre lui-même automatiquement.
git status

# Si le merge n'a rencontré aucun conflit, on peut alors pusher.
# Sinon, voir les quelques commentaires ci-dessous.
git push
```

Si on a de la chance, un merge peut se passer sans problème.
Mais si par exemple il y a eu des modifications sur la branche
`master` (pendant que nous, on avançait sur la branche `my-new-feature`)
et si certaines de ces modifications rentrent en conflit avec
nos modifications alors il y a des étapes supplémentaires pour
aider git à achever le merge (c'est une situation assez courante qui
n'a rien d'anormale lors d'un merge). Si
jamais il y a des conflits non résolus, on peut le voir avec la
commande `git status` : si certains fichiers sont marqués `unmerged`,
cela veut dire que des conflits demeurent au niveau de ces fichiers
et qu'il faudra les éditer à la main. Je ne détaille cela (désolé),
voir sur le Web qui regorge de tutoriels sur le merge avec git.


Une fois que le merge c'est bien passé, ou bien si vous décidez
d'abandonner votre branche (parce que votre idée de départ était
une mauvaise idée etc.), il faut détruire la branche en local
et sur le site distant (GitHub) :

```sh
# On détruit la branche en local, attention on perd toute la branche.
git branch -D my-new-feature

# On détruit la branche sur Github. Le « : » est important.
git push origin :my-new-feature
```


