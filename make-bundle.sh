#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

MODULES_DIR="${DIR}/modules"


# compress: {
# sequences: true,
# dead_code: true,
# conditionals: true,
# booleans: true,
# unused: true,
# if_return: true,
# join_vars: true,
# drop_console: true
UGLIFYJS_OPTS=""

lsc -cb init.ls

# create bundle
BUNDLE="app.min.js"
echo > ${BUNDLE}

# Register modules via `Modules.addCached()` method
# see: http://forum.espruino.com/comments/12899741/
MODULE_NAME="FlashEEPROM"
MODULE_STR=$(uglifyjs ${UGLIFYJS_OPTS} -- ${MODULES_DIR}/${MODULE_NAME}.js | sed 's/\"/\\\"/g' | sed "s/\n//g")
echo "Modules.addCached(\"${MODULE_NAME}\", \"${MODULE_STR}\");" >> ${BUNDLE}
uglifyjs ${UGLIFYJS_OPTS} -- init.js >> ${BUNDLE}
