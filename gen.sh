echo "Cleaning posts/"
rm -r posts/*

function genPost {
	file=$1
	sha=$2
	filename=$(echo $file | sed -E 's/markdown\/(.*).md$/\1/')
	mkdir -p "posts/$sha"
	echo "Creating posts/$sha/$filename.html"
	# convert md to html
	content=$(git show $sha:$file | marked --gfm)
	# add slashes so it can be used in sed replace
	content=$(echo $content | sed 's/\//\\\//g')
	echo $postTemplate | sed "s/{{content}}/$content/" > "posts/$sha/$filename.html"
}

files=$(find markdown -name *.md)
postTemplate=$(cat template.html)

for sha in $(git log --format=%h markdown); do
	for file in $files; do
		genPost $file $sha
	done
done

for file in $files; do
	genPost $file "head"
done

echo "All done!"
tree posts

