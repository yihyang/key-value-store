#!/bin/bash

# Create application
aws deploy create-application --application-name key-value-store --compute-platform Server --region ap-southeast-1

# Create group deployment
# Target instance with tag: Key=Name,Value=ec2-dev
aws deploy create-deployment-group --application-name key-value-store --deployment-group-name ec2_dev --ec2-tag-filters Key=Name,Value=ec2-dev,Type=KEY_AND_VALUE --service-role-arn arn:aws:iam::123456789012:role/CodeDeployServiceRole --deployment-style deploymentType=IN_PLACE,deploymentOption=WITHOUT_TRAFFIC_CONTROL --region ap-southeast-1
