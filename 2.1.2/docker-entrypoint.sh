#!/bin/bash

set -e

echo "Starting hbase container with "$HBASE_ROLE
echo $ZOOKEEPER_QUORUM
# Generate the config only if it doesn't exist
if [ ! -f "conf/hbase-site.xml" ]; then
    echo "conf/hbase-site.xml not found. creating new config file"
    # touch "conf/hbase-site.xml"
fi

CONFIG="conf/hbase-site.xml"

echo "<?xml version=\"1.0\"?>" > $CONFIG
echo "<?xml-stylesheet type=\"text/xsl\" href=\"configuration.xsl\"?>" >> $CONFIG
echo "<configuration>" >> $CONFIG
echo "<property><name>hbase.rootdir</name><value>file://$HBASE_DATA_DIR</value></property>" >> $CONFIG
echo "<property><name>hbase.cluster.distributed</name><value>true</value></property>" >> $CONFIG
echo "<property><name>hbase.zookeeper.quorum</name><value>$ZOOKEEPER_QUORUM</value></property>" >> $CONFIG
echo "<property><name>hbase.master.hostname</name><value>$MASTER_HOSTNAME</value></property>" >> $CONFIG
echo "<property><name>hbase.master.port</name><value>$MASTER_PORT</value></property>" >> $CONFIG
echo "</configuration>" >> $CONFIG

cat $CONFIG

# Generate the regionservers only if it doesn't exist
if [ ! -f "conf/regionservers" ]; then
    CONFIG="conf/regionservers"
    echo $REGIONSERVERS | tr , '\n' >> $CONFIG
fi

echo "Running command "$@
exec "$@"