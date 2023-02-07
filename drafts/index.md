---
layout: base.njk
tags: post
title: Fun with Git Rebase
date: 2023-02-01
summary: ... 
draft: true
---

# Fun with `git rebase`

For these examples assume I have a local branch `featureA` which is currently checkedout, an upstream branch `origin/featureA` and have branched from `master`.

### Updating with upstream

```bash
$ git pull --rebase
```

### Updating with latest changes on `master`

```bash
$ git fetch -apt            # update remote branches and refs
$ git rebase origin/master
```

### Updating with `master` but keeping only the most recent commit

```bash
$ git fetch -apt
$ git rebase --onto origin/master @^
```
