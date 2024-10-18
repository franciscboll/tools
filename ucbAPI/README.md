# UCB API scripts

This repository contains a collection of bash scripts designed to interact with the Unity Cloud Build (UCB) API. These scripts simplify various tasks related to managing build targets, environment variables, and project settings within the UCB ecosystem. Whether you need to fetch environment variables, trigger new builds, or stop ongoing ones, these scripts streamline the process and provide easy access to essential functionality.

##### Prerequisites
##### - API Token: You need a valid Unity Cloud Build API token.
##### - jq: These scripts uses jq for parsing JSON. Ensure it is installed on your system.

### Table of Contents
1. [Environment Variables Management](#environment-variables-management)
   - Fetch and update environment variables for build targets.
2. [Build Target and Project Information](#build-target-and-project-information)
   - Retrieve information on projects, build targets, and their settings.
3. [Build Triggering and Management](#build-triggering-and-management)
   - Trigger and stop builds for specified projects and targets.

## Environment Variables Management
##### Scripts that handle fetching and updating environment variables for Unity Cloud Build projects.   


###### 1. Fetch Environment Variables for a Build Target
Script: ***get_target_env_vars.sh***

##### This script interacts with the Unity Cloud Build API to retrieve environment variables for specific build targets associated with a project.

```Usage: bash ./get_target_env_vars.sh ProjectName TargetID```

##### This script automatically generates a file called "envvarsfile.txt" with the fetched variables, which can be used to manually change and push the env vars to the desired projects with the ***set_env_vars.sh*** script.


###### 2. Update Unity Cloud Build Target Environment Variables
Script: ***set_target_env_vars.sh***

##### This script updates the environment variables for a specified build target in a Unity Cloud Build (UCB) project. It retrieves the project ID based on the provided project name and uploads the modified environment variables defined in a text file called "envvarsfile.txt".

```Usage: bash ./set_target_env_vars.sh ProjectName TargetID```

## Build Target and Project Information
##### Scripts for retrieving information about projects, build targets, and their settings.


###### 3. Fetch Unity Cloud Build Information
Script: ***get_all_projects.sh***

##### This script interacts with the Unity Cloud Build API to retrieve and display information about the projects associated with a specific organization.

 ```Usage: bash ./set_target_env_vars.sh ProjectName TargetID```


###### 4. Fetch Build Targets for a Unity Project
Script: ***get_project_targets***

##### This script interacts with the Unity Cloud Build API to retrieve and display the build targets associated with a specified project.

```Usage: bash ./unity_cloud_build_info.sh ProjectName```


###### 5.  Fetch Build Target and Their Settings
Script: ***get_project_target_settings.sh***

##### This script interacts with the Unity Cloud Build API to retrieve and display the build targets and their settings for specified projects.
 
```Usage: bash ./get_target_settings.sh ProjectName TargetID```

## Build Triggering and Management
##### Scripts to trigger new builds or stop ongoing ones in Unity Cloud Build.

###### 6. Trigger or Stop Builds for a Unity Project
**Script:** ***trigger_or_stop_build.sh***

##### This script interacts with the Unity Cloud Build API to trigger or stop builds for specific projects and build targets. It supports triggering new builds with clean options and stopping ongoing builds by build number.

- To trigger a build:
```Usage: bash ./trigger_or_stop_build.sh trigger ProjectName EnvironmentOrTarget SpecificBuildTarget```

- To stop a build: 
```Usage: bash ./trigger_or_stop_build.sh stop ProjectName EnvironmentOrTarget SpecificBuildTarget BuildNumber```

- Example: bash trigger_or_stop_build.sh trigger Fentanyl ios ios-gateway


