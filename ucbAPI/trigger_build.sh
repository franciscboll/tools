#!/bin/bash

# Load API_TOKEN and UNITY_ORG_ID from config.env
source config.env

# Check if API_TOKEN and UNITY_ORG_ID are set
if [ -z "$UNITY_API_TOKEN" ] || [ -z "$UNITY_ORG_ID" ]; then
    echo "Error: API_TOKEN or UNITY_ORG_ID is not set. Please ensure config.env is correctly configured."
    exit 1
fi

# Project name and build target
PROJECT_NAME=$1
BUILD_TARGET=$2

# API Endpoint
API_ENDPOINT="https://build-api.cloud.unity3d.com/api/v1"

# Function to fetch Project GUID by Project Name
get_project_guid() {
    local project_name="$1"
    local auth_header="Authorization: Basic $UNITY_API_TOKEN"
    local request_url="$API_ENDPOINT/orgs/$UNITY_ORG_ID/projects"

    # Make API request to fetch the list of projects
    projects=$(curl -s -H "$auth_header" "$request_url")

    # Check if the request was successful
    if [ $? -ne 0 ]; then
        echo "Error: Failed to fetch projects from Unity Cloud Build API."
        exit 1
    fi

    # Extract the Project GUID for the specified project name
    project_guid=$(echo "$projects" | jq -r --arg project_name "$project_name" '.[] | select(.name == $project_name) | .guid')

    # Check if the GUID was found
    if [ -z "$project_guid" ]; then
        echo "Error: Project '$project_name' not found."
        exit 1
    fi

    echo "$project_guid"
}

# Function to trigger a build
trigger_build() {
    local project_guid="$1"
    local build_target="$2"
    local auth_header="Authorization: Basic $UNITY_API_TOKEN"
    local request_url="$API_ENDPOINT/orgs/$UNITY_ORG_ID/projects/$project_guid/buildtargets/$build_target/builds"

    # Make API request to trigger the build
    response=$(curl -s -w "\n%{http_code}" -X POST -H "$auth_header" -H "Content-Type: application/json" "$request_url")
    http_code=$(echo "$response" | tail -n1)
    response_body=$(echo "$response" | sed '$d')

    # Check if the request was successful
    if [ "$http_code" -ne 200 ]; then
        error_message=$(echo "$response_body" | jq -r '.error // empty')
        echo "Error: Failed to trigger build for project GUID '$project_guid' and build target '$build_target'. HTTP Status: $http_code. Error: $error_message"
        exit 1
    fi

    # Check if the response is an array or an object
    if echo "$response_body" | jq -e 'type == "array"' > /dev/null; then
        build_status=$(echo "$response_body" | jq -r '.[0].buildStatus // empty')
    else
        build_status=$(echo "$response_body" | jq -r '.buildStatus // empty')
    fi

    echo "Build triggered successfully for project GUID '$project_guid' and build target '$build_target'."
    echo "Build Status: $build_status"
}

# Main script logic
if [ -z "$PROJECT_NAME" ] || [ -z "$BUILD_TARGET" ]; then
    echo "Usage: $0 <project_name> <build_target>"
    exit 1
fi

# Fetch the project GUID
project_guid=$(get_project_guid "$PROJECT_NAME")

# Trigger the build
trigger_build "$project_guid" "$BUILD_TARGET"