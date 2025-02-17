#!/bin/bash

sed -i "s#replace#${imageName}#g" kubernetes/deployment.yaml
kubectl -n my-app get deployment ${deploymentName} > /dev/null

if [[ $? -ne 0 ]]; then
    echo "deployment ${deploymentName} does not exists"
    kubectl -n my-app apply -f kubernetes/deployment.yaml
else
    echo "deployment ${deploymentName} exists"
    echo "image name - ${imageName}"
    kubectl -n my-app set image deploy ${deploymentName} ${containerName}=${imageName} --record=true
fi
