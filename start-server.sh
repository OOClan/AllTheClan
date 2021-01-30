#!/bin/bash
java -d64 -server -Xms8G -Xmx8G -XX:ParallelGCThreads=4 \
    -XX:+AggressiveOpts -XX:+UseConcMarkSweepGC \
    -jar forge-1.16.5-36.0.9.jar
