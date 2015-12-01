#!/bin/bash
# Create the bridged network
docker network create -d bridge mongo_cluster_network
# build the images 
docker build -t mongo_rs_node replicas/
docker build -t mongo_rs_setup startup/
# Run 3 nodes for the replicaset
docker run --net=mongo_cluster_network -itd --name mongo1 -h mongo1 mongo_rs_node
docker run --net=mongo_cluster_network -itd --name mongo2 -h mongo2 mongo_rs_node
docker run --net=mongo_cluster_network -itd --name mongo3 -h mongo3 mongo_rs_node
# start up a mongo shell and initiate the replicaset
docker run --net=mongo_cluster_network -itd --name mongostart mongo_rs_setup

