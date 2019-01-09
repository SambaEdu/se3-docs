# Intégration de Jupyterhub à Se3

- Installation de **jupyterhub** : [doc en ligne](https://jupyterhub.readthedocs.io/en/stable/quickstart.html#start-the-hub-server) et le [configurer](https://jupyterhub.readthedocs.io/en/stable/getting-started/config-basics.html) 

- Installation de l'authenticator **jupyterhub-ldap-authenticator**  ([doc ici](https://github.com/hansohn/jupyterhub-ldap-authenticator))

- UPDATE : Le filtrage par groupe est maintenant compatible avec la version du LDAP de SE3. 

- Modifiez le fichier de configuration de Jupyterhub pour y ajouter les paramètres du **jupyterhub-ldap-authenticator** :

  ```yaml
  c.JupyterHub.authenticator_class = 'ldapauthenticator.LDAPAuthenticator'
  #Utilisateur administrateurs
  c.Authenticator.admin_users = {'papet', 'oberlen','vaillanc','royerg', 'aubryc'}
  c.LDAPAuthenticator.server_use_ssl = False
  #Adresse du serveur SE3
  c.LDAPAuthenticator.server_hosts = ['ldap://172.16.16.33:389']
  #Compte administrateur (à retrouver ici : http://ip_se3:909/setup)
  c.LDAPAuthenticator.bind_user_dn = "cn=admin,dc=9730235T,dc=ac-guyane,dc=fr"
  c.LDAPAuthenticator.bind_user_password = "motdepasse"
  c.LDAPAuthenticator.user_search_base = "dc=9730235T,dc=ac-guyane,dc=fr"
  c.LDAPAuthenticator.user_search_filter = "(&(objectClass=person)(uid={username}))"
  c.LDAPAuthenticator.allowed_groups = None 
  c.LDAPAuthenticator.user_membership_attribute = 'uid'
  c.LDAPAuthenticator.create_user_home_dir = True
  c.LDAPAuthenticator.create_user_home_dir_cmd = ["mkhomedir_helper"]
  
  ```

- Créez un **service système** pour jupyterhub : [doc ici](https://github.com/jupyterhub/jupyterhub/wiki/Run-jupyterhub-as-a-system-service)
- Créez un serveur **reverse proxy** pour protéger Jupytherhub : [doc là](https://jupyterhub.readthedocs.io/en/stable/reference/config-proxy.html). Je vous conseille nginx car Apache ne prend pas en compte la proxyfication des websockets (du moins pas sur la version conseillée par Debian)
- Dans votre réseau pédagogique, **assurez-vous** que l'accès au serveur Jupyterhub se fasse en direct et non pas via le proxy (problème de websocket)
