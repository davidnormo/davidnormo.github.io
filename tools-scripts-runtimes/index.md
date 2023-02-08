---
layout: base.njk
tags: post
title: Tools Scripts Runtimes
date: 2023-02-01
summary: ...
---

# Tools Scripts Runtimes

This is a personal reference of tools/scripts/runtimes/package managers etc that I use with some setup instructions.

## Homebrew

[https://brew.sh/](https://brew.sh/)

```bash
$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## git

```bash
$ brew install git
```

My .gitconfig

<script src="https://gist.github.com/davidnormo/52eb8a325706959f63fd2be0bba390e5.js"></script>

## tig

[https://jonas.github.io/tig/](https://jonas.github.io/tig/)

```bash
$ brew install tig
```

## tmux

[https://github.com/tmux/tmux/wiki](https://github.com/tmux/tmux/wiki)

```bash
$ brew install tmux
```

My .tmux.conf:

<script src="https://gist.github.com/davidnormo/a361d38eac62707941e7098eb98587f5.js"></script>

## zsh

[https://github.com/romkatv/powerlevel10k](https://github.com/romkatv/powerlevel10k)

```bash
$ brew install zsh
$ chsh -s /usr/local/bin/zsh
$ brew install romkatv/powerlevel10k/powerlevel10k
```

My .zshrc

<script src="https://gist.github.com/davidnormo/db7c74a5a4400732ab2c45bf2528a7bb.js"></script>

## Node (fnm)

[https://github.com/Schniz/fnm](https://github.com/Schniz/fnm)

Install Node.js and `npm`

```bash
$ brew install fnm
$ fnm use 16
```

## vim

Install a more recent version of vim. I used to have a fairly sophisticated .vimrc but now I just use it bare bones because I use VSCode as my code editor

```bash
$ brew install vim
```

## VSCode

[https://code.visualstudio.com/](https://code.visualstudio.com/)

Download the latest version from the website. If you signin then you can choose to sync all your settings 🎉
