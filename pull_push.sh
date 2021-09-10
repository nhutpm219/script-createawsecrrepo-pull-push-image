#!/bin/bash
#
# All Rights Reserved. Copyright (C) 2020, Hitachi, Ltd.
#
# Hitachi Confidential
# The information (or program) contained herein is Confidential Property of Hitachi, Ltd.
# Reproduction, use, modification or disclosure otherwise than permitted in the Agreement is strictly prohibited.

#for debug
#trap 'read -p "$LINENO: $BASH_COMMAND" key' DEBUG

items=$(cat $4)

function pull_push() {

    podman login --username AWS --password $3 $2.dkr.ecr.$1.amazonaws.com
    IFS=$'\n'
    count=0
    for item in $items
    do
      count=$((count+1))
      printf "$count. $item\n"
      IFS=' '
      read -ra arr <<< $item
      podman pull ${arr[0]}:${arr[1]}
      printf "$count pulled ${arr[0]}\n"
      podman tag ${arr[0]}:${arr[1]} $2.dkr.ecr.$1.amazonaws.com/${arr[2]}:${arr[1]}
      printf "$count tagged ${arr[0]}:${arr[1]}\n"
      podman push $2.dkr.ecr.$1.amazonaws.com/${arr[2]}:${arr[1]}
      printf "$count pushed ${arr[0]}\n"
    done
}

function main() {
  pull_push "$1" "$2" "$3"
}

main "$@"
