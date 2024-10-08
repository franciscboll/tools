#!/bin/bash

# Load API_TOKEN and UNITY_ORG_ID from config.env
source config.env

# Check if API_TOKEN and UNITY_ORG_ID are set
if [ -z "$UNITY_API_TOKEN" ] || [ -z "$UNITY_ORG_ID" ]; then
    echo "Error: API_TOKEN or UNITY_ORG_ID is not set. Please ensure config.env is correctly configured."
    exit 1
fi

# Command type (trigger/stop), project name, environment/build target, and optional parameters (specific build target, stop builds)
COMMAND_TYPE=$1
PROJECT_NAME=$2
ENVIRONMENT_OR_TARGET=$3
SPECIFIC_BUILD_TARGET=$4
BUILD_NUMBER=$5 # Optional build number
STOP_ALL_BUILDS=$6 # Option to stop all builds for the environment ("stop_all")

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

# Fetch the Project GUID dynamically based on the project name
PROJECT_GUID=$(get_project_guid "$PROJECT_NAME")

# Define build targets based on the environment (for multi-build scenario)
BUILD_TARGETS=("ios-$ENVIRONMENT_OR_TARGET" "android-$ENVIRONMENT_OR_TARGET" "webgl-$ENVIRONMENT_OR_TARGET")

# Function to trigger a build for a given build target
trigger_build() {
    local build_target=$1
    local clean_build_param='{"clean":true}' # Default to true for clean builds

    echo "Triggering build for $build_target (Clean: true)..."

    # Send the build request with clean build set to true
    response=$(curl -s -X POST "$API_ENDPOINT/orgs/$UNITY_ORG_ID/projects/$PROJECT_NAME/buildtargets/$build_target/builds" \
        -H "Authorization: Basic $UNITY_API_TOKEN" \
        -H "Content-Type: application/json" \
        -d "$clean_build_param")

    # Check if curl succeeded
    if [ $? -eq 0 ]; then
        # Parse the JSON response to extract relevant information
        local build_number
        local build_status
        local created_time
        local project_name

        build_number=$(echo "$response" | jq -r '.[0].build')
        build_status=$(echo "$response" | jq -r '.[0].buildStatus')
        created_time=$(echo "$response" | jq -r '.[0].created')
        project_name=$(echo "$response" | jq -r '.[0].projectName')

        # Display the extracted information in a readable format
        echo "Build successfully triggered!"
        echo "Project Name: $project_name"
        echo "Build Number: $build_number"
        echo "Build Status: $build_status"
        echo "Created Time: $created_time"
    else
        echo "Failed to trigger build for $build_target. Please check your credentials and build target."
    fi
}

# Function to stop a build by build number
stop_build() {
    local build_target=$1
    local build_number=$2

    echo "Stopping build $build_number for $build_target..."

    response=$(curl -s -X DELETE "$API_ENDPOINT/orgs/$UNITY_ORG_ID/projects/$PROJECT_NAME/buildtargets/$build_target/builds/$build_number" \
        -H "Authorization: Basic $UNITY_API_TOKEN")

    # Check if the request was successful
    if [ $? -eq 0 ]; then
        echo "Build $build_number for $build_target stopped successfully."
    else
        echo "Failed to stop build $build_number for $build_target."
    fi
}

# Commenting out stop_all_builds function and its usage
# Function to stop all builds for a given build target
# stop_all_builds() {
#     local build_target=$1
#     echo "Stopping all builds for $build_target..."
#
#     # Fetch the list of builds for the specified build target
#     builds=$(curl -s -H "Authorization: Basic $UNITY_API_TOKEN" "$API_ENDPOINT/orgs/$UNITY_ORG_ID/projects/$PROJECT_NAME/buildtargets/$build_target/builds")
#
#     # Extract build numbers and stop each build
#     echo "$builds" | jq -r '.[].buildNumber' | while read -r build_number; do
#         stop_build "$build_target" "$build_number"
#     done
# }

# Check the command type
if [ "$COMMAND_TYPE" == "stop" ]; then
    # Check if stopping all builds is requested
    if [ "$STOP_ALL_BUILDS" == "stop_all" ]; then
        # Stop all builds for each build target
        for build_target in "${BUILD_TARGETS[@]}"; do
            echo "Stopping all builds for $build_target..."
            # Implement logic to stop all builds for this target if needed
            # For now, it's commented out for cleanup.
        done
    elif [ -n "$SPECIFIC_BUILD_TARGET" ] && [ -n "$BUILD_NUMBER" ]; then
        # Stop the specific build
        stop_build "$SPECIFIC_BUILD_TARGET" "$BUILD_NUMBER"
    else
        echo "Error: To stop a build, specify a build target and build number."
    fi
    exit 0
elif [ "$COMMAND_TYPE" == "trigger" ]; then
    # Check if a specific build target is provided
    if [ -n "$SPECIFIC_BUILD_TARGET" ]; then
        # Trigger the specific build target with clean build
        trigger_build "$SPECIFIC_BUILD_TARGET"
    else
        # Trigger all build targets based on the environment (with clean build option)
        for build_target in "${BUILD_TARGETS[@]}"; do
            trigger_build "$build_target"
        done
    fi
else
    echo "Error: Invalid command type. Use 'trigger' or 'stop'."
    exit 1
fi
