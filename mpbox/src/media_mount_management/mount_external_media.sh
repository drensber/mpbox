#!/bin/sh

while [ 1 ]
do 
    # "source" the configuration parameters
    . /mpservice/bin/mpservice_shell_config.sh

    # Should be made more abstract and less "hard coded" to eth0
    ETH0_IPV4INFO=`ifconfig eth0 |grep 'inet addr'`
    ETH0_IPV4BROADCAST=`echo "${ETH0_IPV4INFO}" | awk '{ print $3 }' \
                        |awk -F: '{ print $2 }'`
  
    echo "Trying to mount network volume //${media_dir__0__servername}/${media_dir__0__servervolume} on ${media_dir__0__mountpoint}"
    [ -d ${media_dir__0__mountpoint} ] || mkdir ${media_dir__0__mountpoint}

    echo ${media_dir__0__servername} | awk '!/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/ { exit 1 }' > /dev/null
    if [ "$?" == "1" ]; then  
        MUSICSERVERIP=`nmblookup -B ${ETH0_IPV4BROADCAST} ${media_dir__0__servername} \
                       | grep -v querying | awk '{ print $1 }'`
        logger "${media_dir__0__servername} resolved to ${MUSICSERVERIP}"
    else
        MUSICSERVERIP="${media_dir__0__servername}"
        logger "Using ${media_dir__0__servername} as a direct IP address."
    fi

    ping -c1 "${MUSICSERVERIP}"
    
    if [ "$?" == "0" ]; then
        mount -t "${media_dir__0__servertype}" //"${MUSICSERVERIP}"/"${media_dir__0__servervolume}" "${media_dir__0__mountpoint}" "-oiocharset=utf8,ro,guest,${media_dir__0__mountoptions}"
        exit 0
    fi
    logger "Couldn't mount server at ${MUSICSERVERIP}"
    sleep 5
done
