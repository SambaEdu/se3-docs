# Documentation pour le (futur ?) contributeur/développeur


## Devenir contributeur/développeur du projet

Vous voulez devenir contributeur du projet ? Ou bien vous ne
vous sentez pas apte à modifier le code mais vous souhaitez
participer à l'élaboration de la documentation en ligne ?
Rien de plus simple, il suffit de suivre les deux étapes
suivantes :

1. Vous vous créez un compte [Github](https://github.com).
L'inscription se fait [à cette page](https://github.com/join).
Cela prend 5 minutes, c'est une inscription on ne peut plus
classique : on fournit un identifiant, un mot de passe et
une adresse email, on reçoit un mail de confirmation pour
activer son compte Github etc.

2. Faites savoir que vous voulez devenir membre du projet
`se3-clients-linux` en écrivant à l'adresse mail indiquée dans
[ce fichier](../../src/DEBIAN/control) (au niveau du champ
`Maintainer:`). Dans votre mail, indiquez bien le login de
votre compte Github afin que l'on sache le nom du compte qui
doit être intégré au projet. Nous vous répondrons par mail dès
que possible pour vous indiquer que vous êtes bien désormais
habilité(e) à contribuer au projet.


## Memo sur Git

Maintenant que vous avez bien procédé aux deux étapes
ci-dessus, vous êtes apte à contribuer au projet. Mais
comment contribuer en pratique ? Comme vous pouvez le
constater, le projet est géré par Git (un logiciel de «
gestion de code source », on dit aussi de « versionning de
code source »). Github, lui, n'est qu'un site web permettant
surtout de *visualiser* le projet (et de lui donner une
visibilité publique). Mais la *modification* du projet,
elle, se fait sur votre machine en local avec le logiciel
Git (donc on utilise Git pour gérer un projet sous Github,
jusqu'ici ça se tient). L'utilisation de Git pour des tâches
courantes (typiquement modifier/ajouter un fichier) est
beaucoup plus simple qu'il n'y paraît. Il existe de nombreux
tutoriels sur Git dans le Web. Nous vous proposons également
un [petit memo ici](memo-git.md) qui devrait vous permettre
de bien débuter.


## Comment construire le package `.deb` ?

Vous trouverez toutes les explications nécessaires à [cette page](build-package.md).


## Dépôt APT de test et branche Git

Il existe un dépôt Debian APT de test qui vous permet de
tester le paquet dans sa dernière version. Le dépôt est mis
à jour toutes les 5 minutes. Évidemment c'est pour du test,
aucune stabilité n'est garantie. Vous trouverez toutes les
explications nécessaires à [cette page](apt-repository.md).


## Envoyer une notification de ses commits sur la liste `gnu-linux_et_se3`

Vous trouverez toutes les explications nécessaires à [cette page](notification.md).


