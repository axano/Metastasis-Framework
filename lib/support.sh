#!/bin/bash
isRoot()
{
# Init
FILE="/tmp/out.$$"
GREP="/bin/grep"
#....
# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
}

validIp(){
    local  ip=$1
    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        return 1
    fi
    return 0
}

isValidPort(){
local  port=$1
re='^[0-9]+$'
if ! [[ $port =~ $re ]] || [ $port -gt 65536 ]   ; then
   return 0
fi

return 1

}

checkPreReq()
{
clear
preReqs=(
     'openssl'
     'apache2'
     'metasploit-framework'
	 'wine'
	 'wine64'
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
    echo -e $red "$i is not installed" $resetCollor
    echo -e $red "Run setup.sh" $resetCollor
    sleep 2
else
   echo "$i is installed"
fi
done
sleep 2
}

unsupported()
{
echo -e $red "unsupported action returnting to menu..." $resetCollor
sleep 2
menu
}
