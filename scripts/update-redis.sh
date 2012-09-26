#!/bin/bash
sudo ls
pushd ~/Programs
wget http://download.redis.io/redis-stable.tar.gz
tar xvzf redis-stable.tar.gz
cd redis-stable
make
sudo cp ~/Programs/redis-stable/src/redis-server /usr/local/bin/
sudo cp ~/Programs/redis-stable/src/redis-cli /usr/local/bin/
popd
