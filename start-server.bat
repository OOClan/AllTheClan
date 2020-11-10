@ECHO OFF
java -d64 -server -Xms8G -Xmx8G -XX:ParallelGCThreads=4 ^
    -XX:+AggressiveOpts -XX:+UseConcMarkSweepGC ^
    -jar forge-1.16.4-35.0.18.jar
