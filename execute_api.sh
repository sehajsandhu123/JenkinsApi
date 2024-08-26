#!/bin/bash

# Source env.sh if it exists to load default values
if [ -f ./env.sh ]; then
  source ./env.sh
fi

# Function to display help
print_help() {
  echo "Usage: $0 [options]"
  echo "Options:"
  echo "  -u, --jenkins-url      Jenkins URL (default: $JENKINS_URL)"
  echo "  -n, --job-name         Jenkins job name (default: $JOB_NAME)"
  echo "  -s, --username         Jenkins username (default: $JENKINS_USER)"
  echo "  -t, --token            Jenkins token (default: $JENKINS_TOKEN)"
  echo "  -h, --help             Display this help message"
}

# Parse command-line arguments to override default values
while [[ "$#" -gt 0 ]]; do
  case $1 in
    -u|--jenkins-url) JENKINS_URL="$2"; shift ;;
    -n|--job-name) JOB_NAME="$2"; shift ;;
    -s|--username) JENKINS_USER="$2"; shift ;;
    -t|--token) JENKINS_TOKEN="$2"; shift ;;
    -k|--user-key) PARAM_USER_KEY="$2"; shift ;;
    -kc|--user-cert) PARAM_USER_CERT="$2"; shift ;;
    -h|--help) print_help; exit 0 ;;
    *) echo "Unknown option: $1"; print_help; exit 1 ;;
  esac
  shift
done


# Ensure CLUSTER_COMPONENTS is defined
if [ -z "$CLUSTER_COMPONENTS" ]; then
  echo "Error: CLUSTER_COMPONENTS is not defined."
  exit 1
fi

# Convert the user input to an array
IFS=',' read -r -a SELECTED_COMPONENTS <<< "$CLUSTER_COMPONENTS"

# Function to check if an element is in a list
function contains_element() {
  local element
  for element in "${@:2}"; do [[ "$element" == "$1" ]] && return 0; done
  return 1
}

# Validate the user input
for component in "${SELECTED_COMPONENTS[@]}"; do
  if ! contains_element "$component" ${AVAILABLE_COMPONENTS//,/ }; then
    echo "Invalid component: $component"
    exit 1
  fi
done

echo "You have selected the following components:"
for component in "${SELECTED_COMPONENTS[@]}"; do
  echo "- $component"
done






# Build the Jenkins job URL
JOB_URL="$JENKINS_URL/job/$JOB_NAME/buildWithParameters"
echo """
curl -X POST "$JOB_URL" \
  --user "$JENKINS_USER:$JENKINS_TOKEN" \
  --data-urlencode "Name=$PARAM_NAME" \
  --data-urlencode "ambariVersion=$PARAM_AMBARI_VERSION" \
  --data-urlencode "odpVersion=$PARAM_ODP_VERSION" \
  --data-urlencode "user_name=$PARAM_SLACK_USER" \
  --data-urlencode "initial_user=$PARAM_INITIAL_USER" \
  --data-urlencode "CLUSTER_COMPONENTS=$CLUSTER_COMPONENTS" \
  --data-urlencode "NODE_COUNT=$NODE_COUNT" \
  --data-urlencode "OS_type=$OS_TYPE" \
  --data-urlencode "JAVA_Version=$JAVA_VERSION" \
  --data-urlencode "Kerberos=$KERBEROS" \
  --data-urlencode "USER_KEY=$(echo -n "'$PARAM_USER_KEY'")" \
  --data-urlencode "USER_CERT=$(echo -n "'$PARAM_USER_CERT'")" \
  --data-urlencode "IPAddresses_M=$(echo -n "'$IP_ADDRESS_LIST'")"
"""




# Send the POST request to trigger the Jenkins job
curl -X POST "$JOB_URL" \
  --user "$JENKINS_USER:$JENKINS_TOKEN" \
  --data-urlencode "Name=$PARAM_NAME" \
  --data-urlencode "ambariVersion=$PARAM_AMBARI_VERSION" \
  --data-urlencode "odpVersion=$PARAM_ODP_VERSION" \
  --data-urlencode "user_name=$PARAM_SLACK_USER" \
  --data-urlencode "initial_user=$PARAM_INITIAL_USER" \
  --data-urlencode "CLUSTER_COMPONENTS=$CLUSTER_COMPONENTS" \
  --data-urlencode "NODE_COUNT=$NODE_COUNT" \
  --data-urlencode "OS_type=$OS_TYPE" \
  --data-urlencode "JAVA_Version=$JAVA_VERSION" \
  --data-urlencode "Kerberos=$KERBEROS" \
  --data-urlencode "USER_KEY=$(echo -n "'$PARAM_USER_KEY'")" \
  --data-urlencode "USER_CERT=$(echo -n "'$PARAM_USER_CERT'")" \
  --data-urlencode "IPAddresses_M=$(echo -n "'$IP_ADDRESS_LIST'")"


