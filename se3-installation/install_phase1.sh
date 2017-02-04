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
# le fichier se3.preseed aura été modifié
# sinon, le prévoir dans le script ?
#
# Paramétres :  -f → incorporation des firmwares
#               -h → aide
# aucun paramètre : pas d'incorporation des firmwares
#

####
# les variables
version="wheezy"
# url pour récupérer l'archive se3scripts.tar.gz
url_se3scripts="github.com/SambaEdu/se3-docs/raw/master/se3-installation"
# url pour récupérer l'installateur mini.iso
url_mini_iso="ftp.fr.debian.org/debian/dists/${version}/main/installer-amd64/current/images/netboot"
# url pour récupérer le fichier firmware.cpio.gz
url_firmwares="cdimage.debian.org/cdimage/unofficial/non-free/firmware/${version}/current"

mode_texte()
{
    echo "Utilisation : $0 [-paramétre]"
    echo "paramètres possibles :"
    echo "   -h : afficher cet aide-mémoire"
    echo "   -f : incorporer les firmwares"
    echo "sans paramètre, on n'incorpore pas les firmwares"
}

gestion_parametres()
{
    # on récupère un éventuel paramétre
    if [ ! "$#" = "0" ]
    then
        case $1 in
            -f)
                # mode firmware
                # l'iso doit incorporer les firmwares
                mode="firmware"
            ;;
            -h)
                # on affiche l'aide
                mode_texte
                exit 0
            ;;
            *)
                echo "paramètre $1 incorrect"
                # on affiche l'aide
                mode_texte
                exit 2
            ;;
        esac
    else
        # pas de paramètre donc pas de firmwares
        mode="nofirmware"
    fi
}

verification_initiale()
{
    # message début
    echo "personnalisation d'une archive d'installation se3"
    echo ""
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
    if [ -z "${test_setup}" -o -z "${test_setup}" ]
    then
        echo "veuillez placer les fichiers se3.preseed et setup_se3.data dans le répertoire où se trouve le script $0"
        exit 3
    fi
    # on supprime les traces éventuelles des répertoires de travail…
    [ -d se3scripts/ ] && rm -rf se3scripts/
    [ -d isoorig/ ] && rm -rf isoorig/
    [ -d isonew/ ] && rm -rf isonew/
}

modifier_preseed()
{
    # on adapte le fichier se3.preseed
    # 2 options :
    # → se3.preseed déjà modifié
    # → le faire ici ?
    true
}

telecharger_scripts()
{
    # on télécharge l'archive des fichiers nécessaires aux phases 2 et 3
    wget https://${url_se3scripts}/se3scripts.tar.gz
    # on l'extrait pour obtenir un répertoire se3scripts
    tar -xzf se3scripts.tar.gz
}

telecharger_mini_iso()
{
    # on télécharge l'archive mini.iso
    wget http://${url_mini_iso}/mini.iso -O ${version}_mini.iso
}

creer_repertoires_iso()
{
    # on crée les répertoires de travail isoorig et isonew
    mkdir isoorig isonew
    # on monte l'archive mini.iso dans isoorig puis on copie le contenu dans isonew
    mount -o loop -t iso9660 ${version}_mini.iso isoorig
    rsync -a -H isoorig/ isonew
    # on démonte l'archive
    umount isoorig
    # on se place dans le répertoire isonew/
    cd isonew
}

modifier_amorce()
{
    # on modifie la ligne append du fichier txt.cfg
    # on remplace vga=788 par locale=fr_FR keymap=fr(latin9)
    sed -i "s|vga=788|locale=fr_FR keymap=fr(latin9)|g" txt.cfg
}

incorporer_initrd()
{
    # on incorpore les fichiers à l'initrd
    mkdir temp
    cd temp
    # on décompresse initrd.gz
    gunzip -dc ../initrd.gz | cpio -id --no-absolute-filenames
    # on copie les fichiers et le répertoire se3scripts
    cp ../../se3.preseed preseed.cfg
    cp ../../setup_se3.data setup_se3.data
    cp ../../se3scripts se3scripts
    # on reconstitue initrd.gz
    find . | cpio -o -H newc | gzip > ../initrd.gz
    cd ..
    rm -rf temp/
}

incorporer_firmwares()
{
    # selon la présence ou non du paramétre -f
    # si présent, mode="firmware", on incorpore les firmwares
    case $mode in
        firmware)
            # on télécharge les firmwares et on les incorpore à l'archive initrd.gz
            wget http://${url_firmwares}/firmware.cpio.gz
            cp -p initrd.gz initrd.gz.orig
            cat initrd.gz.orig firmware.cpio.gz > initrd.gz
            rm -f initrd.gz.orig firmware.cpio.gz
        ;;
        *)
            # pas d'incorporation des firmwares
            true
        ;;
    esac
}

reconstituer_iso()
{
    # on reconstitue l'archive mini.iso personnalisée
    # la nouvelle archive se nomme my_${version}_install.iso
    genisoimage -o ../my_${version}_install.iso -r -J -no-emul-boot -boot-load-size 4 -boot-info-table -b isolinux.bin -c boot.cat ../isonew
    cd ..
    "l'archive personnalisée my_${version}_install.iso est disponible"

}

menage_fin()
{
    # on supprime les répertoires de travail
    rm -rf isoorig/
    rm -rf isonew/
    rm -rf scripts/
    rm -f se3scripts.tar.gz
}

gestion_parametres
verification_initiale
modifier preseed
telecharger_scripts
telecharger_mini_iso
creer_repertoires_iso
modifier_amorce
incorporer_initrd
incorporer_firmwares
reconstituer_iso
menage_fin
exit 0
