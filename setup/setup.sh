#!/bin/bash
SCRIPT=`realpath -s $0`
path=`dirname $SCRIPT`
source $path/../lib/decoration.sh
source $path/../lib/support.sh

install()
{
fancyEcho "Starting setup....."
clear
dpkg --add-architecture i386 && sudo apt update
preReqs=(
     'openssl'
     'apache2'
     'metasploit-framework'
	 'wine'
	 'wine64'
	 'wine32'
   'gnome-terminal'
   )
for i in "${preReqs[@]}"
do
   :
   if [ "$i" == "metasploit-framework" ] ; then
   i=msfconsole
   condition=$(which $i 2>/dev/null | grep -v "not found" | wc -l)
 else
   condition=$(which $i 2>/dev/null | grep -v "not found" | wc -l)
 fi
   if
[ $condition -eq 0 ] ; then
    echo -e "\e[0;31m$i is not installed\e[m"
    echo -e "\e[0;31mInstalling $i...\e[m"
    sudo apt-get install $i -y
    sleep 2
else
   echo "$i is installed"
fi
done
echo -e $red "SELECT INSTALL FOR ALL USERS" $resetCollor
echo $path
sleep 2
wine64 msiexec /i ${path}/python-3.4.4.amd64.msi
wine python -m pip install --upgrade pip
wine pip install PyInstaller
echo -e $red "WARNING install verification not supported yet..." $resetCollor
echo -e $green "Setup done..." $resetCollor
#echo "PATH=$path/../:" >> ~/.bashrc 
sleep 5
exit
}
isRoot
install
