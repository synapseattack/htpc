#!/usr/bin/env bash

##########################################################################

# TODO: curl command not currently working

function pauseSabnzbdQueue()
{
	echo -e "\e[32m* Pause the sabnzbd queue\e[0m"
	curl -k https://localhost:9090/sabnzbd/api?apikey=81c20d47846364b33dd232f1330b6be4&output=json&mode=queue
}

##########################################################################

# TODO: query Plex for active users.  If users found exit the script

function checkPlexUsers()
{
	echo -e "\e[32m* Check for active Plex users\e[0m"
}

##########################################################################

# TODO: If no new images pulled skip to docker+docker-compose upgrade
# TODO: Query docker hub for hashes of :latest images.  Compare those hashes
#       to the hash of the currently installed images.  if they are different
#       then pull.  If they are the same skip the pull

function pullDockerCompose()
{
	# @Deprecated
	#echo -e "\e[32m* Pull the latest version of all HTPC images\e[0m"
	#for image in $(docker images | grep linuxserver |awk '{ print $1 }'); 
	#do
	#	docker pull $image; 
	#done;

	echo -e "\e[32m* Pull the latest version of all HTPC images\e[0m"
	docker-compose pull
}

##########################################################################

function startDockerCompose()
{
	echo -e "\e[32m* Restart HTPC docker containers\e[0m"
	#cd $docker_compose_dir
	docker-compose up -d
}

##########################################################################

function stopDockerCompose()
{
	echo -e "\e[32m* Stop all HTPC docker containers\e[0m"
	#cd $docker_compose_dir
	docker-compose down
}

##########################################################################

function upgradeDocker()
{
	echo -e "\e[32m* Install latest docker version\e[0m"
	sudo apt-get --only-upgrade install docker
}

##########################################################################

# TODO: remove hard coded docker-compose version
# TODO: Query github for the latest version of docker-compose
#       https://api.github.com/repos/docker/compose/tags
function upgradeDockerCompose()
{
	export docker_compose_version_installed=$(docker-compose version |grep "docker-compose version" |awk '{print $3}' |sed 's/,//')
	export docker_compose_version_available="1.13.0"
	
	echo -e "\e[32m* Install latest docker-compose version\e[0m"
	if [ $docker_compose_version_installed != $docker_compose_version_available ] 
	then
		sudo curl -L https://github.com/docker/compose/releases/download/$docker_compose_version_available/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
		sudo chmod +x /usr/local/bin/docker-compose
	else
		echo -e "\e[31m  - docker-compose already up to date\e[0m"
	fi
}

##########################################################################

# TODO: What directories can be excluded during tar.  Check plex documentation for backup recommendations
# TODO: Execute all backups in parallel to speed up the process.
# TODO: Execute backup commands for each app instead of simply running tar
function backupContainerVolumes()
{
	echo -e "\e[32m* Backup all HTPC docker volumes\e[0m"
	sudo -u htpc tar -cvzf $docker_backup_dir/$(date +%Y%m%d%H%M%S)_htpc.tar.gz /docker
}

##########################################################################

function removeOldContainers()
{
	echo -e "\e[32m* Clean up old docker containers\e[0m"
	if [ $(docker images |grep "<none>" | wc -l) -gt 0 ]
	then
		docker rmi $(docker images |grep "<none>" |awk '{print $3}')
	else
		echo -e "\e[31m  - No linuxserver images to clean up\e[0m"
	fi
}

##########################################################################

export docker_compose_dir="/docker/htpc"
export docker_backup_dir="/fileserver/docker_backup"

# Pull a list of all docker-compose services
declare -a docker_services=$(docker-compose config --services)


##checkPlexUsers
##pauseSabnzbdQueue

# TODO: Check to see if there are any new docker images
pullDockerCompose

# TODO: Check to see if docker needs to be upgraded before stopping
# TODO: Check to see if docker-compose needs to be upgraded before stopping
stopDockerCompose

#backupContainerVolumes

upgradeDocker

upgradeDockerCompose

startDockerCompose

removeOldContainers
