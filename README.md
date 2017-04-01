# docker-compose HTPC

Start your entire HTPC environment with one command.

| Application | Docker Image | Description |
| ----------- |:------------:| -----------:|
| [Sabnzbd](https://sabnzbd.org) | <a href="https://hub.docker.com/r/linuxserver/sabnzbd/" rel="linuxserver/sabnzbd">![linuxserver/sabnzbd](https://maxcdn.icons8.com/Color/PNG/24/Logos/docker-24.png)</a> | Free and easy binary newsreader |
| [CouchPotato](https://couchpota.to) | <a href="https://hub.docker.com/r/linuxserver/couchpotato/" rel="linuxserver/couchpotato">![linuxserver/couchpotato](https://maxcdn.icons8.com/Color/PNG/24/Logos/docker-24.png)</a> | Download movies automatically |
| [Sonarr](https://sonarr.tv) | <a href="https://hub.docker.com/r/linuxserver/sonarr/" rel="linuxserver/sonarr">![linuxserver/sonarr](https://maxcdn.icons8.com/Color/PNG/24/Logos/docker-24.png)</a> | Download tv episodes automatically |
| [LazyLibrarian](https://github.com/lazylibrarian/LazyLibrarian) | <a href="https://hub.docker.com/r/linuxserver/librarian/" rel="linuxserver/lazylibrarian">![linuxserver/lazylibrarian](https://maxcdn.icons8.com/Color/PNG/24/Logos/docker-24.png)</a> | Download books and magazines automatically |
| [Headphones](https://github.com/rembo10/headphones) | <a href="https://hub.docker.com/r/linuxserver/headphones/" rel="linuxserver/headphones">![linuxserver/headphones](https://maxcdn.icons8.com/Color/PNG/24/Logos/docker-24.png)</a> | Download music automatically |
| [Plex](https://www.plex.tv) | <a href="https://hub.docker.com/r/linuxserver/plex/" rel="linuxserver/plex">![linuxserver/plex](https://maxcdn.icons8.com/Color/PNG/24/Logos/docker-24.png)</a> | Stream all your content to all your devices |
| [Ombi](http://www.ombi.io) | <a href="https://hub.docker.com/r/linuxserver/ombi/" rel="linuxserver/ombi">![linuxserver/ombi](https://maxcdn.icons8.com/Color/PNG/24/Logos/docker-24.png)</a> | Plex Request and user management system |
| [PlexPy](https://github.com/JonnyWong16/plexpy) | <a href="https://hub.docker.com/r/linuxserver/plexpy/" rel="linuxserver/plexpy">![linuxserver/plexpy](https://maxcdn.icons8.com/Color/PNG/24/Logos/docker-24.png)</a> | A Python based monitoring and tracking tool for Plex Media Server |
| [HTPCManager](http://www.htpcmanager.io) | <a href="https://hub.docker.com/r/linuxserver/htpcmanager/" rel="linuxserver/htpcmanager">![linuxserver/htpcmanager](https://maxcdn.icons8.com/Color/PNG/24/Logos/docker-24.png)</a> | Manage your HTPC from anywhere |

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

The following packages need to be installed:

1. Your favorite flavor of linux.  All file paths are linux specific
2. Docker Community Edition (currently tested on 17.03.1-ce)
3. Docker-Compose (currently tested on 1.11.1, build 7c5d5e4)

### Installing

Installing Linux, Docker and docker-compose is beyond the scope of this README.  There are numerous resources on the Internet for those topics.  Executing docker-compose will install all necessary Docker images.  No further installation is needed.

## Deployment

From the Linux command line in the directory of the docker-compose.yml file run the following:

`docker-compose up -d`

To stop all htpc services:

`docker-compose down`

You can also start and stop individual services:

`docker-compose up -d <service1> [<service2> <serviceN>]`

## Built With

* [Docker](https://www.docker.com) - The container engine
* [Docker-compose](https://docs.docker.com/compose/) - Tool for defining and running multi-container Docker applications

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/bnestelroad/htpc/tags). 

## Authors

* **Brad Nestelroad** - *Initial work* 

See also the list of [contributors](https://github.com/bnestelroad/htpc/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

Thanks to everyone who developed the following:
* Linux
* Usenet
* Docker/Docker Compose
* LinuxServer.io
* Plex
* Sabnzbd
* Sonarr
* CouchPotato
* Headphones
* LazyLibrarian
* PlexPy
* HTPCManager
* Ombi

