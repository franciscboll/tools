# AWS CLI Automation Scripts

This folder, awsCLI, contains shell scripts designed to interact with your AWS account using the AWS Command Line Interface (CLI). These scripts can automate monitoring tasks such as checking the state of EC2 instances, retrieving billing data, and more.

# Scripts Overview

1. List EC2 Instances and Their States
Script: ***list_ec2_instances.sh***

This script lists all your EC2 instances along with their current state (e.g., running, stopped).

2. Fetch Current Billing and Pricing Data by AWS Service
Script: ***fetch_billing_data.sh***

This script retrieves the current month’s billing details, including costs per AWS service and the total billing amount.

3. EC2 Instance Management Script
Script: ***manage_ec2_instance.sh***

This script allows you to manage the state of your EC2 instances by starting, stopping, or rebooting them using the AWS CLI.

### Usage

The script takes two arguments:

1. **Instance ID**: The ID of the EC2 instance you want to manage.
2. **Action**: The action to perform: `start`, `stop`, or `reboot`.

**Start an EC2 instance**:
   bash ./manage_ec2_instance.sh i-1234567890abcdef0 start

**Stop an EC2 instance**
   bash ./manage_ec2_instance.sh i-1234567890abcdef0 stop

**Reboot an EC2 instance**
   bash ./manage_ec2_instance.sh i-1234567890abcdef0 reboot

4. List All S3 Buckets and Their Sizes
Script: ***list_s3_buckets_sizes.sh***

This script lists all the S3 buckets in your AWS account and calculates the total size of each bucket. The sizes are displayed in a human-readable format (MB, GB).

5. Automate S3 Bucket Backup
Script: ***backup_s3_bucket.sh***

This script copies the contents of one S3 bucket to another (for backup purposes). It can be run periodically (e.g., via a cron job) to back up a bucket.

### Usage

Replace your-source-bucket and your-backup-bucket with the appropriate bucket names.