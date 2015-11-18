# DataAnalytics #

[![Pulls on DockerHub][dhpulls]][dhrepo]
[![Stars on DockerHub][dhstars]][dhrepo]

The data analytics benchmark relies on using the Hadoop MapReduce framework to perform machine learning analysis on large-scale datasets. Apache provides an machine learning library, Mahout, that is designed to run with Hadoop and perform large-scale data analytics.


### Dockerfiles ###

Supported tags and their respective `Dockerfile` links:
 - [`Benchmark`][benchmarkdocker]: This represents the main benchmark.
 - [`Data`][datasetdocker]: This represents the dataset which is used by the benchmark.

These images are automatically built using the mentioned Dockerfiles available on `CloudSuite-EPFL/DataAnalytics` [GitHub repo][repo].


## Building the image ##
If you'd like to try directly from the Dockerfile you can build the image as:
```
docker build -t CloudSuite-EPFL/DataAnalytics .
```

## Pull the image from Docker Repository ##
The image is also released as an official Docker image from Docker's automated build repository - you can always pull or refer the image when launching containers.
```
docker pull cloudsuite/dataanalytics
```

## Datasets ##
This benchmark uses a Wikipedia dataset of ~30GB. We prepared a dataset container, to download this dataset once, and use it to run the benchmark. You can pull this image from Docker's automated build repository.
```
docker pull cloudsuite/dataanalytics/dataset
```
You can also build the image directly from the Dockerfile.
```
docker build -t CloudSuite-EPFL/DataAnalytics/dataset .
```


## Running the image ##
First you need to create the data container.
```
DATA=$(docker run -d dataset)
```
Then, you are able to run the benchmark.

```
docker run -it -volumes-from $DATA CloudSuite-EPFL/DataAnalytics /etc/bootstrap.sh -bash
```

## Running the benchmark ##
Running the image automatically runs the benchmark as well. After completion, the model will be available in HDFS, under the wikipediamodel folder.


[benchmarkdocker]: https://github.com/CloudSuite-EPFL/DataAnalytics/blob/master/Dockerfile "Benchmark Dockerfile"

[datasetdocker]: https://github.com/CloudSuite-EPFL/DataAnalytics/blob/master/dataset/Dockerfile "Dataset Dockerfile"

[repo]: https://github.com/CloudSuite-EPFL/DataAnalytics "GitHub Repo"
[dhrepo]: https://hub.docker.com/r/cloudsuite/dataanalytics/ "DockerHub Page"
[dhpulls]: https://img.shields.io/docker/pulls/cloudsuite/dataanalytics.svg "Go to DockerHub Page"
[dhstars]: https://img.shields.io/docker/stars/cloudsuite/dataanalytics.svg "Go to DockerHub Page"
