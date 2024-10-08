# UCB API scripts

###### 1. Fetch Environment Variables for a Build Target
Script: ***get_target_env_vars.sh***

This script interacts with the Unity Cloud Build API to retrieve environment variables for specific build targets associated with a project.

Prerequisites
- API Token: You need a valid Unity Cloud Build API token.
- jq: This script uses jq for parsing JSON. Ensure it is installed on your system.

Usage:
- ./get_taret_env_vars.sh *ProjectName* *TargetID*

This script automatically generates a file called "envvarsfile.txt" with the fetched variables, which can be used to manually change and push the env vars to the desired projects with the ***set_env_vars.sh*** script.


###### 2. Update Unity Cloud Build Target Environment Variables
Script: ***set_target_env_vars.sh***

This script updates the environment variables for a specified build target in a Unity Cloud Build (UCB) project. It retrieves the project ID based on the provided project name and uploads the modified environment variables defined in a text file called "envvarsfile.txt".

Prerequisites
- API Token: You need a valid Unity Cloud Build API token.
- jq: This script uses jq for parsing JSON. Ensure it is installed on your system.

Usage: 
- ./set_target_env_vars.sh *ProjectName* *TargetID*


###### 3. Fetch Unity Cloud Build Information
Script: ***get_all_projects.sh***

This script interacts with the Unity Cloud Build API to retrieve and display information about the projects associated with a specific organization.

Prerequisites
- API Token: You need a valid Unity Cloud Build API token.
- jq: This script uses jq for parsing JSON. Ensure it is installed on your system.

Usage: 
- ./get_all_projects.sh


###### 4. Fetch Build Targets for a Unity Project
Script: ***get_project_targets***

This script interacts with the Unity Cloud Build API to retrieve and display the build targets associated with a specified project.

Prerequisites

- API Token: You need a valid Unity Cloud Build API token.
- jq: This script uses jq for parsing JSON. Ensure it is installed on your system.

Usage:
- ./unity_cloud_build_info.sh *ProjectName*


###### 5.  Fetch Build Target and Their Settings
Script: ***get_project_target_settings.sh***

This script interacts with the Unity Cloud Build API to retrieve and display the build targets and their settings for specified projects.

Prerequisites

- API Token: You need a valid Unity Cloud Build API token.
- jq: This script uses jq for parsing JSON. Ensure it is installed on your system.

Usage: 
- ./get_target_settings.sh *ProjectName* *TargetID*

###### 6. Trigger or Stop Builds for a Unity Project
**Script:** ***trigger_or_stop_build.sh***

This script interacts with the Unity Cloud Build API to trigger or stop builds for specific projects and build targets. It supports triggering new builds with clean options and stopping ongoing builds by build number.

**Prerequisites**
- **API Token:** You need a valid Unity Cloud Build API token.
- **jq:** This script uses jq for parsing JSON. Ensure it is installed on your system.

**Usage:**
- To trigger a build:
./trigger_or_stop_build.sh trigger ProjectName EnvironmentOrTarget SpecificBuildTarget

- To stop a build: 
./trigger_or_stop_build.sh stop ProjectName EnvironmentOrTarget SpecificBuildTarget BuildNumber 

