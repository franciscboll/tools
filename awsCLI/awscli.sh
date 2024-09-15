#!/bin/bash

# List EC2 instances with instance ID and state
aws ec2 describe-instances --query "Reservations[*].Instances[*].[InstanceId, State.Name]" --output table

#!/bin/bash

# Fetch cost data grouped by service

# Specify start and end dates for the report
START_DATE=$(date -d "first day of this month" '+%Y-%m-%d')
END_DATE=$(date '+%Y-%m-%d')

# Fetch cost data grouped by service
aws ce get-cost-and-usage \
  --time-period Start=$START_DATE,End=$END_DATE \
  --granularity MONTHLY \
  --metrics "UnblendedCost" \
  --group-by Type=DIMENSION,Key=SERVICE \
  --query "ResultsByTime[0].Groups[*].[Keys[0], Metrics.UnblendedCost.Amount]" \
  --output table