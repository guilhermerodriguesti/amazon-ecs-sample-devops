# amazon-ecs-sample-devops

# Replace ecs-deploy.sh | AWS_ACCESS_KEY_ID | AWS_SECRET_ACCESS_KEY | KEY PAIR
   
   ecs-cli configure profile --profile-name wordpress --access-key $AWS_ACCESS_KEY_ID --secret-key $AWS_SECRET_ACCESS_KEY
   
   cat <<EOF > ecs-tutorial.pem
-----BEGIN RSA PRIVATE KEY-----
        -YOUR KEY-
-----END RSA PRIVATE KEY-----
EOF
