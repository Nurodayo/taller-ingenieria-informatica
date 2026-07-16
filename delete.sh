#!/bin/bash

API="https://api.maidkissa.moe"
TOKEN="secreto"

curl -s -H "Authorization: $TOKEN" "$API/recorridos" |
  jq -r '.[].id' |
  while read -r id; do
    echo "Deleting $id..."
    curl -s -X DELETE \
      -H "Authorization: $TOKEN" \
      "$API/recorridos/$id"
    echo
  done

echo "Done."
