# Management Scripts

This directory contains some useful scripts for easier development and docker management.

## build-all.sh

Builds all images based on available Dockerfiles within the repository. Optionally you can defined the DOWNLOAD_BASE_URL which will be replaced in all Dockerfiles before building. Usage:

```
./build-all.sh [DOWNLOAD_BASE_URL]
```

## docker-cleanup.sh

Cleans your docker environment:

* Deletes all containers with status `Exited`
* Removes all root images which don't have a tag (results from unsuccessful `docker build` executions)
* Removes all unused volumes

Usage:

```
./docker-cleanup.sh
```

## update-host.sh

Updates the `DOWNLOAD_BASE_URL` environment variable for all Dockerfiles. Usage:

```
./update-host.sh new_host:8080
```
