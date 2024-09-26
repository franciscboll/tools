#!/bin/bash

# Source the environment variables from the config file
if [ -f ./config.env ]; then
    source ./config.env
else
    echo "Error: config.env file not found."
    exit 1
fi

# Ensure the API token and organization ID are sourced from config.env
API_TOKEN="${UNITY_API_TOKEN}"
ORG_ID="${UNITY_ORG_ID}"

# Check if API token and org ID are provided
if [ -z "$API_TOKEN" ] || [ -z "$ORG_ID" ]; then
    echo "Error: API token or organization ID not provided in config.env."
    exit 1
fi

# Define a function to fetch Unity Cloud Build information
unity_cloud_build_info() {
    local API_TOKEN="$1"
    local ORG_ID="$2"
    local AUTH_HEADER="Authorization: Basic $API_TOKEN"
    local API_ENDPOINT="https://build-api.cloud.unity3d.com/api/v1"

    # Get request for projects list for the development team
    PROJECTS_LIST=$(curl -s -H "$AUTH_HEADER" "$API_ENDPOINT/orgs/$ORG_ID/projects")

    # Check if API request was successful
    if [ $? -ne 0 ]; then
        echo -e "\e[91mFailed to retrieve projects list. Please check your API token and network connection.\e[0m"
        exit 1
    fi

    # Parse the JSON response and extract project names as a single string
    project_names=$(echo "$PROJECTS_LIST" | jq -r '[ .[].name ] | join("\n")')

    # Count the number of projects
    local num_projects=$(echo "$project_names" | wc -l)

    # Check if any projects are found
    if [ $num_projects -eq 0 ]; then
        echo -e "\e[93mNo projects found for the development team.\e[0m"
        exit 0
    fi

    # Print the number of projects and list of project names for the development team
    echo -e "\e[96mNumber of Projects: $num_projects\e[0m"
    echo -e "\e[92mCurrent Projects of the Development Team:\e[0m"
    echo "$project_names" | sed 's/^/- /'
}

# Main execution starts here

# Call the function to fetch Unity Cloud Build information using the API token and org ID
unity_cloud_build_info "$API_TOKEN" "$ORG_ID"
