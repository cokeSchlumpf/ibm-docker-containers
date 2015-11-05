# Installation Files

This directory contains installation files for Docker containers during build time. The basic structure of the directory is as follows:

```
installation-files
  ├ ${application-name-1}
  │ ├ README.md
  │ ├ ${application-name-1}_${version-1}.${file-extension}
  │ └ ${application-name-1}_${version-2}.${file-extension}
  └ ${application-name-2}
    ├ README.md
    ├ ${application-name-2}_${version-1}.${file-extension}
    └ ${application-name-2}_${version-2}.${file-extension}
```

All files contained in these folders should be added to `.gitignore` except for `README.md`. The `README.md` should contain instructions how to obtain the installation files.

## Make files available to Docker build process

During the run of `docker build` the images are trying to download the packages from an HTTP-Server, it's expected that the server provides this directory as root. If you have python installed on your host you can start the SimpleHTTPServer module (from within this directory).

```
python -m SimpleHTTPServer 8080
```

Before running `docker build` for the images ensure that the environment variable `ENV DOWNLOAD_BASE_URL=${hostname}:8080` (see Dockerfiles) is set to the hostname and port where installation-files directory is served.
