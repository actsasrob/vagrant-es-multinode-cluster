  #!/usr/bin/env bash

  # Credit to: https://blog.mapillary.com/tech/2017/01/12/scaling-down-an-elasticsearch-cluster.html

  # The script performs force relocation of all unassigned shards,
  # of all indices to a specified node (NODE variable)

  ES_HOST="http://192.168.77.21:9200/"
  TARGET_NODE="es-d2-node1"
  SOURCE_NODE="es-d3-node1"

  curl ${ES_HOST}/_cat/shards > shards
  grep "${SOURCE_NODE}" shards > unassigned_shards

  # Now move all shard in the unnasigned_shards file onto the target node
  while read LINE; do
    IFS=" " read -r -a ARRAY <<< "$LINE"
    INDEX=${ARRAY[0]}
    SHARD=${ARRAY[1]}

    echo "Relocating:"
    echo "Index: ${INDEX}"
    echo "Shard: ${SHARD}"
    echo "To node: ${TARGET_NODE}"

    curl -s -XPOST "${ES_HOST}/_cluster/reroute" -d "{
      \"commands\": [
         {
           \"allocate\": {
             \"index\": \"${INDEX}\",
             \"shard\": ${SHARD},
             \"node\": \"${TARGET_NODE}\",
             \"allow_primary\": true
           }
         }
       ]
    }"; echo
    echo "------------------------------"
  done <unassigned_shards

  exit 0
