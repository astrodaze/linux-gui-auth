#!/bin/bash 
#================================================================
# Date: 2021-07-04
# Description: Add polkit rules for gui auth for domain users.
#              Primary use is for domain joined 16.04 and 18.04 ubuntu
#================================================================

local_rule=/var/lib/polkit-1/localauthority/10-vendor.d/com.ubuntu.desktop.pkla
NETWORK_SETTINGS=/var/lib/polkit-1/localauthority/50-local.d/networkmanager.pkla 


function guiSettings(){
    if [[ -z `grep gui ${local_rule}` ]] ; then 
        echo "creating backup of com.ubuntu.desktop.pkla..." 
        echo
        cp ${local_rule} ${local_rule}.bak
        addRules 
else  
    echo
    echo "gui auth rules already configured.. moving on.."
fi 
}

function networksettings(){
if [ -z `grep NetworkManager ${NETWORK_SETTINGS}` ] ; then 
    echo "adding network settings..."
    tee -a  $NETWORK_SETTINGS > /dev/null << EOT
[Changing system-wide NetworkManager connections]
Identity:unix-group:*
Action=org.freedesktop.NetworkManager.settings.modify.system
ResultAny=no
ResultInactive=no
ResultActive=yes
EOT
else 
    echo "network settings already configured.. moving on.."
fi
}

function addRules(){
    tee -a  $local_rule > /dev/null << EOT
[Allow user to change user accounts]
Identity=unix-group:admin;unix-group:sudo
Action=org.gnome.controlcenter.user-accounts.administration
ResultActive=yes

[Allow user to install from software]
Identity=unix-group:admin;unix-group:sudo
Action=org.debian.apt.install-or-remove-packages
ResultActive=yes

[Allow user to install package using gui]
Identity=unix-group:admin;unix-group:sudo
Action=org.debian.apt.install-file
ResultActive=yes

[Allow user to install using snap]
Identity=unix-group:admin;unix-group:sudo
Action=io.snapcraft.snapd.manage;io.snapcraft.snapd.login;io.snapcraft.snapd.manage-interfaces
ResultActive=yes
EOT
}


id=`id -u`
if [[ "$id" -ne 0 ]] ; then
    echo "Script needs to be run as root. Exiting.."
else  
    echo "This script adds additional polkit rules to allow domain users to authenticate in the gui"
    guiSettings
    networksettings
fi