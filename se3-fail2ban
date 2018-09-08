# se3 et fail2ban
* [Présentation de fail2ban](#présentation-de-fail2ban)
* [Installation de fail2ban sur le se3](#installation-de-fail2ban-sur-le-se3)
* [Configuration de fail2ban](#configuration-de-fail2ban)
* [Etat de fail2ban](#etat-de-fail2ban)

## Présentation de fail2ban
Fail2ban est un paquet debian qui examine des fichiers de logs choisis pour déterminer si plusieurs erreurs de connexion se sont produites.
Si on une ip fait 3 erreurs de connexion consécutives, alors l'ip est bannie provisoirement, et la connexion n'est plus possible.


Dans le cas du se3, **l'interface web ne sera plus disponible pour l'ip concernée** pendant la durée choisie. On empêchera donc ainsi une attaque par force brute. **La protection du protocole ssh est aussi installée automatiquement.

On pourra aussi configurer `fail2ban` pour que le serveur envoie un mail à l'administrateur lui indiquant les morceaux de logs concernés.

## Installation de fail2ban sur le se3
```
cd /usr/share/se3/scripts/
wget https://raw.githubusercontent.com/SambaEdu/se3master/master/usr/share/se3/scripts/installation_fail2ban.sh
chmod u+x /usr/share/se3/scripts/installation_fail2ban.sh
./installation_fail2ban.sh
```

## Configuration de fail2ban
On va modifier le fichier de configuration pour régler fail2ban selon ses envies.
```
nano /etc/fail2ban/jail.conf
```

**Envoi de mail** On remplacera la variable `"root@localhost"` par l'adresse mail de l'administrateur dans la partie `destmail`

**Durée de ban** : On indiquera en seconde la durée d'indisponibilité dans la variable `bantime`.Par défaut cette durée est de 600 s.

**Nombre d'essais provoquant un ban** :On indiquera aussi le nombre d'erreurs provoquant un ban de l'ip avec la variable `maxretry`. Par défaut cette valeur est de 3.

**action en cas de ban** : On remplacera à la ligne  75 `action = %(action_)s` par `action = %(action_mwl)s`. Ainsi, l'admin va recevoir un mail avec le log concerné dans le message.

## Etat de fail2ban
On pourra surveiller les protocoles de surveillance de fail2ban en faisant:

```fail2ban-client status```

On aura une réponse de ce type:

```
 fail2ban-client status
Status
|- Number of jail:      2
`- Jail list:           interface-se3, ssh
```
On pourra voir précisément l'état de la surveillance de l'interface.
```fail2ban-client status interface-se3```

```
Status for the jail: interface-se3
|- filter
|  |- File list:        /var/log/se3/auth.log
|  |- Currently failed: 0
|  `- Total failed:     3
`- action
   |- Currently banned: 1
   |  `- IP list:       172.20.10.1
   `- Total banned:     1
```
Ici, on voit qu'un ip est actuellement bannie.


