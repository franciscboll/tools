#!/bin/bash

# Source the environment variables from the config file
if [ -f ./config.env ]; then
    source ./config.env
else
    echo "Error: config.env file not found."
    exit 1
fi

# Ensure the API token is sourced from config.env
API_TOKEN="${UNITY_API_TOKEN}"
ORG_ID="${UNITY_ORG_ID}"

# Check if project name is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <Project Name>"
    exit 1
fi

PROJECT_NAME="$1"

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

# Define the function to get project info and list build targets
unity_cloud_build_info() {
    local API_TOKEN="$1"
    local PROJECT_ID="$2"
    local AUTH_HEADER="Authorization: Basic $API_TOKEN"
    local API_ENDPOINT="https://build-api.cloud.unity3d.com/api/v1"

    # Get build targets for the project
    targets_response=$(curl -s -H "$AUTH_HEADER" "$API_ENDPOINT/orgs/$ORG_ID/projects/$PROJECT_ID/buildtargets")

    # Check if the request was successful
    if [[ $? -eq 0 ]]; then
        # Parse the JSON response and extract build target names
        target_names=($(echo "$targets_response" | jq -r '.[] | .name'))

        # Print the list of build targets for the current project
        echo "Build Targets:"
        for target in "${target_names[@]}"; do
            echo "$target"
        done
    else
        echo "Failed to retrieve build targets for Project ID: $PROJECT_ID"
    fi
}

# Get the project ID for the given project name
get_project_id "$PROJECT_NAME"

# Call the function to get project info with the retrieved project ID
unity_cloud_build_info "$API_TOKEN" "$PROJECT_ID"
