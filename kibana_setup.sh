#!/bin/bash

KIBANA_CONTAINER_ID=$(ssh "$PI_USER@$DB_IP" "docker ps -qf 'name=kibana'")
LOG_URL=$(ssh "$PI_USER@$DB_IP" "docker logs --tail 3 $KIBANA_CONTAINER_ID | grep code")
READABLE_URL="${LOG_URL//0.0.0.0/$DB_IP}"
echo $READABLE_URL


echo "Then paste in the follow code (may take a second to generate)"
ELASTIC_CONTAINER_ID=$(ssh "$PI_USER@$DB_IP" "docker ps -qf 'name=elasticsearch'")
KIBANA_TOKEN=$(ssh "$PI_USER@$DB_IP" "docker exec '$ELASTIC_CONTAINER_ID' /usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s kibana")
echo $KIBANA_TOKEN

read -p "Press enter after Kibana sucessfully configures itself..."

ssh $PI_USER@$DB_IP << 'EOF'

KIBANA_CONTAINER_ID=$(docker ps -qf 'name=kibana')

sudo docker cp -a "$KIBANA_CONTAINER_ID":/usr/share/kibana/config /var/kibana
sudo docker cp -a "$KIBANA_CONTAINER_ID":/usr/share/kibana/data /var/kibana

NEW_LINE='server.basePath: "/kibana"'
FILE_TO_MOD="/var/kibana/config/kibana.yml"

if ! sudo grep -qxF "$NEW_LINE" "$FILE_TO_MOD"; then
    (echo ""; echo "$NEW_LINE") | sudo tee -a "$FILE_TO_MOD" >/dev/null
fi

docker stop "$KIBANA_CONTAINER_ID"
docker container rm "$KIBANA_CONTAINER_ID"

EOF

echo "This script has completed."