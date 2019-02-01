#!/bin/bash

# Abort on Error
set -e

DUMP___NUMBER_OF_LINES=1000
PING_SLEEP=30s
WORKDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BUILD_OUTPUT=$WORKDIR/build.out

touch $BUILD_OUTPUT

dump_output() {
   echo Tailing the last $DUMP___NUMBER_OF_LINES lines of output:
   tail -n $DUMP___NUMBER_OF_LINES $BUILD_OUTPUT  
}
error_handler() {
  echo ERROR: An error was encountered with the build.
  dump_output
  exit 1
}
# If an error occurs, run our error handler to output a tail of the build
trap 'error_handler' ERR

# Set up a repeating loop to send some output to Travis.
bash -c "while true; do echo \$(date) - building ...; sleep $PING_SLEEP; done" &
PING_LOOP_PID=$!

# The actual build command
mvn --quiet --fail-at-end package >> $BUILD_OUTPUT 2>&1

# The build finished without returning an error so dump a tail of the output
dump_output
