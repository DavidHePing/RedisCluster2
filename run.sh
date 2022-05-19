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
Ip=$(hostname -I | awk '{print $1}')

# execute as a subcommand in order to avoid the variables remain set
(
	export ProjectName=$ProjectName
	export ImageName=$ImageName
	export Ip=$Ip
		
	docker image pull "$ImageName"	
	
	docker stack deploy -c docker-compose.yml $StackNname
)
