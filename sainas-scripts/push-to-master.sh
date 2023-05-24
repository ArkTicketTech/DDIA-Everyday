
#!/bin/bash


set -x

filename=$(git status -s | grep "^A " )

if [[ $(grep -c "^A " <<< $filename) -ne 1 ]]; then
    echo "Expected one file, but got $(grep -c "^A " <<< $filename)"
    exit 1
fi

if [[ $(grep -c "sainas.md" <<< $filename) -ne 1 ]]; then
    echo "Wrong file added"
    exit 1
fi

echo "Will push $(sed 's/^A  //' <<< $filename) to main"
git checkout main || exit 1
git commit -m "Create sainas.md" || exit 1
git push || exit 1
echo "Pushed to main"
git checkout sainas-scripts
