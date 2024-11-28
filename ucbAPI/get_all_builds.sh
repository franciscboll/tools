#!/bin/bash

# Source the environment variables from the config file
if [ -f ./config.env ]; then
    echo "Loading environment variables from config.env"
    echo ""
    source ./config.env
else
    echo "Error: config.env file not found."
    exit 1
fi

# Set API-related variables
API_TOKEN="${UNITY_API_TOKEN}"  # API token from config.env
ORG_ID="${UNITY_ORG_ID}"        # Organization ID from config.env
API_ENDPOINT="https://build-api.cloud.unity3d.com/api/v1"
AUTH_HEADER="Authorization: Basic $API_TOKEN"

# Function to list all builds for the organization
list_org_builds() {
    echo "Fetching the list of builds for the organization..."
    echo ""
    local REQUEST_URL="$API_ENDPOINT/orgs/$ORG_ID/builds?per_page=10&page=1"
    echo "Request URL: $REQUEST_URL"
    echo ""
    RESPONSE=$(curl -s -w "\n%{http_code}" -H "$AUTH_HEADER" "$REQUEST_URL")
    HTTP_STATUS=$(echo "$RESPONSE" | tail -n1)
    BUILDS=$(echo "$RESPONSE" | sed '$d')

    if [ "$HTTP_STATUS" -ne 200 ]; then
        echo "Error: Failed to fetch builds. HTTP Status: $HTTP_STATUS"
        echo ""
        exit 1
    fi

    # Validate JSON
    if ! echo "$BUILDS" | jq empty; then
        echo "Error: Invalid JSON response"
        echo ""
        exit 1
    fi

    # Process the output
    echo "$BUILDS" | jq -r '.[] | "\(.buildtargetid) \(.projectName) \(.buildStatus)"' | while read -r build project status; do
        echo -e "${color}Build: $build, Project: $project, Status: $status${NC}"
    done
}

# Execute the list_org_builds function
echo "Executing list_org_builds function"
echo ""
list_org_builds
echo ""
echo "Completed list_org_builds function"



