#!/bin/bash

sleep 60

if [[ $(kubectl -n my-app rollout status deploy ${deploymentName} --timeout 5s) != *"successfully rolled out"* ]]; 
then
    echo "Deployment ${deploymentName} failed to rollout"
    kubectl -n my-app rollout undo deploy ${deploymentName}
    exit 1
else
    echo "Deployment ${deploymentName} successfully rolled out"
fi