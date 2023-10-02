#!/bin/bash
echo "########## Terraform Destroy ##########"
terraform -chdir=log-analytics-test destroy -auto-approve
echo "########## Terraform Destroy Complete ##########"

echo "########## Terraform Destroy Bootstrap ##########"
terraform -chdir=log-analytics-test-bootstrap destroy -auto-approve
echo "########## Terraform Destroy Bootstrap Complete ##########"
