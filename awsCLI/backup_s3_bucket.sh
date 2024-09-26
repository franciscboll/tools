#!/bin/bash

# Check if the required arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <source_bucket> <backup_bucket>"
    exit 1
fi

# Variables from arguments
source_bucket=$1
backup_bucket=$2
current_date=$(date +'%Y-%m-%d')

# Check if the backup bucket exists, create if it doesn't
if ! aws s3api head-bucket --bucket $backup_bucket 2>/dev/null; then
    echo "Backup bucket doesn't exist, creating it..."
    aws s3 mb s3://$backup_bucket
fi

# Sync the source bucket to the backup bucket
echo "Backing up bucket: $source_bucket to $backup_bucket/$current_date/..."
aws s3 sync s3://$source_bucket s3://$backup_bucket/$current_date/

echo "Backup completed."
