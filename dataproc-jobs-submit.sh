#!/bin/bash
#
# Copyright 2021 "Holloway" Chew, Kean Ho <hollowaykeanho@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

REGION="us-central1"
ZONE="${REGION}-b"

CLUSTER="my-cluster"
JOB="spark"
JOB_CLASS="org.apache.spark.examples.SparkPi"
JAR_FILE_LOCATION="file:///usr/lib/spark/examples/jars/spark-examples.jar"
JOB_TASKS_TOTAL="1000"




# submit job to cluster
gcloud dataproc jobs submit "$JOB" \
	--cluster "$CLUSTER" \
	--class "$JOB_CLASS" \
	--jars "$JAR_FILE_LOCATION" -- "$JOB_TASKS_TOTAL"
