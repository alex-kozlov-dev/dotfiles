#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Create fillmurray.com placeholder
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🌆
# @raycast.argument1 { "type": "text", "placeholder": "Width" }
# @raycast.argument2 { "type": "text", "placeholder": "height" }

# Documentation:
# @raycast.author Alexander Kozlov
# @raycast.authorURL https://github.com/alex-kozlov-dev

echo "https://www.fillmurray.com/$1/$2" | pbcopy

