# kibana

For first time setup
1. Comment out the volume arguments in ./build_and_deploy.sh
1. Run `./build_and_deploy.sh`
1. Wait 10 seconds to allow the kibana container to finish setting up before moving on
1. Run `./kibana_setup.sh` and follow the instruction in the terminal
1. Add the volume arguments back into ./build_and_deploy
1. rerun `./build_and_deploy.sh`