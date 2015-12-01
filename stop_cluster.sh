#!/bin/bash
docker stop mongo3 mongo2 mongo1
docker rm mongo3 mongo2 mongo1 mongostart
docker rmi mongo_rs_node mongo_rs_setup
docker network rm mongo_cluster_network