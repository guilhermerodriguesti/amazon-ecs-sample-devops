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

cat <<EOF > ecs-tutorial.pem
-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAgLSDK/D4E9klD9JGt8pVyRKgZSExVPtpQ62h7as+FTSo3H4c
XHPjWpELXvGSpljmCo5aSrojh+bN1ON03FvUZ3HTp5SV7chuapuZym0vIYswt0Rj
ubHEMTtIeCuEZPJDrWlRryqmbie5+QUK1a8Um3/IOC/yAKqCtY1HPJGu7XnVfowY
H7OahKa/Rw9RY0lHIsk6OnB7OBGhy5ELMbUgyHcmhCTMb0aoyWJEZsNMGCbLk8oj
8n+rWKhf7f3aRVnbeTFkUzMJNOiuo1kXdaek1w5LAetdIdo19i3Cf8xo92uHUBzL
AUVqo/lWY5+ywugm70NYb5CLySckqCrCK/5rnQIDAQABAoIBAFnlu/llRuIWOhzi
8yJM4b6glAgPNzX0pYHwNbqccbC+J3RbYdPx3kvUI+0dLyGh1oxpAghQG6FBRWP9
vBJu0d2vU/cpgc+kv/sW1ETgHpt/bXeU/VMnJ7J7hhLp0n/v9/WYKsX/NGCcvvmA
3CCFOg+jIWadlpuAfevx0mAsIdMc2IfX/ZiyCbMf+sIhsZ9XCmf4qJz1v+X8Xwj+
qm4Lm2sUB/02jI7veNzPQgpw6PqoPQ67abNZvPzwOs2Rq7bffw8qzM235hNBmSiE
2Oz3DES4K+VOr5ELb9xmnUtqVSeJV2RinmZ885BvpEslW0vpjSaOH16UlaadBuEE
ky+BcsECgYEAvTDseIo82EnXUd28LdV4Vi057Qe8pstaOPvVAHO1zYFVLYHgWv6u
SW0ZBNJbfsoFAciiWCy0I3PYB/zSNO48HUv29lQ5hrucB3mf5p0lnBGfQaPeb/ca
DHNPoh1tAW59j9izV4Gh6+C0PRO/rB6sSt5svJZl0vnfr0RdeyahrLsCgYEArieX
ijHJPsGDBiP/i1gUiHP6DAaZLruocDVOaSk/yXFHziQwKoqn5fVACdaDnGKGxGLG
fCSfryNJL8c5dpWZdZ3T0c6hLCdLJuH45FS0idLrlpRlCUPVL0iUnB9mSoh9ljcc
ICR8Pz9FKXKKABo60x4EqE3qRfH7ak4sXsyyL4cCgYA3u3PNxptJ8+a0PSe0MNB0
Qnpv8vmGAR2g7769lViXI2ReNYZMB/57ruHR484EOarj7aC1bOXcE8IuCDI8WXnn
/3rO8dzIbff208NhAiYUJbTOd2GNhjNsO4PX8+cqpsviVinuu0dh3x35aBnssFR8
8a0CmSOB1Q4p6W/IWYcDBQKBgGEOl5ng3TMoTYkijsxtriPN3tDM7Jnq45iFXMmm
v3HYvBfaey16UNALukDBWF/TWSAhnFSbZJMKq0MBWLkJ7php+R64dYJR88Qbs8Ys
nuEgt0MYOKbNMwZDAO9xYGSxZKxO0lHng4cMD9Nljhs4gwgddqMFqUaJ8X/xSTEc
C0IJAoGBAKE3qPFz9jtPxT+mOYs/CFfrblLIdTJMLMJCKlKruJtQjs62+8yKgf2j
60ygFdHekNrBiiESikq5FGos5VkRYeZutM/7UyhVUUgmrH3i/l2S/BZLXCeCYFu+
B/rk3RHc0z6JodquX2Dx3jjOPdJLrDNk99I7S0tpgXVYpZzay39L
-----END RSA PRIVATE KEY-----
EOF

ecs-cli configure --cluster ecs-tutorial --default-launch-type EC2 --config-name ecs-tutorial --region us-east-1

ecs-cli configure profile --profile-name ecs-tutorial-profile --access-key AKIA5AFRSKL5JMJBKMCX --secret-key qCoJQAflriV/woiTDydN+wOwVdZ8th275j1YzaP6
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

sleep 20 

echo "Step 9: Clean Up"

ecs-cli compose service rm --cluster-config ecs-tutorial --ecs-profile ecs-tutorial-profile

ecs-cli down --force --cluster-config ecs-tutorial --ecs-profile ecs-tutorial-profile
