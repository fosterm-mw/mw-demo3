#!/bin/bash

#create configmap first
#kubectl create configmap wrapper --from-file=wrapper.sh

bq load --autodetect \
--source_format=CSV \
$DATASET_NAME.ccp_demo_username_tb \
gs://mayo-demo-2852fn/username.csv 
