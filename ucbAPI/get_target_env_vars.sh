#!/bin/bash

# Color codes for formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Source the environment variables from the config file
if [ -f ./config.env ]; then
    source ./config.env
    echo -e "${GREEN}Loaded environment variables from config.env${NC}"
else
    echo -e "${RED}Error: config.env file not found.${NC}"
    exit 1
fi

# Define variables
API_TOKEN="${UNITY_API_TOKEN}"
ORG_ID="${UNITY_ORG_ID}"

# Function to get project ID by name
get_project_id() {
    local PROJECT_NAME="$1"
    local AUTH_HEADER="Authorization: Basic $API_TOKEN"
    local API_ENDPOINT="https://build-api.cloud.unity3d.com/api/v1"
    local REQUEST_URL="$API_ENDPOINT/orgs/$ORG_ID/projects"

    echo -e "\n${BLUE}Fetching project ID for project: $PROJECT_NAME...${NC}"

    # Make GET request to fetch projects
    PROJECTS=$(curl -s -H "$AUTH_HEADER" "$REQUEST_URL")
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error: Failed to execute API request.${NC}"
        exit 1
    fi

    # Retrieve the project ID for the specified project name
    PROJECT_ID=$(echo "$PROJECTS" | jq -r --arg PROJECT_NAME "$PROJECT_NAME" '.[] | select(.name == $PROJECT_NAME) | .guid')

    if [ -z "$PROJECT_ID" ]; then
        echo -e "${RED}Error: Project '$PROJECT_NAME' not found.${NC}"
        exit 1
    fi

    echo -e "${GREEN}Found Project ID: $PROJECT_ID${NC}"
}

# Function to get environment variables for a build target
get_build_target_env_vars() {
    local API_TOKEN="$1"
    local ORG_ID="$2"
    local PROJECT_ID="$3"
    local TARGET_ID="$4"
    local AUTH_HEADER="Authorization: Basic $API_TOKEN"
    local API_ENDPOINT="https://build-api.cloud.unity3d.com/api/v1"
    local REQUEST_URL="$API_ENDPOINT/orgs/$ORG_ID/projects/$PROJECT_ID/buildtargets/$TARGET_ID/envvars"

    echo -e "\n${BLUE}Fetching environment variables for Build Target: $TARGET_ID...${NC}"
    
    # Make GET request to fetch environment variables
    ENV_VARS=$(curl -s -H "$AUTH_HEADER" "$REQUEST_URL")

    if [ $? -ne 0 ]; then
        echo -e "${RED}Error: Failed to execute API request.${NC}"
        exit 1
    fi

    ERROR=$(echo "$ENV_VARS" | jq -r '.error')
    if [ "$ERROR" != "null" ]; then
        echo -e "${RED}API Error: $ERROR${NC}"
        exit 1
    fi

    echo -e "${GREEN}Successfully retrieved environment variables for Build Target: $TARGET_ID${NC}"

    echo -e "\n${YELLOW}Environment Variables:${NC}"
    echo "$ENV_VARS" | jq .
}

# Check if correct number of arguments is provided
if [ "$#" -lt 2 ]; then
    echo -e "${RED}Usage: $0 <Project Name> <Target ID>${NC}"
    exit 1
fi

# Fetch arguments
PROJECT_NAME="$1"
TARGET_ID="$2"

# Get project ID from the project name
get_project_id "$PROJECT_NAME"

# Get build target environment variables
get_build_target_env_vars "$API_TOKEN" "$ORG_ID" "$PROJECT_ID" "$TARGET_ID"

# Save environment variables to a file
echo -e "\n${BLUE}Saving environment variables to envvarsfile.txt...${NC}"
echo "$ENV_VARS" | jq . > envvarsfile.txt
echo -e "${GREEN}Environment variables saved to envvarsfile.txt${NC}"
