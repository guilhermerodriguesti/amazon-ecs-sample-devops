#!/bin/bash

echo "Step 1: Configure the Amazon ECS CLI and ENVIRONMENTs"

cat <<EOF > docker-compose.yml
version: '3'
services:
  web:
    image: infraestruturadevops/amazon-ecs-sample
    ports:
      - "80:80"
    logging:
      driver: awslogs
      options: 
        awslogs-group: ecs-tutorial
        awslogs-region: us-east-1
        awslogs-stream-prefix: web
EOF

cat <<EOF > ecs-params.yml
version: 1
task_definition:
  services:
    web:
      cpu_shares: 100
      mem_limit: 524288000
EOF


ecs-cli configure --cluster ecs-tutorial --default-launch-type EC2 --config-name ecs-tutorial --region us-east-1

ecs-cli configure profile --profile-name ecs-tutorial-profile --access-key AKIASOSWRT24D5YJIVFK --secret-key pSaYmxiFDIBoLVuyB22ciC3ha1TDljq3SNo9r9LL
sleep 5 

echo "Step 2: Create Your Cluster"

ecs-cli up --keypair ecs-tutorial --capability-iam --size 2 --instance-type t2.medium --cluster-config ecs-tutorial --ecs-profile ecs-tutorial-profile
sleep 5
echo "Step 4: Deploy the Compose File to a Cluster"


ecs-cli compose up --create-log-groups --cluster-config ecs-tutorial --ecs-profile ecs-tutorial-profile
sleep 5

echo "Step 5: View the Running Containers on a Cluster"

ecs-cli ps --cluster-config ecs-tutorial --ecs-profile ecs-tutorial-profile

sleep 5 

echo "Step 6: Scale the Tasks on a Cluster"

ecs-cli compose scale 2 --cluster-config ecs-tutorial --ecs-profile ecs-tutorial-profile

ecs-cli ps --cluster-config ecs-tutorial --ecs-profile ecs-tutorial-profile
sleep 5 

echo "Step 7: Create an ECS Service from a Compose File"

ecs-cli compose down --cluster-config ecs-tutorial --ecs-profile ecs-tutorial-profile

ecs-cli compose service up --cluster-config ecs-tutorial --ecs-profile ecs-tutorial-profile
sleep 5 

echo "Step 8: View your Web Application"

ecs-cli ps --cluster-config ecs-tutorial --ecs-profile ecs-tutorial-profile


