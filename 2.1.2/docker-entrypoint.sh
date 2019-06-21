#!/bin/bash

set -e

echo "Starting hbase container with "$HBASE_ROLE" role"
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
echo "<property><name>hbase.$HBASE_ROLE.hostname</name><value>$HOSTNAME</value></property>" >> $CONFIG
echo "<property><name>hbase.$HBASE_ROLE.port</name><value>$PORT</value></property>" >> $CONFIG
echo "<property><name>zookeeper.znode.parent</name><value>$ZK_PARENT</value></property>" >> $CONFIG
echo "</configuration>" >> $CONFIG

cat $CONFIG

# Generate the regionservers
CONFIG="conf/regionservers"
echo $REGIONSERVERS | tr , '\n' > $CONFIG

echo "Running command "$@
exec "$@"