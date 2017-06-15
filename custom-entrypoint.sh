#!/bin/bash -eu

function setupNeo4j() {
	echo "Waiting 10 seconds for neo4j to come up."

	end="$((SECONDS+10))"

	while true; do
	    [[ "200" = "$(curl --silent --write-out %{http_code} --output /dev/null http://localhost:7474)" ]] && break
	    [[ "${SECONDS}" -ge "${end}" ]] && echo "neo4j did not come up after 10 seconds." && exit 1
	    sleep 1
	done

	echo "Assuring Constraints"
	exit 0
}

setupNeo4j &
/docker-entrypoint.sh $@
