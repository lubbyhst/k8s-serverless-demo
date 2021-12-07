#!/usr/bin/env bash

kubeconfig_path="$HOME/.kube/config-serverless-demo"
kubectl --kubeconfig=$kubeconfig_path apply -f serverless-demo.yml
kubectl --kubeconfig=$kubeconfig_path --namespace serverless get ksvc
