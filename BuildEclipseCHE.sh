#!/bin/bash
PATH_TO_CHE=${1}
if [ -z "${PATH_TO_CHE}" ]; then
	echo "You should set up PATH to Eclipse CHE source code, like argument for this script."
	exit 1;
fi
# Run Docker container to build Eclipse CHE. Source code will be mounted to the docker container (-v params). Inside container will be executed command: 
# which goes to the mounted source code folder, build it with skip tests and skip sources validation to speed up. --rm flags means that container will be
# removed after build.
docker run --rm -v "${PATH_TO_CHE}":/che aandrienko/build-che bash -c "cd /che && mvn clean install -DskipTests -Dskip-validate-sources"
