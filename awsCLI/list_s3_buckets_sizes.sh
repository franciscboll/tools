#!/bin/bash

# List all S3 buckets and calculate their sizes

echo "Retrieving S3 bucket list..."

buckets=$(aws s3api list-buckets --query "Buckets[].Name" --output text)

for bucket in $buckets; do
    echo "Processing bucket: $bucket"
    
    # Calculate total size of the bucket in bytes
    size_in_bytes=$(aws s3api list-objects --bucket $bucket --query "[sum(Contents[].Size)]" --output text)
    
    # Convert size to human-readable format (MB, GB)
    if [[ $size_in_bytes != "None" ]]; then
        size_in_mb=$((size_in_bytes / 1024 / 1024))
        if [ $size_in_mb -gt 1024 ]; then
            size_in_gb=$(echo "scale=2; $size_in_mb / 1024" | bc)
            echo "Bucket: $bucket, Size: $size_in_gb GB"
        else
            echo "Bucket: $bucket, Size: $size_in_mb MB"
        fi
    else
        echo "Bucket: $bucket is empty."
    fi
    
    echo ""
done
