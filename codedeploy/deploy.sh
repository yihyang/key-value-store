#!/bin/bash
obj="ec2_dev"
zip -r deploy.zip appspec.yml image_version.txt scripts
aws s3 cp deploy.zip s3://carro-codedeploy/automation/${obj}/app/deploy.zip --metadata x-amz-meta-application-name=app,x-amz-meta-deploymentgroup-name=${obj}
