# kibana

For first time setup
1. Comment out the volume arguments in ./build_and_deploy
1. `./build_and_deploy.sh`
1. SSH into the system
1. Grab the container_id `docker ps`
1. Visit the hosted Kibana website found from `docker logs <container_id>`
1. Paste into the website the enrollment token created from elastic, (regenerate with `docker exec -it <container_id> /usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s kibana`)
1. Copy the config from the container `docker cp <container_id>:/usr/share/kibana/config /var/kibana`
1. Copy the data from the container `docker cp <container_id>:/usr/share/kibana/data /var/kibana`
1. Stop and remove the container `docker stop <container_id> && docker container rm <container-id>`
1. Add the volume arguments back into ./build_and_deploy
1. rerun `./build_and_deploy.sh`