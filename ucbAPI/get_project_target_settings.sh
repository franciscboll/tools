#!/bin/bash

# Source the environment variables from the config file
if [ -f ./config.env ]; then
    source ./config.env
else
    echo "Error: config.env file not found."
    exit 1
fi

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

    echo "Found Project ID: $PROJECT_ID"
}

# Function to get target settings
get_target_settings() {
    local API_TOKEN="$1"
    local TARGETED_PROJECTS=("$2")
    local INCLUDED_TARGETS=("$3")

    local AUTH_HEADER="Authorization: Basic $API_TOKEN"
    local API_ENDPOINT="https://build-api.cloud.unity3d.com/api/v1"

    # Fetch project details
    local PROJECTS_LIST=$(curl -s -H "$AUTH_HEADER" "$API_ENDPOINT/projects")
    
    local project_data=($(echo "$PROJECTS_LIST" | jq -r '.[] | .projectid, .guid'))

    for ((i = 0; i < ${#project_data[@]}; i += 2)); do
        local project_id="${project_data[i]}"
        local project_guid="${project_data[i+1]}"

        if [[ " ${TARGETED_PROJECTS[@]} " =~ " $project_id " ]]; then
            echo ""
            echo "Project ID: $project_id"
            echo "Project GUID: $project_guid"

            local targets_response=$(curl -s -H "$AUTH_HEADER" "$API_ENDPOINT/orgs/$UNITY_ORG_ID/projects/$project_guid/buildtargets")

            if [[ $? -eq 0 ]]; then
                local target_names=($(echo "$targets_response" | jq -r '.[] | .name'))
                echo "Build Targets:"
                
                for target in "${target_names[@]}"; do
                    if [[ " ${INCLUDED_TARGETS[@]} " =~ " $target " ]]; then
                        echo "$target"
                        local CURRENT_SETTINGS=$(curl -s -H "$AUTH_HEADER" "$API_ENDPOINT/orgs/$UNITY_ORG_ID/projects/$project_guid/buildtargets/$target/")
                        echo "$CURRENT_SETTINGS" | jq .
                    fi
                done
            else
                echo "Failed to retrieve build targets for Project ID: $project_id"
            fi
        fi
    done
}

# Check if enough arguments are provided
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <Targeted Projects (comma-separated)> <Included Targets (comma-separated)>"
    exit 1
fi

# Read arguments
IFS=',' read -r -a TARGETED_PROJECTS <<< "$1"
IFS=',' read -r -a INCLUDED_TARGETS <<< "$2"

# Defining API token
API_TOKEN="${UNITY_API_TOKEN}"

# Calling function and passing vars as args
get_target_settings "$API_TOKEN" "${TARGETED_PROJECTS[@]}" "${INCLUDED_TARGETS[@]}"
