# JenkinsApi


This is a shell script to submit jobs to Jenkins API

# HOW TO USE

Declare your job variables like OS_TYPE , USERNAME and USER_KEY in the ./env.sh file and simply execute the API call script (./execute_api.sh)

# POINTS TO NOTE
Your CLUSTER_COMPONENTS list will be the comma separated list of all the components you wish to install

All your job parameters will be defined in the env.sh shell script and you can use them to execute jenkins jobs through an api call, The curl request in execute_api.sh can be adapted for different pipelines, right now it only has the curl POST request for ODP_Jumpbox-DC 

