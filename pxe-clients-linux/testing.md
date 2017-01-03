# Installer et tester en toute sécurité la version du paquet issue de la branche `se3testing`

Installer la version du paquet `pxe-clients-linux`
issue de la branche `se3testing` sur votre serveur en toute sécurité est possible,
en évitant de mettre à jour d'autres paquets issus de cette branche.

Il est à noter que, pour l'instant,
le paquet `pxe-client-linux` est une composante
du paquet `se3-clonage` : c'est donc ce paquet que l'on va mettre à jour.

La méthode est la même que [celle décrite pour le paquet `se3-clients-linux`](../dev-clients-linux/upgrade-via-se3testing.md#installer-et-tester-en-toute-sécurité-la-version-dun-paquet-issue-de-la-branche-se3testing).
Il suffira de remplacer le paramètre **se3-clients-linux** par le paramètre **se3-clonage**.

**Remarque :** on peut mettre à jour les deux paquets en rajoutant le paramètre **se3-clonage** au paramètre **se3-clients-linux** (une espace sérarera ces deux paramètres).
Vous bénéficierez ainsi des paquets `se3-clients-linux` et `se3-clonage`
dans leurs versions disponibles dans la branche `se3testing`.

Reprenez ensuite les opérations de [mise en place du mécanisme](misenplace.md#mise-à-jour).

