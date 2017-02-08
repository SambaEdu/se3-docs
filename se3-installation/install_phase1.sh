#!/bin/bash
# installation se3 phase 1
# michel suquet février 2017
# 
# version pour wheezy
#
# Ce script permet d'obtenir une archive iso d'installation d'un se3
# Cette archive contiendra les fichiers se3.preseed et setup_se3.data
# ainsi que les fichiers nécessaires à la phase 2 et à la phase 3.
#
# L'archive iso obtenue pourra être gravée indifféremment sur un CD ou sur une clé usb
#
# Ce script sera lancé dans un répertoire contenant les fichiers se3.preseed et setup_se3.data
#
# Paramétres :  -m  → utilisation d'une mini.iso mais sans incorporation des firmwares
#               -mf → utilisation d'une mini.iso et incorporation des firmwares
#               -n  → utilisation d'une nestinst.iso mais sans incorporation des firmwares
#               -nf → utilisation d'une nestinst.iso avec incorporation des firmwares
#               -i  → utilisation d'une iso fournie
#                     nom de l'iso en complément du paramétre
#               -h  → aide
#

####
# Les variables
#
version="wheezy"
#
# url pour récupérer l'archive se3scripts.tar.gz
url_se3scripts="github.com/SambaEdu/se3-docs/raw/master/se3-installation"
#
# url pour récupérer l'installateur mini.iso
url_mini_iso="ftp.fr.debian.org/debian/dists/${version}/main/installer-amd64/current/images/netboot"
url_mdsums_iso="ftp.fr.debian.org/debian/dists/${version}/main/installer-amd64/current/images"
nom_mini_iso="mini.iso"
#
# url pour récupérer l'installateur netinst.iso
url_netinst_iso="cdimage.debian.org/cdimage/archive/7.11.0/amd64/iso-cd"
nom_netinst_iso="debian-7.11.0-amd64-netinst.iso"
#
url_netinst_firmware_iso="cdimage.debian.org/cdimage/unofficial/non-free/cd-including-firmware/archive/7.11.0+nonfree/amd64/iso-cd"
nom_firmware_netinst_iso="firmware-7.11.0-amd64-netinst.iso"
#
# url pour récupérer le fichier firmware.cpio.gz
url_firmware="cdimage.debian.org/cdimage/unofficial/non-free/firmware/${version}/current"

####
# variable de sortie pour ne pas encombrer l'affichage
# >$sortie 2>&1
# 
sortie="/dev/null"

#=====
# Les fonctions
#=====

mode_texte()
{
    echo "Utilisation : $0 -paramétre"
    echo "paramètres possibles :"
    echo "   -h     : afficher cet aide-mémoire"
    echo "   -m     : utiliser une mini.iso, sans firmwares non-free"
    echo "   -mf    : utiliser une mini.iso et incorporer les firmwares"
    echo "   -n     : utiliser une netinst.iso, sans firmwares non-free"
    echo "   -nf    : utiliser une netinst.iso avec firmwares non-free"
    echo "   -i nom : utiliser une archive iso nommée nom"
    echo ""
}

gestion_parametres()
{
    # message début
    echo "----- ----- -----"
    echo "Personnalisation d'une archive d'installation se3/${version}"
    echo "----- ----- -----"
    # on récupère le paramétre (avec un complément si c'est -i)
    if [ ! "${#}" = "0" ]
    then
        case "${1}" in
            -h)
                # on affiche l'aide
                mode_texte
                exit 0
            ;;
            -m)
                # on utilise une mini.iso sans les firmwares
                mode_iso="mini"
                url_iso="${url_mini_iso}"
                url_mdsums="${url_mdsums_iso}"
                nom_archive_iso="${nom_mini_iso}"
                mode_firmware="nofirmware"
                echo "utilisation d'une mini.iso sans firmwares"
                echo ""
            ;;
            -mf)
                # on utilise une mini.iso en incorporant les firmwares
                mode_iso="mini"
                url_iso="${url_mini_iso}"
                url_mdsums="${url_mdsums_iso}"
                nom_archive_iso="${nom_mini_iso}"
                mode_firmware="firmware"
                echo "utilisation d'une mini.iso et incorporation des firmwares"
                echo ""
            ;;
            -n)
                # on utilise une netinst.iso sans les firmwares
                mode_iso="netinst"
                url_iso="${url_netinst_iso}"
                url_mdsums="${url_netinst_iso}"
                nom_archive_iso="${nom_netinst_iso}"
                mode_firmware="nofirmware"
                echo "utilisation d'une netinst.iso sans les firmwares"
                echo ""
            ;;
            -nf)
                # on utilise une netinst.iso comprenant les firmwares
                mode_iso="netinst"
                url_iso="${url_netinst_firmware_iso}"
                url_mdsums="${url_netinst_firmware_iso}"
                nom_archive_iso="${nom_firmware_netinst_iso}"
                mode_firmware="nofirmware"   # les firmwares sont déjà dans l'archive
                echo "utilisation d'une netinst.iso comprenant les firmwares"
                echo ""
            ;;
            -i)
                # l'archive iso est fournie avec le script
                # vérifier qu'il y a un complément
                if [ "${#}" = "1" ]
                then
                    # il manque le complément au paramétre -i
                    echo "vous avez utilisé la commande : $0 $@"
                    echo "le paramétre -i doit avoir comme complément le nom de l'archive iso à utiliser"
                    echo "#####"
                    mode_texte
                    exit 2
                fi
                # il faudra analyser l'archive pour déterminer son arborescence
                # 2 types : mini ou netinst ?
                mode_iso="autre"
                nom_archive_iso="$2"
                mode_firmware="nofirmware"
                #
                # on vérifie la présence de l'éventuelle archive iso fournie
                test_nom=$(ls | grep -x ${nom_archive_iso})
                if [ -z "${test_nom}" ]
                then
                    # l'archive iso n'est pas présente
                    echo "vous avez utilisé la commande : $0 $@"
                    echo "veuillez placer l'archive ${nom_archive_iso}"
                    echo "dans le répertoire où se trouve le script $0"
                    echo ""
                    exit 4
                fi
                echo "utilisation de l'archive $2 fournie"
                echo ""
                
            ;;
            *)
                # paramétre non prévu
                echo "vous avez utilisé la commande : $0 $@"
                echo "paramètre $1 incorrect"
                echo "#####"
                # on affiche l'aide
                mode_texte
                exit 2
            ;;
        esac
    else
        # présence d'un paramétre obligatoire
        echo "vous avez utilisé la commande : $0 $@"
        echo "cette commande doit comporter un paramétre"
        echo "#####"
        # on affiche l'aide
        mode_texte
        exit 2
    fi
}

verification_initiale()
{
    # on vérifie la présence des fichiers se3.preseed et setup_se3
    test_preseed=$(ls | grep -x se3.preseed)
    if [ -z "${test_preseed}" ]
    then
        echo "le fichier se3.preseed est absent…"
    fi
    test_setup=$(ls | grep -x setup_se3.data)
    if [ -z "${test_setup}" ]
    then
        echo "le fichier setup_se3.data est absent…"
    fi
    if [ -z "${test_preseed}" -o -z "${test_setup}" ]
    then
        echo "veuillez placer les fichiers se3.preseed et setup_se3.data dans le répertoire où se trouve le script $0"
        echo ""
        exit 3
    fi
    #
    # on supprime les traces éventuelles des répertoires de travail…
    [ -d se3scripts/ ] && rm -rf se3scripts/
    [ -f se3scripts.tar.gz ] && rm -f se3scripts.tar.gz
    [ -d isoorig/ ] && rm -rf isoorig/
    [ -d isonew/ ] && rm -rf isonew/
    [ -f se3.preseed.orig ] && [ -f se3.preseed ] && rm -f se3.preseed
    [ -f se3.preseed.orig ] && cp se3.preseed.orig se3.preseed && rm -f se3.preseed.orig
}

modifier_preseed()
{
    # on modifie le fichier se3.preseed
    # on en fait une copie pour conserver l'original
    echo "modification du se3.preseed"
    cp se3.preseed se3.preseed.orig
    #
    # remplacement des lignes de commandes
    cat > texte << END
# MODIFICATION, Preseed commands
# mise en place de l'autologin et des fichiers pour la phase 3
# ----------------
d-i preseed/early_command string cp se3scripts/* ./; \\
    chmod +x se3-early-command.sh se3-post-base-installer.sh install_phase2.sh; \\
    ./se3-early-command.sh se3-post-base-installer.sh

# Finishing behaviour
END
    # remplacement entre 2 lignes
    #sed -i '162,173 {:z;N;173! bz; s/^.*$/cat texte/e}' se3.preseed
    # remplacement entre 2 motifs (c'est mieux, non ?)
    sed -i '/# Preseed commands/,/# Finishing behaviour/ {:z;N;/# Finishing behaviour/! bz; s/^.*$/cat texte/e}' se3.preseed
    #
    # ajouter la réponse pour les stats
    cat > texte << END
d-i debian-installer/allow_unauthenticated boolean true

# AJOUT, pour éviter de répondre à la question
# Some versions of the installer can report back on what software you have
# installed, and what software you use. The default is not to report back,
# but sending reports helps the project determine what software is most
# popular and include it on CDs.
# ----------------
popularity-contest popularity-contest/participate boolean false

# Passwd super user
END
    #sed -i '147,148 {:z;N;148! bz; s/^.*$/cat texte/e}' se3.preseed
    sed -i '/d-i debian-installer\/allow_unauthenticated boolean true/,/# Passwd super user/ {:z;N;/# Passwd super user/! bz; s/^.*$/cat texte/e}' se3.preseed
    #
    # correction du mot bolean en boolean
    sed -i "s|bolean|boolean|g" se3.preseed
    #
    # ajouter les dépôts
    cat > texte << END
 ldapedu-server ldapedu-server/adminpassverif string se3chief

# AJOUT, pour indiquer le miroir et éventuellement le proxy pour atteindre le miroir
# Mirror settings
# ----------------
d-i mirror/country string manual
d-i mirror/http/hostname string httpredir.debian.org
d-i mirror/http/directory string /debian
d-i mirror/suite string wheezy
d-i mirror/http/proxy string

# Standart drive controler
END
    #sed -i '65,66 {:z;N;66! bz; s/^.*$/cat texte/e}' se3.preseed
    sed -i '/ ldapedu-server ldapedu-server\/adminpassverif string se3chief/,/#Standart drive controler/ {:z;N;/#Standart drive controler/! bz; s/^.*$/cat texte/e}' se3.preseed
    #
    # commenter la ligne run netcfg.sh
    sed -i "/netcfg.sh/ s/^/#/" se3.preseed
    #
    # remplacement des lignes language et clavier
    cat > texte << END
# Language
# MODIFICATION : langue, pays et parametres regionaux
# mettre en append → locale=fr_FR
# ----------------
d-i debian-installer/locale string fr_FR

# Disposition de clavier à utiliser
# MODIFICATION : clavier "azerty"
# mettre en append → keymap=fr(latin9)
# ----------------
d-i keymap select fr(latin9)

# network configuration
END
    #sed -i '1,20 {:z;N;20! bz; s/^.*$/cat texte/e}' se3.preseed
    sed -i '1,/#  network configuration/ {:z;N;/#  network configuration/ !b z; s/^.*$/cat texte/e}' se3.preseed
    #
    # on supprime le fichier texte temporaire
    rm -f texte
}

telecharger_scripts()
{
    # on télécharge l'archive des fichiers nécessaires aux phases 2 et 3
    echo "récupération de l'archive se3scripts.tar.gz"
    wget -q --show-progress https://${url_se3scripts}/se3scripts.tar.gz
    if [ ! "$?" = 0 ]
    then
        echo "problème lors de la récupération de l'archive se3scripts.tar.gz"
        echo ""
        exit 8
    fi
    # on l'extrait pour obtenir un répertoire se3scripts
    tar -xzf se3scripts.tar.gz
}

telecharger_iso()
{
    # on télécharge l'archive iso correspondante
    echo "récupération de l'archive ${nom_archive_iso}"
    wget -q --show-progress http://${url_iso}/${nom_archive_iso} -O ${version}_${nom_archive_iso}
    if [ ! "$?" = 0 ]
    then
        echo "problème lors de la récupération de l'archive http://${url_iso}/${nom_archive_iso}"
        echo ""
        exit 8
    fi
}

verifier_somme_controle()
{
    # on récupére la somme de contrôle md5sums du dépôt
    # paramétres :
    # $1 → le dépôt tel que ${url_firmware} ou ${url_iso}
    # $2 → fichier local tel que firmware.cpio.gz ou ${nom_archive_iso}
    wget -q http://${1}/MD5SUMS
    if [ "$?" != "0" ]
    then
        # on n'a pas récupéré la somme de contrôle
        echo "échec de la récupération des sommes de contrôle"
        echo "dépôt ${1} et archive ${2}"
        echo ""
        exit 14
    fi
    # on récupère la somme de contrôle concernant l'archive
    eval somme_depot=$(cat MD5SUMS | grep "$2" | grep -v "gtk" | cut -f1 -d" ")
    # on supprime le fichier récupéré
    rm -f MD5SUMS
    # on calcule la somme du fichier local
    eval somme_local=$(md5sum "${version}_$2" | cut -f1 -d" ")
    # on compare les 2 sommes
    if [ "${somme_local}" = "${somme_depot}" ]
    then
        # sommes égales : inutile de télécharger
        return 0
    else
        # sommes différentes : il faut télécharger
        return 1
    fi
}

gestion_iso()
{
    # en fonction des paramétres, on télécharge l'installateur iso
    # sauf si une version est présente à côté du script
    case ${mode_iso} in
        mini|netinst)
            # on vérifie son éventuelle présence
            test_iso=$(ls | grep -x ${version}_${nom_archive_iso})
            if [ -z "$test_iso" ]
            then
                telecharger_iso
            else
                # une iso mini ou netinst est présente
                echo "utilisation de l'archive ${version}_${nom_archive_iso} disponible"
                # vérifier si la version est update
                verifier_somme_controle ${url_mdsums} ${nom_archive_iso}
                [ "$?" = "1" ] && telecharger_iso
            fi
            installeur_iso="${version}_${nom_archive_iso}"
        ;;
        autre)
            # on utilise l'archive fournie
            installeur_iso="${nom_archive_iso}"
        ;;
        *)
            # autre cas ?
            exit 5
        ;;
    esac
    creer_repertoires_iso
}

creer_repertoires_iso()
{
    # on crée les répertoires de travail isoorig et isonew
    mkdir isoorig isonew
    # on monte l'archive iso dans isoorig puis on copie le contenu dans isonew
    #mount -o loop -t iso9660 debian-7.11.0-amd64-netinst.iso isoorig
    mount -o loop -t iso9660 ${installeur_iso} isoorig >$sortie 2>&1
    if [ ! "$?" = 0 ]
    then
        #
        echo "probléme lors du montage de ${installeur_iso} dans isoorig"
        echo ""
        exit 9
    fi
    rsync -a -H isoorig/ isonew >$sortie 2>&1
    if [ ! "$?" = 0 ]
    then
        #
        echo "probléme lors du transfert de isoorig vers isonew"
        echo ""
        exit 10
    fi
    # on démonte l'archive du répertoire isoorig
    umount isoorig
    # on se place dans le répertoire isonew/
    cd isonew
    # dans le cas mode_iso="autre", il faut analyser l'arborescence de l'archive
    # 2 types : mini ou netinst ?
    if [ ${mode_iso} = "autre" ]
    then
        # on teste s'il y a un répertoire isolinux et aussi un répertoire install.amd
        # est-ce suffisant ? [TODO]
        [ -d isolinux -a -d install.amd ] && mode_iso="netinst" || mode_iso="autre"
        [ ! -d isolinux ] && [ ! -d install.amd ] && mode_iso="mini"
        [ "${mode_iso}" = "autre" ] && echo "problème avec l'arborescence de l'archive ${installeur_iso} fournie" && echo "" && exit 12
    fi
}

modifier_amorce()
{
    # on modifie la ligne append du fichier txt.cfg
    # qui peut être isolinux/txt.cfg selon l'arborescence de l'archive iso
    case ${mode_iso} in
        mini)
            # txt.cfg est à la racine de l'archive
            gestion_locales_amorce
        ;;
        netinst)
            # txt.cfg est dans le répertoire isolinux/
            # est-ce le cas pour toutes les archives à part mini.iso ? [TODO]
            cd isolinux
            gestion_locales_amorce
            cd ..
        ;;
        *)
            # autre cas à prévoir ?
            exit 6
        ;;
    esac
}

gestion_locales_amorce()
{
    # on remplace vga=788 par locale=fr_FR keymap=fr(latin9)
    echo "modification de l'amorce"
    sed -i "s|vga=788|locale=fr_FR keymap=fr(latin9)|g" txt.cfg
}

gestion_initrd()
{
    # on veut incorporer les fichiers à l'initrd
    # et éventuellement les firmwares
    # pour mini.iso, initrd.gz se trouve à la racine
    # pour netinst.iso, initrd.gz se trouve dans le répertoire install.amd
    # ou install.i386 si machine 32 bits : faut-il prévoir ce cas ? [TODO]
    echo "incorporation des fichiers à l'initrd"
    case ${mode_iso} in
        mini)
            # initrd.gz est à la racine de l'archive
            # quand on sera dans le réperoire temp,
            # il faudra revenir au répertoire de base
            repertoire_base="../.."
            firmwares_base=".."
            incorporer_initrd
            incorporer_firmware
        ;;
        netinst)
            # initrd.gz est dans le répertoire install.amd
            # faut-il prévoir d'autres répertoires ? Cas des 32 bits ? [TODO]
            cd install.amd
            repertoire_base="../../.."
            firmwares_base="../.."
            incorporer_initrd
            # inutile d'incorporer les firmwares ? [TODO]
            #incorporer_firmware
            # retour à la racine de l'iso
            cd ..
        ;;
        *)
            # autre cas à prévoir ?
            exit 7
        ;;
    esac
}

incorporer_initrd()
{
    # on utilise un répertoire de travail temporarire
    mkdir temp
    # on se place dans ce répertoire de travail
    cd temp
    # on décompresse initrd.gz dans ce répertoire
    gunzip -dc ../initrd.gz | cpio -id --no-absolute-filenames
    # on copie les fichiers et le répertoire se3scripts
    cp ${repertoire_base}/se3.preseed preseed.cfg
    cp ${repertoire_base}/setup_se3.data setup_se3.data
    cp -r ${repertoire_base}/se3scripts se3scripts
    # on reconstitue initrd.gz
    find . | cpio -o -H newc | gzip > ../initrd.gz
    # on sort du répertoire de travail puis on le supprime
    cd ..
    rm -rf temp/
}

telecharger_firmware()
{
    # on télécharge les firmwares
    echo "récupération des firmwares firmware.cpio.gz"
    wget -q --show-progress http://${url_firmware}/firmware.cpio.gz -O ${version}_firmware.cpio.gz
    if [ ! "$?" = 0 ]
    then
        echo "problème lors de la récupération des firmwares firmware.cpio.gz"
        echo ""
        exit 11
    fi
    # on les sauvegarde
    cp ${version}_firmware.cpio.gz ${firmwares_base}/${version}_firmware.cpio.gz
}

incorporer_firmware()
{
    # selon la présence ou non du paramétre -f
    # si présent, mode_firmware="firmware", on incorpore les firmwares
    case "${mode_firmware}" in
        firmware)
            # méthode à partir de jessie, valable pour wheezy ? [à tester]
            if [ -f ${firmwares_base}/${version}_firmware.cpio.gz ]
            then
                # on utilise l'archive des firmwares présente
                cp ${firmwares_base}/${version}_firmware.cpio.gz ${version}_firmware.cpio.gz
                # on vérifie qu'elle est update
                verifier_somme_controle ${url_firmware} firmware.cpio.gz
                [ "$?" = "1" ] && telecharger_firmware
            else
                telecharger_firmware
            fi
            # on les incorpore à l'archive initrd.gz
            echo "incorporation des firmwares à l'initrd"
            cp -p initrd.gz initrd.gz.orig
            cat initrd.gz.orig ${version}_firmware.cpio.gz > initrd.gz
            rm -f initrd.gz.orig ${version}_firmware.cpio.gz
        ;;
        *)
            # pas d'incorporation des firmwares
            true
        ;;
    esac
}

reconstituer_iso()
{
    # on reconstitue l'archive iso personnalisée
    # la nouvelle archive se nomme my_${version}_install.iso
    case ${mode_iso} in
        mini)
            # cas mini.iso
            # les fichiers sont à la racine de l'iso
            isolinux_bin="isolinux.bin"
            boot_cat="boot.cat"
        ;;
        netinst)
            # cas netinst.iso
            # les fichiers sont dans le répertoire isolinux
            isolinux_bin="isolinux/isolinux.bin"
            boot_cat="isolinux/boot.cat"
        ;;
        *)
            # y a-t-il d'autres cas à prévoir ?
            exit 13
        ;;
    esac
    # générer image iso
    echo "génération de l'archive personnalisée"
    genisoimage -quiet -o ../my_${version}_install.iso -r -J -no-emul-boot -boot-load-size 4 -boot-info-table -b ${isolinux_bin} -c ${boot_cat} ../isonew
    # on sort de isonew
    cd ..
    echo ""
    echo "l'archive personnalisée my_${version}_install.iso est disponible"
    echo ""
}

retablir_original()
{
    # on donne le preseed modifie
    cp se3.preseed se3.preseed.modif
    # on rétablit le preseed original
    [ -f se3.preseed.orig ] && cp se3.preseed.orig se3.preseed && rm -f se3.preseed.orig
}

menage_fin()
{
    # on supprime les répertoires de travail
    rm -rf isoorig/
    rm -rf isonew/
    rm -rf se3scripts/
    rm -f se3scripts.tar.gz
}

#=====
# Fin des fonctions
#=====

####
# début programme
#
gestion_parametres "$@"
verification_initiale
modifier_preseed
telecharger_scripts
gestion_iso
modifier_amorce
gestion_initrd
reconstituer_iso
retablir_original
menage_fin
exit 0
#
# fin du programme
####
