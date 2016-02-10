# Envoyer une notification de ses commits sur la liste `gnu-linux_et_se3`

Si vous faites partie de la mailing liste `gnu-linux_et_se3`
et si vous souhaitez qu'une notification soit envoyée lors de chacun
de vos commits sur le dépôt (afin que les autres contributeurs
soient informés de vos modifications), alors vous devez vérifier
deux conditions (chacune étant indispensable pour que les
notifications fonctionnent).

1. Déjà, il faut modifier, au niveau de votre compte Github, votre
adresse email et mettre comme adresse email exactement la même
que celle que vous utilisez en tant que membre de la mailing
liste `gnu-linux_et_se3`. Il faut aller dans votre profil github
pour faire cette modification.

2. Mais ça ne suffit pas. Il faut vous rendre sur votre
ordinateur et vous placez à la racine du dépôt Git local. Ensuite,
vous éditez le fichier `.git/config`. Dans ce fichier vous
devez modifier le paramètre `email` au niveau de la section
`[user]` pour avoir ceci :

```ini
# Évidemment vous adaptez les valeurs à votre cas personnel.
[user]
    name = Prénom Nom
    email = votre-email-de-la-mailing-liste
```

Si la section `[user]` n'existe pas déjà dans le fichier, vous pouvez
simplement la rajouter. Si jamais il n'y a pas de fichier `.git/config`
à la racine de votre dépôt local, alors il doit très certainement
avoir un fichier `.gitconfig` à la racine de votre home (pas du dépôt)
et vous pouvez alors faire la modification ci-dessus sur ce fichier là.

Et voilà. Après ces deux paramétrages, normalement vos
commits, une fois pushés sur le dépôt distant, devraient
déclencher une notification sur la mailing liste. Évidemment,
si jamais vous avez plusieurs dépôt locaux sur plusieurs
machines, l'étape 2 est à faire sur chaque dépôt.


