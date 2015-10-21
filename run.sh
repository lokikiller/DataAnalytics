#!/bin/bash

mahout org.apache.mahout.text.wikipedia.WikipediaXmlSplitter -d $MAHOUT_HOME/examples/temp/enwiki-latest-pages-articles.xml -o wikipedia/chunks -c 64
mahout org.apache.mahout.text.wikipedia.WikipediaXmlSplitter -d $MAHOUT_HOME/examples/temp/enwiki-20100904-pages-articles1.xml -o wikipedia-training/chunks -c 64
mahout org.apache.mahout.text.wikipedia.WikipediaDatasetCreatorDriver -i wikipedia/chunks -o wikipediainput -c $MAHOUT_HOME/examples/temp/categories.txt
mahout org.apache.mahout.text.wikipedia.WikipediaDatasetCreatorDriver -i wikipedia-training/chunks -o traininginput -c $MAHOUT_HOME/examples/temp/categories.txt
mahout trainclassifier -i traininginput -o wikipediamodel -mf 4 -ms 4
mahout testclassifier -m wikipediamodel -d wikipediainput --method mapreduce


