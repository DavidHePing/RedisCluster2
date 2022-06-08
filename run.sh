# show variable when run ci/cd
set -x

DockerHubUrl="localhost:5000"
ProjectName=$1
Tag=$2
ImageName=""
Ip=""
StackNname="$1_stack"

if [ -z "$1" ]; then
    echo "ProjectName NOT ALLOW empty"
    exit
fi	

if [ -z "$2" ]; then
    echo "Tag NOT ALLOW empty"
    exit
fi

ImageName="$DockerHubUrl/${ProjectName}:${Tag}"
# Ip=$(hostname -I | awk '{print $1}')
Ip=192.168.50.88

# execute as a subcommand in order to avoid the variables remain set
(
	export ProjectName=$ProjectName
	export ImageName=$ImageName
	export Ip=$Ip
		
	docker image pull "$ImageName"	

	# creat external network
	# findnw=$(docker network ls | grep myNetWork |wc -l)
	# if [[ $findnw < 1 ]]; then	
	# 	docker network create -d overlay --attachable "myNetWork"
	# fi	
	
	docker stack deploy -c docker-compose.yml $StackNname
)
