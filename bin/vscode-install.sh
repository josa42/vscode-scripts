#!/bin/sh

file=$(vsce package | grep "Created" | sed 's/^Created: //')

if [[ "${file}" = "" ]]; then
  echo "⚠️  Something went wrong ¯\_(ツ)_/¯"
  exit 1
fi

name=$(cat package.json | grep name | sed 's/^\s*"name"\s*:\s*"//' | sed 's/",*$//')
publisher=$(cat package.json | grep publisher | sed 's/^\s*"publisher"\s*:\s*"//' | sed 's/",*$//')

if [[ "$(code --list-extensions | grep "${publisher}.${name}")" != "" ]]; then
  code --uninstall-extension "${publisher}.${name}"
fi

code --install-extension "${file}"