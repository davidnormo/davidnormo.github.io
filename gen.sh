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
  earlierSha=$3
  laterSha=$4

  filename=$(echo $file | eval $getFilename)
  mkdir -p "posts/$filename/$sha"
  echo "Creating posts/$filename/$sha"

  # convert md to html
  content=$(git show $sha:$file | eval $mdToHTML)
  # add slashes so it can be used in sed replace
  content="$(quoteSubst "$content")"

  footer=$(cat templates/footer.html | sed \
    -e "s/{{earlier}}/$earlierSha/" \
    -e "s/{{later}}/$laterSha/")

  if [ "$earlierSha" != "$sha" ]; then
    footer=$(echo "$footer" | sed -E -e "s/<!--earlier (.*) -->/\1/")
  fi

  if [ "$laterSha" != "$sha" ]; then
    footer=$(echo "$footer" | sed -E -e "s/<!--later (.*) -->/\1/")
  fi

  footer="$(quoteSubst "$footer")"

  cat templates/post.html | sed -e ':a' -e '$!{N;ba' -e '}' \
    -e "s/{{content}}/$content/" \
    -e "s/<!-- {{footer}} -->/$footer/" \
    > "posts/$filename/$sha/index.html"
}

function genDiff {
  file=$1
  sha=$2
  filepath=${3-$sha}
  filename=$(echo $file | eval $getFilename)
  # get array of shas of file's history
  shas=( $(git log --format=%h $file) )
  i=0
  # find the index of $sha
  for s in "${!shas[@]}"; do
    if [[ "${shas[$s]}" = "$sha" ]]; then
      i=$s
      break
    fi
  done
  # get the sha previous to $sha
  prevSha=${shas[${i+1}]-$sha}

  mkdir -p "posts/$filename/$filepath/diff"
  echo "Creating diff posts/$filename/$filepath/diff"

  # if $prevSha and $sha are the same then just use $sha^ to get the correct diff
  diffContent=''
  if [ "$prevSha" != "$sha" ]; then
    diffContent=$(git diff --color $prevSha $sha $file)
  else
    diffContent=$(git diff --color $sha^ $file)
  fi

  content="<pre>"$(echo "$diffContent" | ./ansi2html.sh --body-only 2>/dev/null)"</pre>"
  content="$(quoteSubst "$content")"
  cat templates/post.html | sed -e ':a' \
    -e '$!{N;ba' \
    -e '}' \
    -e "s/{{content}}/$content/" \
    -e "s:<!-- {{styles}} -->:<link rel="stylesheet" href="/assets/diff-styles.css" />:" > "posts/$filename/$filepath/diff/index.html"
}

files=$(find markdown -name "*.md")


# build posts for every commit on every .md files
for file in $files; do
  fileShas=( $(git log --format=%h $file) )
  len=${#fileShas[@]}
  for j in "${!fileShas[@]}"; do
    # generate the post
    # some weird arithmetic to get the next or prev index within the bounds of the array :D
    genPost $file "${fileShas[$j]}" "${fileShas[$((j+1 < len ? j+1 : j))]}" "${fileShas[$((j-1 < 0 ? 0 : j-1))]}"
    # generate the diff since the last post
    genDiff $file "${fileShas[$j]}"
  done
done

# build the "head" posts aka latest versions
for file in $files; do
  commits=( $(git log --format=%h $file) )
  genPost $file "head" "${commits[1]-"head"}" "head"
  genDiff $file $(git log --format=%h $file | head -n1) "head"
done

# build the home page
content=$(cat index.md | eval $mdToHTML)
content="$(quoteSubst "$content")"
cat templates/post.html | sed -e ':a' -e '$!{N;ba' -e '}' -e "s/{{content}}/$content/" > "index.html"

echo "All done!"
tree posts
