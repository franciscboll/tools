# AWS CLI Scripts

This folder contains shell scripts designed to interact with your AWS account using the AWS CLI. These scripts can automate monitoring tasks such as checking the state of EC2 instances, retrieving billing data, and more.

#### Scripts Overview

###### 1. List EC2 Instances and Their States

Script: **_list_ec2_instances.sh_**

lists all your EC2 instances along with their current state (e.g., running, stopped).

###### 2. Fetch Current Billing and Pricing Data by AWS Service

Script: **_fetch_billing_data.sh_**

retrieves the current month’s billing details, including costs per AWS service and the total billing amount.

###### 3. EC2 Instance Management Script

Script: **_manage_ec2_instance.sh_**

allows you to manage the state of your EC2 instances by starting, stopping, or rebooting them using the AWS CLI.

_Usage_

takes two arguments:

1. Instance ID: The ID of the EC2 instance you want to manage.
2. Action: The action to perform: `start`, `stop`, or `reboot`.

Start an EC2 instance:
bash ./manage_ec2_instance.sh i-1234567890abcdef0 start

Stop an EC2 instance
bash ./manage_ec2_instance.sh i-1234567890abcdef0 stop

Reboot an EC2 instance
bash ./manage_ec2_instance.sh i-1234567890abcdef0 reboot

###### 4. List All S3 Buckets and Their Sizes

Script: **_list_s3_buckets_sizes.sh_**

lists all the S3 buckets in your AWS account and calculates the total size of each bucket. The sizes are displayed in a human-readable format (MB, GB).

###### 5. Automate S3 Bucket Backup

Script: **_backup_s3_bucket.sh_**

copies the contents of one S3 bucket to another (for backup purposes). It can be run periodically (e.g., via a cron job) to back up a bucket.

_Usage_

To run the script, pass the bucket names as arguments:

./backup_s3_bucket.sh your-source-bucket your-backup-bucket

###### 6. Diagnose EC2 Instance Health

Script: **_diagnose_ec2_instance.sh_**

Performs a quick health check of an EC2 instance. Useful for identifying common issues with performance, connectivity, disk usage, and service status.

Checks Included:

- System info (hostname, uptime)

- CPU and memory usage

- Disk space and heavy directories

- Network interfaces, ping test, open ports

- Key service statuses (nginx, apache2, docker, sshd)

- Recent system logs

- Kernel messages (dmesg)

- Logged-in users and recent access

- Firewall rules (iptables)

_Usage_

copy the script inside the ec2

bash ./diagnose_ec2_instance.sh
