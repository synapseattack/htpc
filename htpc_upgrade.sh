#!/usr/bin/env bash

export docker_config_root="/docker"
export docker_compose_dir="$docker_config_root/htpc"
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
	majorBulletPoint "Pause the sabnzbd queue"
	sabnzbd_pause_status=$(curl -s "http://$sabnzbd_ip_address:$sabnzbd_port/sabnzbd/api?apikey=$sabnzbd_api_key&output=json&mode=pause" | docker run --rm -i pinterb/jq --raw-output .status)
}

#########################################################################
#
# Resume the sabnzbd queue and return whether the command was successful (true) or not (false)
#
##########################################################################

function resumeSabnzbdQueue()
{
	majorBulletPoint "Unpause the sabnzbd queue"

	sabnzbd_unpause_status=$(curl -s "http://$sabnzbd_ip_address:$sabnzbd_port/sabnzbd/api?apikey=$sabnzbd_api_key&output=json&mode=resume" | docker run --rm -i pinterb/ jq --raw-output .status)
}

##########################################################################
#
#
#
##########################################################################

function sabnzbdQueueStatus()
{
	sabnzbd_queue_status=$(curl -s "http://$sabnzbd_ip_address:$sabnzbd_port/sabnzbd/api?apikey=$sabnzbd_api_key&output=json&mode=queue" | docker run --rm -i pinterb/jq --raw-output .queue.paused)
}

##########################################################################
#
# Query PlexPy for the number of users logged into Plex. This value is used
# later on to determine if Plex can be turned off without impacting users.
#
##########################################################################

function checkPlexUsers()
{
	majorBulletPoint "Check for active Plex users"

	# the return value from jq actually has double quotes around it.
	# Those need to be striped off in order for the variable to work.
	plexpy_users=$(curl -s "http://$plexpy_ip_address:$plexpy_port/api/v2?apikey=$plexpy_api_key&cmd=get_activity" | docker run --rm -i pinterb/jq --raw-output .response.data.stream_count)
}

##########################################################################
#
# TODO: If no new images pulled skip to docker+docker-compose upgrade
# TODO: Query docker hub for hashes of :latest images.  Compare those hashes
#       to the hash of the currently installed images.  if they are different
#       then pull.  If they are the same skip the pull
#
##########################################################################

function pullDockerCompose()
{
	# @Deprecated
	#echo -e "\e[32m* Pull the latest version of all HTPC images\e[0m"
	#for image in $(docker images | grep linuxserver |awk '{ print $1 }'); 
	#do
	#	docker pull $image; 
	#done;

	majorBulletPoint "Pull the latest version of all HTPC images"

	docker-compose pull
}

##########################################################################

function startDockerCompose()
{
	majorBulletPoint "Restart HTPC docker containers"

	docker-compose up -d
}

##########################################################################

function stopDockerCompose()
{
	majorBulletPoint "Stop all HTPC docker containers"

	docker-compose down
}

##########################################################################

function upgradeDocker()
{
	majorBulletPoint "Install latest docker version"
	# TODO: minorBulletPoint - display current docker version

	sudo apt-get update
	# TODO: query apt for version to install.  Only install if an upgradable 
	sudo apt-get --only-upgrade install docker-ce
	# TODO: minorBulletPoint - display installed docker version
}

##########################################################################

function upgradeDockerCompose()
{
	export docker_compose_version_installed=$(docker-compose version |grep "docker-compose version" |awk '{print $3}' |sed 's/,//')

	# @Deprecated
	# Harcoded docker_compose version
	#export docker_compose_version_available="1.13.0"
	# Query the version, but jq needs to be installed on the server running this script
	#export docker_compose_version_available=$(curl -s https://api.github.com/repos/docker/compose/tags |jq --raw-output '.[] | .name' |egrep -v "\-rc|docs" |sort --version-sort |tail -1)
	
	# Query the version, Docker needs to be installed and configured.  It will pull pinterb/jq if it is missing
	export docker_compose_version_available=$(curl -s https://api.github.com/repos/docker/compose/tags | docker run --rm -i pinterb/jq --raw-output '.[] | .name' |egrep -v "\-rc|docs" |sort --version-sort |tail -1)

	majorBulletPoint "Install latest docker-compose version"

	if [ $docker_compose_version_installed != $docker_compose_version_available ] 
	then
		sudo curl -L https://github.com/docker/compose/releases/download/$docker_compose_version_available/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
		sudo chmod +x /usr/local/bin/docker-compose
	else
		echo -e "\e[31m  - docker-compose already up to date\e[0m"
	fi
}

##########################################################################
#
# TODO: What directories can be excluded during tar.  Check plex documentation for backup recommendations
# TODO: Execute all backups in parallel to speed up the process.
# TODO: Execute backup commands for each app instead of simply running tar
#
##########################################################################

function backupContainerVolumes()
{
	majorBulletPoint "Backup all HTPC docker volumes"

	#sudo -u htpc tar -cvzf $docker_backup_dir/$(date +%Y%m%d%H%M%S)_htpc.tar.gz /docker
	for i in $(find /docker -maxdepth 1 ! -path /docker -type d -printf '%f\n'); 
	do 
		echo "sudo -u htpc tar -cvzf $docker_backup_dir/$(date +%Y%m%d%H%M%S)_$i.tar.gz $docker_config_root/$i &"; 
	done;
}

##########################################################################

function removeOldContainers()
{
	majorBulletPoint "Clean up old docker containers"

	if [ $(docker images |grep "<none>" | wc -l) -gt 0 ]
	then
		docker rmi $(docker images |grep "<none>" |awk '{print $3}')
	else
		minorBulletPoint "No linuxserver images to clean up"
	fi
}

##########################################################################
#
# Add formatting to screen text that shows up as a major bullet point.
#
##########################################################################

function majorBulletPoint()
{
	echo -e "\e[32m* $1 \e[0m"	
}

##########################################################################
#
# Add formatting to screen text output so it appears as a bullet point that
#  is a child to a parent bullet point
#
##########################################################################

function minorBulletPoint()
{
	echo -e "\e[31m  - $1\e[0m"
}

##########################################################################

# Pull the docker image pinterb/jq.  This is used to parse json strings
# from various services
majorBulletPoint "Pull docker container pinterb/jq"
docker pull pinterb/jq

checkPlexUsers

if [ $plexpy_users -eq 0 ]
then
	echo "No users"
else
	echo "Still users"
fi

if [ pauseSabnzbdQueue ]
then
	majorBulletPoint "SABNZBD queue paused"
else
	majorBulletPoint "ERROR: SABNZBD queue not paused"
fi

# TODO: Check to see if there are any new docker images
pullDockerCompose

# TODO: Check to see if docker needs to be upgraded before stopping
# TODO: Check to see if docker-compose needs to be upgraded before stopping
stopDockerCompose

backupContainerVolumes

upgradeDocker

upgradeDockerCompose

startDockerCompose

if [ resumeSabnzbdQueue ]
then
	majorBulletPoint "SABNZBD queue resumed"
else
	majorBulletPoint "ERROR: SABNZBD queue not resumed"
fi

removeOldContainers

# Remove the docker image pinterb/jq.  A new version of the image will be
# downloaded next time the script runs
majorBulletPoint "Delete docker container pinterb/jq"
docker rmi pinterb/jq

