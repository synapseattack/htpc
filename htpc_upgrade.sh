#!/usr/bin/env bash

export docker_compose_dir="/docker/htpc"
export docker_backup_dir="/fileserver/docker_backup"
export docker_compose_version_installed=$(docker-compose version |grep "docker-compose version" |awk '{print $3}' |sed 's/,//')
export docker_compose_version_available="1.13.0"

# Pull a list of all running containers.  This will be used for the backup script


#echo -e "\e[32m* Pause the sabnzbd queue\e[0m"
# TODO: curl command not currently working
# curl -k https://localhost:9090/sabnzbd/api?apikey=81c20d47846364b33dd232f1330b6be4&output=json&mode=queue

#echo -e "\e[32m* Check for active Plex users\e[0m"

echo -e "\e[32m* Pull the latest version of all HTPC images\e[0m"
docker-compose pull

echo -e "\e[32m* Stop all HTPC docker containers\e[0m"
#cd $docker_compose_dir
docker-compose down

#echo -e "\e[32m* Backup all HTPC docker volumes\e[0m"
# TODO: What directories can be excluded during tar.
#       Check plex for backup recommendations
#sudo -u htpc tar -cvzf $docker_backup_dir/$(date +%Y%m%d%H%M%S)_htpc.tar.gz /docker

#echo -e "\e[32m* Pull the latest version of all HTPC images\e[0m"
#for image in $(docker images | grep linuxserver |awk '{ print $1 }'); 
#do
#	docker pull $image; 
#done;

echo -e "\e[32m* Install latest docker version\e[0m"
sudo apt-get --only-upgrade install docker

echo -e "\e[32m* Install latest docker-compose version\e[0m"
if [ $docker_compose_version_installed != $docker_compose_version_available ] 
then
	sudo curl -L https://github.com/docker/compose/releases/download/$docker_compose_version_available/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose
else
	echo -e "\e[31m  - docker-compose already up to date\e[0m"
fi

echo -e "\e[32m* Restart HTPC docker containers\e[0m"
#cd $docker_compose_dir
docker-compose up -d

echo -e "\e[32m* Clean up old docker containers\e[0m"
if [ $(docker images |grep "<none>" | wc -l) -gt 0 ]
then
	docker rmi $(docker images |grep "<none>" |awk '{print $3}')
else
	echo -e "\e[31m  - No linuxserver images to clean up\e[0m"
fi

