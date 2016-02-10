# Construire le package

Une fois que vous avez cloné ce dépôt, pour construire le
package, il suffit de lancer le script `./build/build.sh`
où que vous soyez. Typiquement, si vous vous trouvez à la
racine de ce dépôt git, il vous suffit de lancer la commande :

```sh
./build/build.sh
```

Le package `.deb` se trouvera dans le réportoire `./build/`
du dépôt. Vous pourrez le visualiser avec :

```sh
# Toujours en supposant que vous vous trouvez à la racine du dépôt.
ls -l ./build
```

Si vous relancez une nouvelle fois la construction du package,
« l'ancien » fichier `.deb` sera tout simplement écrasé et
remplacé par sa nouvelle version.


