#!/usr/bin/env bash

kubeconfig_path="$HOME/.kube/config-serverless-demo"
kubectl --kubeconfig=$kubeconfig_path apply -f serving-crds.yaml
kubectl --kubeconfig=$kubeconfig_path apply -f serving-core.yaml
kubectl --kubeconfig=$kubeconfig_path apply -f kourier.yaml
kubectl --kubeconfig=$kubeconfig_path patch configmap/config-network \
  --namespace knative-serving \
  --type merge \
  --patch '{"data":{"ingress.class":"kourier.ingress.networking.knative.dev"}}'

kubectl --kubeconfig=$kubeconfig_path apply -f serving-hpa.yaml

kubectl --kubeconfig=$kubeconfig_path --namespace kourier-system get service kourier