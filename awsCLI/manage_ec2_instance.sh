#!/bin/bash

# Check if correct number of arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <instance-id> <action>"
    echo "Actions: start | stop | reboot"
    exit 1
fi

INSTANCE_ID=$1
ACTION=$2

# Validate the action
if [[ "$ACTION" != "start" && "$ACTION" != "stop" && "$ACTION" != "reboot" ]]; then
    echo "Invalid action: $ACTION"
    echo "Actions must be one of: start | stop | reboot"
    exit 1
fi

# Perform the action
if [ "$ACTION" == "start" ]; then
    aws ec2 start-instances --instance-ids $INSTANCE_ID
    echo "Starting instance: $INSTANCE_ID"

elif [ "$ACTION" == "stop" ]; then
    aws ec2 stop-instances --instance-ids $INSTANCE_ID
    echo "Stopping instance: $INSTANCE_ID"

elif [ "$ACTION" == "reboot" ]; then
    aws ec2 reboot-instances --instance-ids $INSTANCE_ID
    echo "Rebooting instance: $INSTANCE_ID"
fi
