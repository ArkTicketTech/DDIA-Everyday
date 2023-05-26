
#!/bin/bash

# Store the current directory
current_dir=$(pwd)

cd ../learning-notes
git diff HEAD^ HEAD | grep '^+' |  sed 's/^+//' >  $current_dir/temp_sainas.md


cd "$current_dir"

export TZ="Asia/Shanghai"
target_filepath="notes/$(date +'%Y/%m/%d')/sainas.md"

echo target_filepath: $target_filepath

mv temp_sainas.md $target_filepath

git status -s
