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
	mkdir -p "posts/$sha"
	echo "Creating posts/$sha/$filename.html"
	# convert md to html
	content=$(git show $sha:$file | eval $mdToHTML)
	# add slashes so it can be used in sed replace
	content="$(quoteSubst "$content")"
	echo $postTemplate | sed "s/{{content}}/$content/" > "posts/$sha/$filename.html"
}

# WIP
function genDiff {
	file=$1
	sha=$2
	filename=$(echo $file | eval $getFilename)
	mkdir -p "posts/$sha/$filename"
	content=$(git diff --no-color $sha $file | eval $mdToHTML)
	content="$(quoteSubst "$content")"
	content=$(echo $postTemplate | sed -e ':a' -e '$!{N;ba' -e '}' -e "s/{{content}}/$content/")
	echo $content > "posts/$sha/$filename/diff.html"
}

files=$(find markdown -name *.md)
postTemplate=$(cat template.html)

# build posts only for markdown files that exist on HEAD
for file in $files; do
	for sha in $(git log --format=%h $file); do
		genPost $file $sha
	done
done

for file in $files; do
	genPost $file "head"
done

echo "All done!"
tree posts

