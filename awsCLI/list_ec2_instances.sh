#!/bin/bash

# List EC2 instances with instance ID and state
aws ec2 describe-instances --query "Reservations[*].Instances[*].[InstanceId, State.Name]" --output table