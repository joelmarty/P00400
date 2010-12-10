#!/bin/bash

JAVA_HOME=/usr/lib/jvm/java-6-openjdk/jre/

if [ "$TERM" = "dumb" ]; then
    echo "The TERM environment variable is not set!"
    exit
fi

# Uncomment the next line to enable color.
TEST_OPTS="${TEST_OPTS} -Dcharva.color=1"

# debug mode
#TEST_OPTS="${TEST_OPTS} -Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5005"

${JAVA_HOME}/bin/java \
    ${TEST_OPTS} \
    -cp ".:bin/:fbsh:lib/log4j-1.2.15.jar:lib/commons-logging.jar:lib/restfb-1.5.4.jar:lib/charva.jar" \
    org.brookes.fbsh.Main 2> fbsh.log
#stty sane
