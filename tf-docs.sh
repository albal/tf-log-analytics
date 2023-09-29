#!/bin/bash
echo "# Main Terraform" > README.md
terraform-docs markdown table log-analytics-test >> README.md
echo "# Bootstrep Terraform" >> README.md
terraform-docs markdown table log-analytics-test-bootstrap >> README.md
