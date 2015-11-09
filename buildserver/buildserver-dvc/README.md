# Buildserver Data Volume Container (DVC) Docker Image

This image can be used to create a data volume container which holds persistent data volumes for the buildserver. See [docker docs](http://docs.docker.com/v1.8/userguide/dockervolumes/#creating-and-mounting-a-data-volume-container) for more details about the concept.

## Create the volume container

Before starting the actual buildserver create a volume container based on the `buildserver-dvc` image:

```
docker create \
  -v /var/opt/artifactory \
  -v /var/opt/gitlab \
  -v /var/opt/jenkins \
  --name buildserver-dvc \
  ibm/buildserver-dvc
```

**Note:** You should never delete that container since this will discard all the data (indirectly)!

Start the buildserver and mount the volumes from `buildserver-dvc`:

```
docker run -id \
  -p 8080:8080 \
  -p 9080:9080 \
  -p 222:22 \
  --volumes-from buildserver-dvc \
  --hostname buildserver \
  --name buildserver \
  ibm/buildserver
```
