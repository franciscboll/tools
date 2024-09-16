# AWS CLI Automation Scripts

This folder, awsCLI, contains shell scripts designed to interact with your AWS account using the AWS Command Line Interface (CLI). These scripts can automate monitoring tasks such as checking the state of EC2 instances, retrieving billing data, and more.

# Scripts Overview

1. List EC2 Instances and Their States
Script: list_ec2_instances.sh

This script lists all your EC2 instances along with their current state (e.g., running, stopped).

2. Fetch Current Billing and Pricing Data by AWS Service
Script: fetch_billing_data.sh

This script retrieves the current month’s billing details, including costs per AWS service and the total billing amount.

3. EC2 Instance Management Script
Script: manage_ec2_instance.sh

This script allows you to manage the state of your EC2 instances by starting, stopping, or rebooting them using the AWS CLI.

## Usage

The script takes two arguments:

1. **Instance ID**: The ID of the EC2 instance you want to manage.
2. **Action**: The action to perform: `start`, `stop`, or `reboot`.

### Example Usage:

**Start an EC2 instance**:
   bash ./manage_ec2_instance.sh i-1234567890abcdef0 start

**Stop an EC2 instance**
   bash ./manage_ec2_instance.sh i-1234567890abcdef0 stop

**Reboot an EC2 instance**
   bash ./manage_ec2_instance.sh i-1234567890abcdef0 reboot
