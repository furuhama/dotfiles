#!/bin/sh

# run `git fetch origin` for all directories
# in this folder (except for this shell script itself)

# function to run `git fetch` for a directory
function fetch_origin () {
  echo "fetching $1..."
  cd $1
  git fetch origin
  git fetch -p
  echo 'end'
  echo ''
  cd ..
}

# function to run fetch_origin for every directory
function fetch_all () {
  echo 'auto fetching start...'

  echo ''

  # iterate for every directory name
  # MEMO: "${0#*/}" means this shell script file name itself
  for dir_name in `ls | grep -v "${0#*/}"`
  do
    fetch_origin $dir_name
  done

  echo 'All repositories would be up to date!'
}

# main function
fetch_all

