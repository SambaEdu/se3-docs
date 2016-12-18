# Configurations diverses pour l'utilisation de logiciels spécifiques


Dans ce qui suit, nous proposons quelques configurations pour l'utilisation d'applications spécifiques sur des stations de travail `Debian` ou `Ubuntu` dans un domaine `SambaÉdu` avec le paquet `se3-clients-linux`.

* [Arduino](#arduino)
    * [Ajout des utilisateurs `ldap` au groupe `dialout`](#ajout-des-utilisateurs-ldap-au-groupe-dialout)
    * [Ajout des bibliothèques nécessaires dans l'espace de travail de l'utilisateur](#ajout-des-bibliothèques-nécessaires-dans-lespace-de-travail-de-lutilisateur)
* [Cura](#cura)
* [Firefox](#firefox)


## Arduino

### Ajout des utilisateurs `ldap` au groupe `dialout`

L'utilisation de `Arduino` nécessite que l'utilisateur fasse partie du groupe `dialout`.

Créer un fichier de post_installation dans le dossier `unefois`. De quels fichier et dossier s'agit-il ? [TODO]

Ajouter le script suivant au fichier de post_installation. Un script de post_installation permet de réaliser plusieurs opérations après l'installation et « l'intégration » de la machine. Quand et où seront lancé ce script ? [TODO]

```sh
Ajout du groupe dialout
echo -e "${vert}Ajout de l'appartenance au groupe dialout"
echo -e "==========${neutre}"
echo "*;*;*;Al0000-2400;dialout" > /etc/security/group.conf
#
echo "Name: activate /etc/security/group.conf
Default: yes
Priority: 900
Auth-Type: Primary
Auth:   required                        pam_group.so use_first_pass" > /usr/share/pam-configs/my_groups
#
LIGNE=`grep -n 'success=2' /etc/pam.d/common-auth | cut -d: -f1`
EXISTE=`grep "pam_group.so" /etc/pam.d/common-auth`
if [ -z "$EXISTE" ]; then
    sed -i "${LIGNE}i auth    required                        pam_group.so use_first" /etc/pam.d/common-auth
fi
```

### Ajout des bibliothèques nécessaires dans l'espace de travail de l'utilisateur

Pour fonctionner avec certains matériels, et avec `Ardublock`, il est nécessaire de copier un certain nombre de dossiers dans l'espace de travail de l'utilisateur. Cette fonction est à adapter en fonction des besoins et à mettre dans le logon_perso et à appeler depuis la fonction ouverture_session.

Où faut-il copier/utiliser cette fonction ? Dans le logon_perso ? [TODO]

```sh
gerer_arduino ()
{
   % On teste si un dossier Technologie existe dans les documents de
   % l'utilisateur connecté. S'il n'existe pas on le créé
   Tech=`ls $REP_HOME/Documents | grep Technologie`
   if [ -z "$Tech" ]; then
      mkdir $REP_HOME/Documents/Technologie
      chown -R "$LOGIN:" "$REP_HOME/Documents/Technologie"
      chmod -R 744 "$REP_HOME/Documents/Technologie"
   fi

   % On teste si un dossier Arduino existe dans les documents de
   % l'utilisateur connecté. S'il n'existe pas on le créé en téléchargant
   % une archive créée préalablement et qui contient toutes les
   % bibliothèques nécessaires. Cette archive sera simplement déposée
   % dans un dossier du serveur web de Se3
   Ard=`ls $REP_HOME/Documents/Technologie | grep Arduino`
   if [ -z "$Ard" ]; then
      ici=`pwd`
      cd /root
      wget http://$SE3/install_paquets/Arduino.tar.bz2
      tar -xjf Arduino.tar.bz2
      cp -r /root/Arduino "$REP_HOME/Documents/Technologie/"
      chown -R "$LOGIN:" "$REP_HOME/Documents/Technologie/Arduino"
      chmod -R 744 "$REP_HOME/Documents/Technologie/Arduino"
      rm -r Arduino*
      cd $ici
   fi

   % Création du fichier de préférences
   % Plusieurs éléments sont importants :
   %  -     board=                     le type de carte
   %  -     serial.port=/dev/ttyACM0   le port série
   %  - sketchbook.path=/mnt/_$USER/Docs/Technologie/Arduino
   % le chemin d'accèr aux bibliothèques. Ici, cela correspond à la présence
   % de dossiers « Technologie » et « Arduino »

   mkdir $REP_HOME/.arduino
   cat > "$REP_HOME/.arduino/preferences.txt" <<FIN
    board=uno
    browser=mozilla
    browser.linux=mozilla
    build.verbose=false
    console=true
    console.auto_clear=true
    console.error.file=stderr.txt
    console.length=500
    console.lines=4
    console.output.file=stdout.txt
    default.window.height=600
    default.window.width=500
    editor.antialias=false
    editor.caret.blink=true
    editor.divider.size=0
    editor.divider.size.windows=2
    editor.external=false
    editor.font=Monospaced,plain,12
    editor.font.macosx=Monaco,plain,10
    editor.indent=true
    editor.invalid=false
    editor.keys.alternative_cut_copy_paste=true
    editor.keys.alternative_cut_copy_paste.macosx=false
    editor.keys.home_and_end_travel_far=false
    editor.keys.home_and_end_travel_far.macosx=true
    editor.keys.shift_backspace_is_delete=true
    editor.languages.current=
    editor.tabs.expand=true
    editor.tabs.size=2
    editor.update_extension=true
    editor.window.height.default=600
    editor.window.height.min=500
    editor.window.height.min.macosx=450
    editor.window.height.min.windows=530
    editor.window.width.default=500
        editor.window.width.min=400
    export.applet.separate_jar_files=false
    export.application.fullscreen=false
    export.application.platform=true
    export.application.platform.linux=true
    export.application.platform.macosx=true
    export.application.platform.windows=true
    export.application.stop=true
    export.delete_target_folder=true
    last.screen.height=768
    last.screen.width=1366
    last.serial.location=673,463,593,305
    last.sketch.count=0
    last.sketch0.location=362,82,500,600,415
    last.sketch0.path=
    last.sketch1.location=
    last.sketch1.path=
    launcher=gnome-open
    platform.auto_file_type_associations=true
    preproc.color_datatype=true
    preproc.enhanced_casting=true
    preproc.imports=java.applet,java.awt,java.awt.image,java.awt.event,java.io,java.net,java.text,java.util,java.util.zip,java.util.regex
preproc.imports.list=java.applet.*,java.awt.Dimension,java.awt.Frame,java.awt.event.MouseEvent,java.awt.event.KeyEvent,java.awt.event.FocusEvent,java.awt.Image,java.io.*,java.net.*,java.text.*,java.util.*,java.util.zip.*,java.util.regex.*
    preproc.output_parse_tree=false
    preproc.save_build_files=false
    preproc.substitute_floats=true
    preproc.substitute_unicode=true
    preproc.web_colors=true
    programmer=arduino:avrispmkii
    run.display=1
    run.options=
    run.options.memory=false
    run.options.memory.initial=64
    run.options.memory.maximum=256
    run.present.bgcolor=#666666
    run.present.exclusive=false
    run.present.exclusive.macosx=true
    run.present.stop.color=#cccccc
    run.window.bgcolor=#DFDFDF
    serial.databits=8
    serial.debug_rate=19200
    serial.parity=N
    serial.port=/dev/ttyACM0
    run.display=1
    run.options=
    run.options.memory=false
    run.options.memory.initial=64
    run.options.memory.maximum=256
    run.present.bgcolor=#666666
    run.present.exclusive=false
    run.present.exclusive.macosx=true
    run.present.stop.color=#cccccc
    run.window.bgcolor=#DFDFDF
    serial.databits=8
    serial.debug_rate=19200
    serial.parity=N
    serial.port=/dev/ttyACM0
    serial.stopbits=1
    sketchbook.path=/mnt/_$USER/Docs/Technologie/Arduino
    target=arduino
    update.check=true
    update.id=-6812486319402770990
    update.last=1419357719724
    upload.using=bootloader
    upload.verbose=false
    upload.verify=true
FIN
    % On positionne correctement les droits
    chown -R "$LOGIN:" "$REP_HOME/.arduino"
    chmod -R 744 "$REP_HOME/.arduino"

}

```


## Cura

…en préparation ?…


## Firefox

…en préparation ?…



