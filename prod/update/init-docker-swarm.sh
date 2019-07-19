docker run -d -p 5000:5000 --restart=always --name registry registry:2
docker swarm init

./update-t4d-app.sh

docker service scale t4d-app_web=2
