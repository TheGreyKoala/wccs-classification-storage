#!/usr/bin/env bash

set -euo pipefail

function setupNeo4j() {
    timeout=30

	echo "Waiting $timeout seconds for Neo4j to come up."
	end="$((SECONDS+timeout))"

	while true
	do
	    [[ "200" = "$(curl --silent --write-out %{http_code} --output /dev/null http://localhost:7474)" ]] && break
	    [[ "${SECONDS}" -ge "${end}" ]] && echo "Neo4j did not come up after $timeout seconds." && exit 1
	    sleep 1
	done

    echo "Creating unique node property constraint :Text(value)"
    /var/lib/neo4j/bin/cypher-shell -u neo4j -p $(echo $NEO4J_AUTH | cut -f2 -d/) "CREATE CONSTRAINT ON (t:Text) ASSERT t.value IS UNIQUE"

    echo "Creating unique node property constraint :Content(checksum)"
    /var/lib/neo4j/bin/cypher-shell -u neo4j -p $(echo $NEO4J_AUTH | cut -f2 -d/) "CREATE CONSTRAINT ON (c:Content) ASSERT c.checksum IS UNIQUE"

	echo "Creating unique node property constraint :Resource(url)"
	/var/lib/neo4j/bin/cypher-shell -u neo4j -p $(echo $NEO4J_AUTH | cut -f2 -d/) "CREATE CONSTRAINT ON (r:Resource) ASSERT r.url IS UNIQUE"

	echo "Creating unique node property constraint :Site(id)"
	/var/lib/neo4j/bin/cypher-shell -u neo4j -p $(echo $NEO4J_AUTH | cut -f2 -d/) "CREATE CONSTRAINT ON (s:Site) ASSERT s.id IS UNIQUE"

	# Property existence is required to ensure that each node labeled 'page' has a property 'url'.
	# But this feature is not available in the community edition.
}

setupNeo4j &
/docker-entrypoint.sh $@
