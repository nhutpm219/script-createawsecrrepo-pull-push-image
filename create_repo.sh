#!/bin/bash
#
# All Rights Reserved. Copyright (C) 2020, Hitachi, Ltd.
#
# Hitachi Confidential
# The information (or program) contained herein is Confidential Property of Hitachi, Ltd.
# Reproduction, use, modification or disclosure otherwise than permitted in the Agreement is strictly prohibited.

#for debug
#trap 'read -p "$LINENO: $BASH_COMMAND" key' DEBUG

items=$(cat $2)

function create_repo() {
    IFS=$'\n'
    count=0
    for item in $items
    do
      count=$((count+1))
      printf "$count. $item"
      IFS=' '
      read -ra arr <<< $item
      aws ecr create-repository --repository-name ${arr[2]} --region $1
      printf "$count. Created ECR Repo ${arr[2]}"
    done
}

function main() {
  create_repo "$1"
}

main "$@"
