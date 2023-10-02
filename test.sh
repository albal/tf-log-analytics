#!/bin/bash
set -e

echo "########## Terraform Bootstrap ##########"
terraform -chdir=log-analytics-test-bootstrap apply -auto-approve
echo "########## Terraform Bootstrap Complete ##########"

echo "########## Terraform Apply ##########"
terraform -chdir=log-analytics-test apply -auto-approve
echo "########## Terraform Apply Complete ##########"

echo "########## Curl 100 times ##########"
pip=$(terraform output -raw -state=log-analytics-test/terraform.tfstate pip1)
for i in {100..1}; 
do
  curl -s -k https://${pip} > /dev/null
  echo -en "\r${i}   "
done
echo -e "\r########## Curl Complete ##########"

echo "########## Terraform Destroy ##########"
terraform -chdir=log-analytics-test destroy -target=azurerm_monitor_diagnostic_setting.firewall-diagnostics -auto-approve
echo "########## Terraform Destroy Complete ##########"

echo "########## Terraform Apply ##########"
terraform -chdir=log-analytics-test apply -auto-approve
echo "########## Terraform Apply Complete ##########"
