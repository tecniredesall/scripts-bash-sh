#!/bin/bash
path=$1
folder=$2
echo $path 
cd $path
rm -rf $folder 2> /dev/null
mkdir $folder 2> /dev/null
git reset --hard
git checkout -b branchTemp 2> /dev/null
git branch -D master 2> /dev/null
git branch -D staging 2> /dev/null
git branch -D development 2> /dev/null
git branch -D develop 2> /dev/null
git checkout --track origin/master && git branch -r --merged master  --sort=-committerdate --format="%(committerdate:short) | %(refname:short) | %(authorname)" > "$folder/branch_master.txt" 2> /dev/null
git checkout --track origin/staging && git branch -r --merged staging  --sort=-committerdate --format="%(committerdate:short) | %(refname:short) | %(authorname)" > "$folder/branch_staging.txt" 2> /dev/null
git checkout --track origin/develop && git branch -r --merged develop  --sort=-committerdate --format="%(committerdate:short) | %(refname:short) | %(authorname)" > "$folder/branch_develop.txt" 2> /dev/null
git checkout --track origin/development && git branch -r --merged development  --sort=-committerdate --format="%(committerdate:short) | %(refname:short) | %(authorname)" > "$folder/branch_develop.txt" 2> /dev/null
git branch -D branchTemp 2> /dev/null
git checkout master 2> /dev/null
git branch -v
echo "\n\n\n"




# git rev-list origin/revert-b83ea893 --format="%p | %P | %an %ad %D  %h" --max-count=1 --merges

# git rev-list master --format="%p |  | %an %ad %D  %h" --max-count=30 --merges 

# git rev-list master --format="%p | $P | %an %ad %D  %h %s" --max-count=10 --merges



