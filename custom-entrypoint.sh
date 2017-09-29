#!/bin/bash -eu

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

    echo "Creating unique node property constraint :Content(value)"
    /var/lib/neo4j/bin/cypher-shell -u neo4j -p $(echo $NEO4J_AUTH | cut -f2 -d/) "CREATE CONSTRAINT ON (content:Content) ASSERT content.value IS UNIQUE"

    echo "Creating unique node property constraint :Property(checksum)"
    /var/lib/neo4j/bin/cypher-shell -u neo4j -p $(echo $NEO4J_AUTH | cut -f2 -d/) "CREATE CONSTRAINT ON (property:Property) ASSERT property.checksum IS UNIQUE"

	echo "Creating unique node property constraint :Resource(url)"
	/var/lib/neo4j/bin/cypher-shell -u neo4j -p $(echo $NEO4J_AUTH | cut -f2 -d/) "CREATE CONSTRAINT ON (resource:Resource) ASSERT resource.url IS UNIQUE"

	echo "Creating unique node property constraint :Site(id)"
	/var/lib/neo4j/bin/cypher-shell -u neo4j -p $(echo $NEO4J_AUTH | cut -f2 -d/) "CREATE CONSTRAINT ON (site:Site) ASSERT site.id IS UNIQUE"

	# Property existence required to assure that each node labeled 'page' has a property 'url.
	# But this feature is not available in the community edition.
}

setupNeo4j &
/docker-entrypoint.sh $@
