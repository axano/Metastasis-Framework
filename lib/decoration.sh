#!/bin/bash
#This colour
cyan='\e[0;36m'
green='\e[0;32m'
lightgreen='\e[1;32m'
white='\e[1;37m'
red='\e[1;31m'
yellow='\e[1;33m'
blue='\e[1;34m'
resetCollor='\e[m'


fancyEcho()
{
collors=(
	'\e[0;36m'
	'\e[0;32m'
	'\e[1;32m'
	'\e[1;31m'
	'\e[1;37m'
	'\e[1;33m'
	'\e[1;34m'
	'\e[1;35m'
)
string=$1
for word in $string;
do
#arr=(`echo ${string}`);
arr=( $(echo ${word} | sed "s/\(.\)/\1 /g") )
for i in "${arr[@]}"
    do
	collor=${collors[$RANDOM % ${#collors[@]} ]}
	echo -ne $collor$i$resetCollor
	sleep 0.06
done
echo -n " "
done
#echo -ne "\n"
unset IFS
}

banner()
{
clear
cat << "EOF"
   _____             __                     __                   .__
  /     \    ____  _/  |_ _____     _______/  |_ _____     ______|__|  ______
 /  \ /  \ _/ __ \ \   __\\__  \   /  ___/\   __\\__  \   /  ___/|  | /  ___/
/    Y    \\  ___/  |  |   / __ \_ \___ \  |  |   / __ \_ \___ \ |  | \___ \
\____|____/ \_____> |__|  (______//______> |__|  (______//______>|__|/______>
___________ 																												 ____
\_   _____/_______ _____     _____    ____  __  _  __  ____  _______ |  | __
 |    __)  \_  __ \\__  \   /     \ _/ __ \ \ \/ \/ / /  _ \ \_  __ \|  |/ /
 |     \    |  | \/ / __ \_|  Y Y  \\  ___/  \     / (  <_> ) |  | \/|    <
 \_____/    |__|   (______/|__|_|__/ \_____>  \/\_/   \____/  |__|   |__|__\



                     OOO  OOO   OOO    OOO   OOO
                      @    @     @      @     @
                       @    @    @     @     @
                        @@@@@@@@@@@@@@@@@@@@@
                        @@@@@@@@@@@@@@@@@@@@@
                        @@@@@@@@@@@@@@@@@@@@@


                            @@@@@@@@@@@@
                          @@@@@@@  @@@@@@@
                          @@@@@@    @@@@@@
                          @@@@@      @@@@@

                               @@@@@@
                             @@@@@@@@@@
                            @@@@@@@@@@@@
                            @          @
                            @  @@@@@@  @
                            @  @@@@@@  @
                            @@@@@@@@@@@@

EOF

fancyEcho "Metastasis Framework brought to you by Highsenberg & AXANO"

}
