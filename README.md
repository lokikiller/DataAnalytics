# DataAnalytics

The data analytics benchmark relies on using the Hadoop MapReduce framework to perform machine learning analysis on large-scale datasets. Apache provides an machine learning library, Mahout, that is designed to run with Hadoop and perform large-scale data analytics.

## Building the image
If you'd like to try directly from the Dockerfile you can build the image as:
```
docker build -t CloudSuite-EPFL/DataAnalytics .
```

##Pull the image from Docker Repository
The image is also released as an official Docker image from Docker's automated build repository - you can always pull or refer the image when launching containers.
```
docker pull CloudSuite-EPFL/DataAnalytics
```

## Datasets
This benchmark uses a Wikipedia dataset of ~30GB. We prepared a dataset container, to download this dataset once, and use it to run the benchmark. You can pull this image from Docker's automated build repository.
```
docker pull CloudSuite-EPFL/DataAnalytics/dataset
```
You can also build the image directly from the Dockerfile.
```
docker build -t CloudSuite-EPFL/DataAnalytics/dataset .
```


## Running the image
First you need to create the data container.
```
DATA=$(docker run -d dataset)
```
Then, you are able to run the benchmark.

```
docker run -it -volumes-from $DATA CloudSuite-EPFL/DataAnalytics /etc/bootstrap.sh -bash
```

## Running the benchmark
Running the image automatically runs the benchmark as well. After completion, the model will be available in HDFS, under the wikipediamodel folder.
