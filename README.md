# Udagram Microservices

[![Build Status](https://travis-ci.com/xistz/udagram-microservices.svg?branch=main)](https://travis-ci.com/xistz/udagram-microservices)

This repository implements the course 4 project, Refactor Monolith to Microservices, of the Udacity Cloud Developer Nanodegree.

## terraform

This directory contains terraform code to provision the infrastructure required for the project on AWS.

### Setup

```shell
# create aws resources using terraform
terraform init
terraform plan
terraform apply

# configure kubectl
aws eks update-kubeconfig --name udagram
```

## project

This directory contains the application code of the project.
