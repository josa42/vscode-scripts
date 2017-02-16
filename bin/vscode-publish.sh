#!/bin/sh

tag=$1

if [ $# -ne 1 ]; then
  echo "Usage: $(basename $0) <tag>"
  exit 1
fi

if git show-ref --tags --quiet --verify -- "refs/tags/$tag"; then
  echo "⚠️  Tag ${tag} exists"
  exit 1
fi

if [[ -n $(git status --porcelain) ]]; then
  echo "⚠️  Repository is dirty"
  exit 1
fi

vsce publish "${tag}" \
  && git add package.json \
  && git commit -m "Release ${tag}" \
  && git tag "${tag}" \
  && git push \
  && git push --tags