#!/bin/bash

# Source the environment variables from the config file
if [ -f ./config.env ]; then
    source ./config.env
else
    echo "Error: config.env file not found."
    exit 1
fi

# Define your variables
API_TOKEN="${UNITY_API_TOKEN}"  # Get the API token from the config file
ORG_ID="${UNITY_ORG_ID}"        # Get the Organization ID from the config file

# Function to get project ID by name
get_project_id() {
    local PROJECT_NAME="$1"
    local AUTH_HEADER="Authorization: Basic $API_TOKEN"
    local API_ENDPOINT="https://build-api.cloud.unity3d.com/api/v1"

    # Construct API request URL
    local REQUEST_URL="$API_ENDPOINT/orgs/$ORG_ID/projects"

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

    echo "Found Project ID: $PROJECT_ID"
}

# Function to get environment variables for a build target
get_build_target_env_vars() {
    local API_TOKEN="$1"
    local ORG_ID="$2"
    local PROJECT_ID="$3"
    local TARGET_ID="$4"
    local AUTH_HEADER="Authorization: Basic $API_TOKEN"
    local API_ENDPOINT="https://build-api.cloud.unity3d.com/api/v1"

    # Construct API request URL
    local REQUEST_URL="$API_ENDPOINT/orgs/$ORG_ID/projects/$PROJECT_ID/buildtargets/$TARGET_ID/envvars"

    echo -e "\nFetching environment variables for Build Target $TARGET_ID..."
    echo -e "\nAPI Request URL: $REQUEST_URL"

    # Make GET request to fetch environment variables for the specified build target
    ENV_VARS=$(curl -s -H "$AUTH_HEADER" "$REQUEST_URL")

    # Check if API request was successful
    if [ $? -ne 0 ]; then
        echo -e "Error: Failed to execute API request."
        exit 1
    fi

    # Check if API response contains an error
    ERROR=$(echo "$ENV_VARS" | jq -r '.error')
    if [ "$ERROR" != "null" ]; then
        echo -e "API Error: $ERROR"
        exit 1
    fi

    # Print the retrieved environment variables
    echo -e "\nEnvironment variables for Build Target $TARGET_ID:"
    ENV_VARS=$(echo "$ENV_VARS" | jq .)
    echo "$ENV_VARS"
}

# Check if correct number of arguments is provided
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <Project Name> <Target ID>"
    exit 1
fi

# Fetch arguments
PROJECT_NAME="$1"
TARGET_ID="$2"

# Get project ID from the project name
get_project_id "$PROJECT_NAME"

# Get build target env vars
get_build_target_env_vars "$API_TOKEN" "$ORG_ID" "$PROJECT_ID" "$TARGET_ID"
