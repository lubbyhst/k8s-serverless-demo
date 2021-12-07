#!/usr/bin/env bash

export CL_NAM=serverless-demo
export NUM_WORKERS=1
export NUM_MASTERS=1

docker save --output $HOME/dockerImages/k8s-serverless-demo-1.0-SNAPSHOT.tar lubiniecki/k8s-serverless-demo:1.0-SNAPSHOT

echo "**************************************************************************************************************************** upgrade master"
multipass exec k3s-$CL_NAM-master-0 sudo k3s ctr images import /Users/Ubuntu/dockerImages/k8s-serverless-demo-1.0-SNAPSHOT.tar
multipass exec k3s-$CL_NAM-master-0 sudo k3s ctr images tag docker.io/lubiniecki/k8s-serverless-demo:1.0-SNAPSHOT dev.local/lubiniecki/k8s-serverless-demo:1.0-SNAPSHOT
echo "**************************************************************************************************************************** k3s-$CL_NAM-master-0 upgraded"


echo "**************************************************************************************************************************** upgrade workers"
for ((CNT=0; CNT<$NUM_WORKERS; CNT+=1)); do
	multipass exec k3s-$CL_NAM-worker-$CNT sudo k3s ctr images import /Users/Ubuntu/dockerImages/k8s-serverless-demo-1.0-SNAPSHOT.tar
	multipass exec k3s-$CL_NAM-worker-$CNT sudo k3s ctr images tag docker.io/lubiniecki/k8s-serverless-demo:1.0-SNAPSHOT dev.local/lubiniecki/k8s-serverless-demo:1.0-SNAPSHOT
	echo "**************************************************************************************************************************** k3s-$CL_NAM-worker-$CNT upgraded"
done
