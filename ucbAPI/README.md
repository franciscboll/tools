# UCB API scripts

###### 1. List env vars for a build target
Script: ***get_env_vars.sh***

This script interacts with the Unity Cloud Build API to retrieve environment variables for specific build targets associated with a project.

Prerequisites
- API Token: You need a valid Unity Cloud Build API token.
- jq: This script uses jq for parsing JSON. Ensure it is installed on your system.

- Usage:
./get_env_vars.sh <Project Name> <Target ID>


###### 2. Fetch Unity Cloud Build Information


Script: ***get_all_projects.sh***

This script interacts with the Unity Cloud Build API to retrieve and display information about the projects associated with a specific organization.

Prerequisites
- API Token: You need a valid Unity Cloud Build API token.
- jq: This script uses jq for parsing JSON. Ensure it is installed on your system.

- Usage: 
./get_all_projects.sh

###### 3. Fetch Build Targets for a Unity Project


Script: ***get_project_targets***

This script interacts with the Unity Cloud Build API to retrieve and display the build targets associated with a specified project.

Prerequisites

- API Token: You need a valid Unity Cloud Build API token.
- jq: This script uses jq for parsing JSON. Ensure it is installed on your system.

- Usage:
./unity_cloud_build_info.sh <Project Name>


###### 4.  Fetch Build Target and Their Settings

Script: get_project_target_settings.sh

This script interacts with the Unity Cloud Build API to retrieve and display the build targets and their settings for specified projects.

Prerequisites

- API Token: You need a valid Unity Cloud Build API token.
- jq: This script uses jq for parsing JSON. Ensure it is installed on your system.

- Usage: 
./get_target_settings.sh <Project Name> <Target ID>