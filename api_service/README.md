# Deploying image and Redeploying

## Deploying an image (Push to AWS Lightsail Containers repository)

For our case, terraform will run all the commands needed to deploy the image to AWS Lightsail Containers, but if we need to do it manually we can run these commands:

1. Docker build -t name_of_the_docker_image .
2. aws lightsail push-container-image --service-name name_of_the_container_service_name --label name_of_the_container_flag --region name_of_the_region --image name_of_the_docker_image

## Redeploying an image.

Whenever we develop a new feature and we want to deploy it to our flask-api that is running inside our Lightsail Container, we use the same commands as before. We rebuild our docker image (1) and finally we push the image to our AWS Lighstail Containers repository (2).