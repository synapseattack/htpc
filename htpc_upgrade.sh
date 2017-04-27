#!/usr/bin/env bash

export docker_compose_dir="/docker/htpc"
export docker_backup_dir="/fileserver/docker_backup"

#echo "* Pause the sabnzbd queue"
# TODO: curl command not currently working
# curl -k https://localhost:9090/sabnzbd/api?apikey=81c20d47846364b33dd232f1330b6be4&output=json&mode=queue

#echo "* Check for active Plex users"

echo "* Stop all HTPC docker containers"
cd $docker_compose_dir
docker-compose down

#echo "* Backup all HTPC docker volumes"
# TODO: What directories can be excluded during tar.
#       Check plex for backup recommendations
#sudo -u htpc tar -cvzf $docker_backup_dir/$(date +%Y%m%d%H%M%S)_htpc.tar.gz /docker

echo "* Pull the latest version of all HTPC images"
for image in $(docker images | grep linuxserver |awk '{ print $1 }'); 
do
	docker pull $image; 
done;

#echo "* Git pull new docker-compose file"


echo "* Restart HTPC docker containers"
cd $docker_compose_dir
docker-compose up -d

echo "* Clean up old docker containers"
if [ $(docker images |grep "<none>" | wc -l) -gt 0 ]
then
	docker rmi $(docker images |grep "<none>" |awk '{print $3}')
else
	echo "  - No linuxserver images to clean up"
fi

