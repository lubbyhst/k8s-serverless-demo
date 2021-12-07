#!/usr/bin/env bash

export CL_NAM=demo
export NUM_WORKERS=1
export NUM_MASTERS=1

mkdir -p $HOME/dockerImages

docker save --output $HOME/dockerImages/k8s-serverless-demo-1.0-SNAPSHOT.tar demo/k8s-serverless-demo:1.0-SNAPSHOT

echo "**************************************************************************************************************************** upgrade master"
multipass exec k3s-$CL_NAM-master-0 sudo k3s ctr images import /Users/Ubuntu/dockerImages/k8s-serverless-demo-1.0-SNAPSHOT.tar
multipass exec k3s-$CL_NAM-master-0 sudo k3s ctr images tag docker.io/demo/k8s-serverless-demo:1.0-SNAPSHOT dev.local/demo/k8s-serverless-demo:1.0-SNAPSHOT
echo "**************************************************************************************************************************** k3s-$CL_NAM-master-0 upgraded"


echo "**************************************************************************************************************************** upgrade workers"
for ((CNT=0; CNT<$NUM_WORKERS; CNT+=1)); do
	multipass exec k3s-$CL_NAM-worker-$CNT sudo k3s ctr images import /Users/Ubuntu/dockerImages/k8s-serverless-demo-1.0-SNAPSHOT.tar
	multipass exec k3s-$CL_NAM-worker-$CNT sudo k3s ctr images tag docker.io/demo/k8s-serverless-demo:1.0-SNAPSHOT dev.local/demo/k8s-serverless-demo:1.0-SNAPSHOT
	echo "**************************************************************************************************************************** k3s-$CL_NAM-worker-$CNT upgraded"
done
