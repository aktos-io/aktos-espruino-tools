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
UGLIFYJS_OPTS="-c -m"

lsc -cb init.ls

# create bundle
BUNDLE="app.min.js"
echo > ${BUNDLE}
uglifyjs ${UGLIFYJS_OPTS} -- init.js >> ${BUNDLE}

MODULES=$(cat ${BUNDLE} | grep -o 'require("[a-ZA-Z0-9]\+")' | grep -o '".*"' | sed 's/"//g')
#echo "INFO: Required modules: ${MODULES}"

# Register modules via `Modules.addCached()` method
# see: http://forum.espruino.com/comments/12899741/
#MODULES="FlashEEPROM DS18B20"
for MODULE_NAME in $MODULES; do
    if [[ -f "${MODULES_DIR}/${MODULE_NAME}.js" ]]; then 
        echo "INFO: * Adding module: ${MODULE_NAME}"
        MODULE_STR=$(uglifyjs ${UGLIFYJS_OPTS} -- ${MODULES_DIR}/${MODULE_NAME}.js | sed 's/\"/\\\"/g' | sed "s/\n//g")
        echo "Modules.addCached(\"${MODULE_NAME}\", \"${MODULE_STR}\");" >> ${BUNDLE}
    else
        echo "INFO: ### Module ${MODULE_NAME} is embedded??"
    fi
done 
