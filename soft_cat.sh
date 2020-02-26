#!/bin/env bash

#Correct full usage cat_scan -a [address] -m [net mask] -p [low port] [high port]

#Fill all variables
echo "Please provide subnet in CIDR notation. Example: soft_cat.sh 192.168.0.0 -m /28 -p 1"
echo "If single address: soft_cat.sh 192.168.0.1 -p 1 100"
NUMBERARGS="$#"
for ((i=1 ; i <= $NUMBERARGS ; i++)); do
  if [ "$1" == "-a" ]
  then
    ADDRESS="$2"
    echo "address is: $ADDRESS"
  elif [ "$1" == "-m" ]
  then
    MASK="$2"
    echo "mask is: $MASK"
  elif [ "$1" == "-p" ]
  then
    PORT1="$2"
    echo "port 1 is: $PORT1"
    if [ -n "$2" ]
    then
      PORT2="$3"
      echo "port 2 is: $PORT2"
    fi
  fi
  shift
done

#Calculate hosts
NETADDRESS="$ADDRESS$MASK"
echo "address with mask is: $NETADDRESS"


#Push NETADDRESS through ipcalc
NETMINSTRING="$(ipcalc "$NETADDRESS" -s 1 | grep -A 3 '=>'| grep HostMin:)"

ACTUALMIN=${NETMINSTRING:11:-44}

NUMHOSTSTRING="$(ipcalc "$NETADDRESS" -s 1 | grep -A 5 '=>'| grep Hosts/Net:)"

NUMHOSTS=${NUMHOSTSTRING:11:-44}

echo "Min address is: $ACTUALMIN"

echo "Number of possible hosts is: $NUMHOSTS"

#Create loop to loop through net address string, saving period position
LENGTH=${#ACTUALMIN}
PERIODARRAY=()
for ((i= 0 ; i<= $LENGTH ; i++)); do
  
  CURR=${ACTUALMIN:$i:1}
  if [ "$CURR" == "." ]
  then
	  PERIODARRAY=("${PERIODARRAY[@]}" $i)
  fi  
done

for j in "${PERIODARRAY[@]}"; do
  echo $j
done
POSITION1=${PERIODARRAY[0]}
echo "Position1 is $POSITION1"
POSITION2=${PERIODARRAY[1]}
echo "Position2 is $POSITION2"
POSITION3=${PERIODARRAY[2]}
echo "Position3 is $POSITION3"

OCTET1=${ACTUALMIN:0:$POSITION1}
OCTET2=${ACTUALMIN:($POSITION1 + 1):($POSITION2 - $POSITION1)}
OCTET3=${ACTUALMIN:($POSITION2 + 1):($POSITION3 - $POSITION2)}
OCTET4=${ACTUALMIN:($POSITION3+ 1):($LENGTH - $POSITION3)}

echo "Octet1 is $OCTET1"
echo "Octet2 is $OCTET2"
echo "Octet3 is $OCTET3"
echo "Octet4 is $OCTET4"
#Start modifying the addresses
TOTAL=$OCTET1$OCTET2$OCTET3$OCTET4
echo "Reconcatenated ip address is $TOTAL"
#Now, the loop!
LASTOCTET=$OCTET4
for ((i=0 ; i<=$NUMHOSTS ; i++)); do
	LASTOCTET=$(( LASTOCTET + 1))
	echo "Lastoctet is $LASTOCTET"
	TARGETIP=$OCTET1"."$OCTET2$OCTET3$LASTOCTET
	echo "Target IP is: $TARGETIP"
	RESULT="$(nc -v -n -z -w1 $TARGETIP $PORT1-$PORT2 | grep open)"
	echo "${RESULT}"
done	
#then
#	echo "Comparison
#FIRSTPINGTARGET=
