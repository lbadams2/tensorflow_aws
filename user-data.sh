#!/bin/bash

sudo apt update -y
sudo apt install -y docker.io # by default docker containers use all memory and cpu on host
sudo systemctl start docker