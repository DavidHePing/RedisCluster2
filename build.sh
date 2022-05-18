# show variable when run ci/cd
set -x

DockerHubUrl="localhost:5000"
ProjectName=$1
Tag=$2
ImageName=""

if [ -z "$1" ]; then
    echo "ProjectName NOT ALLOW empty"
    exit
fi	

if [ -z "$2" ]; then
    echo "Tag NOT ALLOW empty"
    exit
fi

ImageName="$DockerHubUrl/${ProjectName}:${Tag}"

echo "ImageName=$ImageName"

# build cache
docker builder prune -f
# Stagimage
docker image prune -f

docker build redis -t "$ImageName" . &&
docker image push "$ImageName"
