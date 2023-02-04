# davidnormo.github.io

Built with [`eleventy`](https://www.11ty.dev/)

- `npm start` to serve content locally
- `npm build` to build the site statically

## Deploying

```bash
$ git pull --rebase        # in case I've made changes somewhere else
                           # ... make changes on master
$ npm build                # to build the static files
$ git add .                # to add any new files (also manually delete files you've removed)
$ git commit -am "..."     # anything will do
$ git push                 # Push to deploy to github pages
```

## Notes

- This is hosted on github pages (obviously, remember?). It's deployed from the `master` branch, from the `docs` directory.
- Apparently GH only allow you to choose either the root or the docs directory to serve from.
- `eleventy` doesn't clean up removed files so you need to manually do that to the source .md files and the generated .html files.
