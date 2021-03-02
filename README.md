# Udagram Microservices

[![Build Status](https://travis-ci.com/xistz/udagram-microservices.svg?branch=main)](https://travis-ci.com/xistz/udagram-microservices)

This repository implements the course 4 project, Refactor Monolith to Microservices, of the Udacity Cloud Developer Nanodegree.

## terraform

This directory contains terraform code to provision the infrastructure required for the project on AWS.

### Provison AWS resources

```shell
terraform init
terraform plan
terraform apply
```

## k8s

This directory contains the k8s manifests for deploying udagram.

```shell
# configure kubectl
export AWS_ACCESS_KEY_ID={access_key_id}
export AWS_SECRET_ACCESS_KEY={secret_access_key}
export AWS_DEFAULT_REGION={region}
aws eks update-kubeconfig --name udagram-eks

# deploy
kubectl apply -f ./k8s
```

## project

This directory contains the application code of the project.
