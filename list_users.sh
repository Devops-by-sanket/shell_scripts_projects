
#!/bin/bash


####################################

# This script is using to see who has access to repos on github, also used for revoking the access and add new user.

# Version : 1

# Owner : Sanket V Kaleshwar

###################################


# Call helper function to perform initial checks
#helper "$@"

# Github API URL 
API_URL="https://api.github.com"



# To authenticate with Github,we need user name and token. We can export them rather using in script.
USERNAME=$username
TOKEN=$token



# Command line arguments needed to run script 
REPO_OWNR=$1
REPO_NAME=$2



# Function to make a Get request to github API.
function github_api_get {
	
	local endpoint="$1"
	local url="${API_URL}/${endpoint}"

	# Send a get request to Github API with Authentication
	
	curl -s -u "${USERNAME}:${TOKEN}" "$url"

}


# Function to print the user which has the access to the repo.
function list_user_with_read_access {

	local endpoint="repos/${REPO_OWNR}/${REPO_NAME}/collaborators"
	
	# fetch the list of collabrators who has access 
	collaborators="$(github_api_get "$endpoint" | jq -r '.[] | select(.permissions.pull == true) | .login')"


	# Display list of collabrators with read access 

	if [[ -z "$collaborators" ]]; then
		echo "No one has access to ${REPO_OWNR}/${REPO_NAME}"
	else 
		echo "users with read access to ${REPO_OWNR}/${REPO_NAME}"
		echo "$collaborators"
	fi

}


# Adding helper functions to avoid the errors and provide the information for users to execute the scripts 
function helper {
	
	command_line_arg=2
	if [[ $# -ne $command_line_arg ]]; then
	echo "Please provide required arg to execute the script"
	exit 1
	fi

}


# Call helper function to perform initial checks
helper "$@"


# Main script
echo "Listing users with read access to ${REPO_OWNR}/${REPO_NAME}..."
list_user_with_read_access


