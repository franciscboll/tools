#!/bin/bash

# Fetch cost data grouped by service

# Specify start and end dates for the report
START_DATE=$(date -d "2024-11-01" '+%Y-%m-%d')
END_DATE=$(date '+%Y-%m-%d')

# Fetch cost data grouped by service
aws ce get-cost-and-usage \
  --time-period Start=$START_DATE,End=$END_DATE \
  --granularity MONTHLY \
  --metrics "UnblendedCost" \
  --group-by Type=DIMENSION,Key=SERVICE \
  --query "ResultsByTime[0].Groups[*].[Keys[0], Metrics.UnblendedCost.Amount]" \
  --output table

 # Fetch total cost for the period
TOTAL_BILLING=$(aws ce get-cost-and-usage \
  --time-period Start=$START_DATE,End=$END_DATE \
  --granularity MONTHLY \
  --metrics "UnblendedCost" \
  --query "ResultsByTime[0].Total.UnblendedCost.Amount" \
  --output text)

# Convert TOTAL_BILLING to a float and round to 2 decimal places
TOTAL_BILLING=$(echo "$TOTAL_BILLING" | awk '{printf "%.2f", $1}')

# Format total billing output with dollar sign and color (green)
echo -e "\nTotal Billing for the Period: \e[32m\$$TOTAL_BILLING\e[0m"