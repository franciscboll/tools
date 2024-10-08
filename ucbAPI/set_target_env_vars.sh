#!/bin/bash

# Source the environment variables from the config file
if [ -f ./config.env ]; then
    source ./config.env
else
    echo "Error: config.env file not found."
    exit 1
fi

# Check if enough arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <Project Name> <Target ID>"
    exit 1
fi

PROJECT_NAME="$1"
TARGET_ID="$2"

# Function to get project ID by name
get_project_id() {
    local PROJECT_NAME="$1"
    local AUTH_HEADER="Authorization: Basic $API_TOKEN"
    local API_ENDPOINT="https://build-api.cloud.unity3d.com/api/v1"

    # Construct API request URL
    local REQUEST_URL="$API_ENDPOINT/orgs/$UNITY_ORG_ID/projects"

    # Make GET request to fetch projects
    PROJECTS=$(curl -s -H "$AUTH_HEADER" "$REQUEST_URL")

    # Check if API request was successful
    if [ $? -ne 0 ]; then
        echo -e "Error: Failed to execute API request."
        exit 1
    fi

    # Retrieve the project ID for the specified project name
    PROJECT_ID=$(echo "$PROJECTS" | jq -r --arg PROJECT_NAME "$PROJECT_NAME" '.[] | select(.name == $PROJECT_NAME) | .guid')

    # Check if project ID was found
    if [ -z "$PROJECT_ID" ]; then
        echo "Error: Project '$PROJECT_NAME' not found."
        exit 1
    fi

    echo "$PROJECT_ID"
}

# Get the project ID
API_TOKEN="${UNITY_API_TOKEN}"  # API token from config.env
ORG_ID="${UNITY_ORG_ID}"        # Organization ID from config.env

PROJECT_ID=$(get_project_id "$PROJECT_NAME")  # Get project ID based on the project name

# Building URL for request
AUTH_HEADER="Authorization: Basic $API_TOKEN"
API_ENDPOINT="https://build-api.cloud.unity3d.com/api/v1"
REQUEST_URL="$API_ENDPOINT/orgs/$ORG_ID/projects/$PROJECT_ID/buildtargets/$TARGET_ID/envvars"

# Read the modified environment variables from the file
MODIFIED_ENV_VARS=$(<envvarsfile.txt)

# Make PUT request to update environment variables and capture the response
echo -e "\nUploading modified environment variables..."
RESPONSE=$(curl -X PUT -H "$AUTH_HEADER" -H "Content-Type: application/json" -d "$MODIFIED_ENV_VARS" "$REQUEST_URL" -s)

# Check if the request was successful
if [ $? -eq 0 ]; then
    echo "Environment variables updated successfully."

    # Print the JSON response with line breaks after each comma
    echo "Response from server:"
    echo "$RESPONSE" | jq -r 'to_entries | map("\(.key): \(.value)") | .[]' | awk '{print $0","}'
else
    echo "Failed to update environment variables."
fi
