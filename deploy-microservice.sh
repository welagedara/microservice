DOCKER_MACHINE_NAME=microservice
IMAGE_NAME=com.example/microservice
CONTAINER_NAME=microservice-default
MYSQL_ROOT_PASSWORD=root

dockerMachineIp=$(docker-machine ip $DOCKER_MACHINE_NAME)
tag=$(git rev-parse --short HEAD)

echo "Removing existing Containers"
containerId=`docker ps -qa --filter "name=$CONTAINER_NAME"`
if [ -n "$containerId" ]
then
   echo "Stopping and removing an existing container"
   docker stop $CONTAINER_NAME
   docker rm -f $CONTAINER_NAME
fi

echo "Removing existing Images"
docker rmi $IMAGE_NAME:$tag 2>/dev/null

# Build the Image using Gradle Plugin
echo "Building Docker Image"
./gradlew build -Ptag=$tag docker

echo "Running the Container"
docker run -d --name=$CONTAINER_NAME -p 8080:8080 -e DOCKER_MACHINE_HOST=$dockerMachineIp -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD -t $IMAGE_NAME:$tag

echo "Listing the Containers"
docker ps

echo "App running on http://$dockerMachineIp:8080"