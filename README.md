# docker-compose HTPC

Start your entire HTPC environment with one command

* linuxserver/sabnzbd - Free and easy binary newsreader (sabnzbd.org)
* linuxserver/couchpotato - Download movies automatically (https://couchpota.to)
* linuxserver/sonarr - Download tv episodes automatically (https://sonarr.tv)
* linuxserver/lazylibrarian - Download books and magazines automatically (https://github.com/lazylibrarian/LazyLibrarian)
* linuxserver/headphones - Download music automatically (https://github.com/rembo10/headphones)
* linuxserver/plex - Stream all your content to all your devices (https://www.plex.tv)
* linuxserver/ombi - Plex Request and user management system (ombi.io)
* linuxserver/plexpy - A Python based monitoring and tracking tool for Plex Media Server (https://github.com/JonnyWong16/plexpy)
* linuxserver/htpcmanager - Manage your HTPC from anywhere (htpcmanager.io)


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

