#! /bin/bash
duration=$2
end=$((SECONDS+$duration))

while [ $SECONDS -lt $end ]; do

        if ss -nap | grep -q -s $1; then
                :
        else
                systemctl restart $1
                mail -s "Service $1 restart" mail@domain.com <<< "Service $1 was succesfully restarted"
        exit 1
        fi

done
mail -s "Service $1 restart failed" mail@domain.com <<< "Timeout $2 for the $1 service restart"
exit

#The script should be used with the parameters: the first one is server name (e.g. mysql or nginx); the second one is time of script execution (in seconds).

#To restart mysql using the script with 1 hour timeout it’s necessary to execute:

#`./scriptname.sh mysql 3600`

#If successful, service will be restarted and you’ll get a notification to the e-mail. If in an hour to the service there will be some active connections, it won’t restart and you’ll receive an email with the information that the service hasn’t been restarted