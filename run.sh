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

echo "ProjectName=$ProjectName"
echo "ImageName=$ImageName"
echo "Ip=$Ip"

# .env file docker.compose.yml
echo "ProjectName=$ProjectName" >. env # override
echo "ImageName=$ImageName" >> .env # append
echo "Ip=$Ip" >> .env # append

# execute as a subcommand in order to avoid the variables remain set
(
	# export variables excluding comments
	[ -f .env ] && export $(sed '/^#/d' .env)
	
	docker image pull "$ImageName"	

	docker-compose up -d 
	
	find=$(docker stack ls | grep $StackNname |wc -l)
	if [[ $find < 1 ]]; then
		docker stack deploy -c docker-compose.yml $StackNname
	else
		docker service update --image "$ImageName" --force "${StackNname}_my_service"
	fi
)
