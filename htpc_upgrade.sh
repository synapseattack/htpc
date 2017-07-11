#!/usr/bin/env bash

export docker_compose_dir="/docker/htpc"
export docker_backup_dir="/fileserver/docker_backup"
# Pull a list of all docker-compose services
declare -a docker_services=$(docker-compose config --services)
export plexpy_users
export plexpy_ip_address="192.168.0.202"
export plexpy_port="8282"
export plexpy_api_key="68600c669af2b6f9afbda97de9b86e38"
export sabnzbd_ip_address="192.168.0.202"
export sabnzbd_port="8080"
export sabnzbd_api_key="81c20d47846364b33dd232f1330b6be4"
export sabnzbd_pause_status
export sabnzbd_unpause_status
export sabnzbd_queue_status

##########################################################################
#
# Pause the queue and return whether the command was successful (true) or not (false)
#
##########################################################################

function pauseSabnzbdQueue()
{
	echo -e "\e[32m* Pause the sabnzbd queue\e[0m"
	sabnzbd_pause_status=$(curl -s "http://$sabnzbd_ip_address:$sabnzbd_port/sabnzbd/api?apikey=$sabnzbd_api_key&output=json&mode=pause" | jq .status)
}

#########################################################################
#
# Resume the sabnzbd queue and return whether the command was successful (true) or not (false)
#
##########################################################################

function resumeSabnzbdQueue()
{
	echo -e "\e[32m* Unpause the sabnzbd queue\e[0m"
	sabnzbd_unpause_status=$(curl -s "http://$sabnzbd_ip_address:$sabnzbd_port/sabnzbd/api?apikey=$sabnzbd_api_key&output=json&mode=resume" | jq .status)
}

##########################################################################
#
#
#
##########################################################################

function sabnzbdQueueStatus()
{
	sabnzbd_queue_status=$(curl -s "http://$sabnzbd_ip_address:$sabnzbd_port/sabnzbd/api?apikey=$sabnzbd_api_key&output=json&mode=queue" | jq .queue.paused)
}

##########################################################################
#
# Query PlexPy for the number of users logged into Plex. This value is used
# later on to determine if Plex can be turned off without impacting users.
#
##########################################################################

function checkPlexUsers()
{
	echo -e "\e[32m* Check for active Plex users\e[0m"
	# the return value from jq actually has double quotes around it.
	# Those need to be striped off in order for the variable to work.
	plexpy_users=$(curl -s "http://$plexpy_ip_address:$plexpy_port/api/v2?apikey=$plexpy_api_key&cmd=get_activity" | jq .response.data.stream_count | sed s/\"//g)
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
	sudo apt-get update
	sudo apt-get --only-upgrade install docker-ce
}

##########################################################################

function upgradeDockerCompose()
{
	export docker_compose_version_installed=$(docker-compose version |grep "docker-compose version" |awk '{print $3}' |sed 's/,//')
	# Harcoded docker_compose version
	#export docker_compose_version_available="1.13.0"
	# Query the version, but jq needs to be installed on the server running this script
	#export docker_compose_version_available=$(curl -s https://api.github.com/repos/docker/compose/tags |jq --raw-output '.[] | .name' |egrep -v "\-rc|docs" |sort --version-sort |tail -1)
	# Query the version, Docker needs to be installed and configured.  It will pull pinterb/jq if it is missing
	export docker_compose_version_available=$(curl -s https://api.github.com/repos/docker/compose/tags | docker run -i pinterb/jq --raw-output '.[] | .name' |egrep -v "\-rc|docs" |sort --version-sort |tail -1)

	echo -e "\e[32m* Install latest docker-compose version\e[0m"
	if [ $docker_compose_version_installed != $docker_compose_version_available ] 
	then
		sudo curl -L https://github.com/docker/compose/releases/download/$docker_compose_version_available/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
		sudo chmod +x /usr/local/bin/docker-compose
	else
		echo -e "\e[31m  - docker-compose already up to date\e[0m"
	fi

	# Remove the docker image pinterb/jq.  A new version of the image will be
	# downloaded next time the script runs
	docker rmi pinterb/jq
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

checkPlexUsers

if [ $plexpy_users -eq 0 ]
then
	echo "No users"
else
	echo "Still users"
fi

if [ pauseSabnzbdQueue ]
then
	echo "SABNZBD queue paused"
else
	echo "ERROR: SABNZBD queue not paused"
fi

# TODO: Check to see if there are any new docker images
pullDockerCompose

# TODO: Check to see if docker needs to be upgraded before stopping
# TODO: Check to see if docker-compose needs to be upgraded before stopping
stopDockerCompose

#backupContainerVolumes

upgradeDocker

upgradeDockerCompose

startDockerCompose

if [ resumeSabnzbdQueue ]
then
	echo "SABNZBD queue resumed"
else
	echo "ERROR: SABNZBD queue not resumed"
fi

removeOldContainers
