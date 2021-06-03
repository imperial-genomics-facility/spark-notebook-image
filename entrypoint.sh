#!/usr/bin/env bash
case "$1" in
notebook)
  . /home/vmuser/miniconda3/etc/profile.d/conda.sh
  conda activate notebook-env
  SPARK_HOME=$(pip show pyspark | grep Location | awk -F' ' '{print $2 "/pyspark" }')
  export SPARK_HOME=$SPARK_HOME
  export SPARK_OPTS="--driver-java-options=-Xms1024M --driver-java-options=-Xmx2048M --driver-java-options=-Dlog4j.logLevel=info"
  export PATH=$PATH:$SPARK_HOME/bin
  export PYSPARK_SUBMIT_ARGS="--conf spark.serializer=org.apache.spark.serializer.KryoSerializer --packages io.delta:delta-core_2.12:1.0.0 --conf spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension --conf spark.sql.catalog.spark_catalog=org.apache.spark.sql.delta.catalog.DeltaCatalog  pyspark-shell"
  jupyter lab --no-browser --port=8888 --ip=0.0.0.0
  
  ;;
*)
  . /home/vmuser/miniconda3/etc/profile.d/conda.sh
  conda activate notebook-env
  exec "$@"
     ;;
esac
