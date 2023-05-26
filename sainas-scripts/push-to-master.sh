
#!/bin/bash


set -x

filename=$(git status -s | grep "sainas.md" )

if [[ $(grep -c "^?? " <<< $filename) -ne 1 ]]; then
    echo "Expected one file, but got $(grep -c "^A " <<< $filename)"
    exit 1
fi

if [[ $(grep -c "sainas.md" <<< $filename) -ne 1 ]]; then
    echo "Wrong file added"
    exit 1
fi

filename=$(sed 's/^?? //' <<< $filename)

git checkout main || exit 1
git pull || exit 1
echo "Will push $filename to main"
git add $filename || exit 1
git commit -m "Create sainas.md" || exit 1
git push || exit 1
echo "Pushed to main"
