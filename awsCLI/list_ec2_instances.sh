#!/bin/bash

# Fetch all EC2 instances and display instance ID, Name tag (if available), and state
aws ec2 describe-instances \
  --query 'Reservations[*].Instances[*].[InstanceId, State.Name, Tags[?Key==`Name`].Value | [0]]' \
  --output table