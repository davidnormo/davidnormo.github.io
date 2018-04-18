echo "Cleaning posts/"
rm -r posts/*

# https://stackoverflow.com/a/29613573
quoteSubst() {
  IFS= read -d '' -r < <(sed -e ':a' -e '$!{N;ba' -e '}' -e 's/[&/\]/\\&/g; s/\n/\\&/g' <<<"$1")
  printf %s "${REPLY%$'\n'}"
}

getFilename="sed -E 's/markdown\/(.*).md$/\1/'"
mdToHTML="marked --gfm"

function genPost {
  file=$1
  sha=$2
  filename=$(echo $file | eval $getFilename)
  mkdir -p "posts/$sha/$filename"
  echo "Creating posts/$sha/$filename"
  # convert md to html
  content=$(git show $sha:$file | eval $mdToHTML)
  # add slashes so it can be used in sed replace
  content="$(quoteSubst "$content")"
  cat template.html | sed -e ':a' -e '$!{N;ba' -e '}' -e "s/{{content}}/$content/" > "posts/$sha/$filename/index.html"
}

# WIP
# ====================
# TODO: diff not off <commit>~1 but off of rev list
# ====================
function genDiff {
  file=$1
  sha=$2
  filename=$(echo $file | eval $getFilename)
  mkdir -p "posts/$sha/$filename/diff"
  echo "Creating diff posts/$sha/$filename/diff"
  content="<pre>"$(git diff --color $sha~1 $sha $file | ./ansi2html.sh --body-only 2>/dev/null)"</pre>"
  content="$(quoteSubst "$content")"
  cat template.html | sed -e ':a' \
  -e '$!{N;ba' \
  -e '}' \
  -e "s/{{content}}/$content/" \
  -e "s:<!-- {{styles}} -->:<link rel="stylesheet" href="/assets/diff-styles.css" />:" > "posts/$sha/$filename/diff/index.html"
}

files=$(find markdown -name "*.md")


# build posts only for markdown files that exist on HEAD
for file in $files; do
  for sha in $(git log --format=%h $file); do
    genPost $file $sha
    genDiff $file $sha
  done
done

for file in $files; do
  genPost $file "head"
  genDiff $file "head"
done

content=$(cat index.md | eval $mdToHTML)
content="$(quoteSubst "$content")"
cat template.html | sed -e ':a' -e '$!{N;ba' -e '}' -e "s/{{content}}/$content/" > "index.html"

echo "All done!"
tree posts
