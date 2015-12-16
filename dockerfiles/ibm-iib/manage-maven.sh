#!/bin/bash

TEMPORARY_DIRECTORY="$(mktemp -d)"
DOWNLOAD_TO="$TEMPORARY_DIRECTORY/maven.tgz"

echo 'Downloading Maven to: ' "$DOWNLOAD_TO"

wget -O "$DOWNLOAD_TO" http://apache.mirror.iphh.net/maven/maven-3/3.3.3/binaries/apache-maven-3.3.3-bin.tar.gz

echo 'Extracting Maven'
tar xzf $DOWNLOAD_TO -C $TEMPORARY_DIRECTORY
rm $DOWNLOAD_TO

echo 'Configuring Envrionment'

mv $TEMPORARY_DIRECTORY/apache-maven-* /usr/local/maven
echo -e 'export JAVA_HOME=/usr/lib/jvm/jre-1.7.0-openjdk.x86_64\nexport M2_HOME=/usr/local/maven\nexport PATH=${M2_HOME}/bin:${PATH}' > /etc/profile.d/maven.sh
source /etc/profile.d/maven.sh


echo 'The maven version: ' `mvn -version` ' has been installed.'
echo -e '\n\n!! Note you must relogin to get mvn in your path !!'
echo 'Removing the temporary directory...'
rm -r "$TEMPORARY_DIRECTORY"
echo 'Your Maven Installation is Complete.'
