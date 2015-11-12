# Management Scripts

This directory contains some useful scripts for easier development and docker management.

## build-all.sh

Builds all docker images within the project. Before building the DOWNLOAD_BASE_URL and the proxy settings may be updated within Dockerfiles.

Usage:

```
build-all [options]

Options:
  -d|--download-base-url DOWNLOAD_BASE_URL
          Define DOWNLOAD_BASE_URL to be passed to update-host.sh. See './update-host.sh -h' for details.
  -m|--proxy-mode disable|enable|auto
         Define the update mode for update-proxy.sh. See './update-proxy.sh -h' for deatils.
  -p|--proxy PROXY_HOST:PROXY_PORT
         Define the proxy url for update-proxy.sh. See './update-proxy.sh -h' for deatils.
  -h|--help
         Show this help.
```

## docker-cleanup.sh

Cleans your docker environment:

* Deletes all containers with status `Exited`
* Removes all root images which don't have a tag (results from unsuccessful `docker build` executions)
* Removes all unused volumes

Usage:

```
docker-cleanup
```

## update-host.sh

Use this shell script to update `DOWNLOAD_BASE_URL` within Dockerfiles before build.

Usage:

```
update-host DOWNLOAD_BASE_URL
```

## update-proxy.sh

Use this shell script to update proxy configuration within Dockerfiles before build.

Usage:

```
update-proxy disable
            enable PROXY_HOST:PROXY_PORT
            auto
```

If mode is set to auto the script uses the environmant variable `http_proxy` to detect whether to set a proxy or not.
