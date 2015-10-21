# DataAnalytics

The data analytics benchmark relies on using the Hadoop MapReduce framework to perform machine learning analysis on large-scale datasets. Apache provides an machine learning library, Mahout, that is designed to run with Hadoop and perform large-scale data analytics.

##Pull the image from Docker Repository
```
docker pull cloudsuite/dataanalytics
```
## Building the image
```
docker build --rm -t cloudsuite/dataanalytics .
```

## Running the image
```
docker run -d --name="dataanalytics" -h "dataanalytics" -p 8042:8042 -p 8088:8088 -p 50070:50070 -p 50075:50075 -p 50090:50090 cloudsuite/dataanalytics
```

## SSH login

root password : hadoop

```
ssh `docker inspect -f root@'{{ .NetworkSettings.IPAddress }}' dataanalytics`
```

## Hadoop run
```
start-all.sh
```

To check that hadoop is running run the following command:
```
jps
```
You should see that NodeManager, DataNode, NameNode, ResourceManager, and SecondaryNameNode are running:
```
624 NodeManager
209 DataNode
659 Jps
132 NameNode
540 ResourceManager
334 SecondaryNameNode
```
## Running the benchmark
Run the following command in the docker container, after bringing up the hadoop.
```
./run.sh
```





