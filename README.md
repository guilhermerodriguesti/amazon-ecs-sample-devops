# amazon-ecs-sample-devops

1 - Replace ecs-deploy.sh with:
   a.AWS_ACCESS_KEY_ID
   b.AWS_SECRET_ACCESS_KEY
   c.KEY PAIR
   
   ecs-cli configure profile --profile-name wordpress --access-key $AWS_ACCESS_KEY_ID --secret-key $AWS_SECRET_ACCESS_KEY
   
   cat <<EOF > ecs-tutorial.pem
-----BEGIN RSA PRIVATE KEY-----
        -YOUR KEY-
-----END RSA PRIVATE KEY-----
EOF
