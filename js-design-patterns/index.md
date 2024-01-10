---
layout: base.njk
tags: post
title: JS Design Patterns
date: 2024-01-10
summary: Code design patterns have helped to build a language for constructing code in a way that people can understand and agree upon. However most of the examples of these patterns aren't used in Javascript which is where I spend most of my working time. Some of these patterns are used but they have a different expression in JS. So I thought I would document some of these using their original names but show examples of how I would expect these patterns to be expressed in JS.
draft: false
---

# JS Design Patterns

Code design patterns have helped to build a language for constructing code in a way that people can understand and agree upon. However most of the examples of these patterns aren't used in Javascript which is where I spend most of my working time. Some of these patterns are used but they have a different expression in JS. So I thought I would document some of these using their original names but show examples of how I would expect these patterns to be expressed in JS.

I may add to this list over time. If you have a suggested change or contribution feel free to open an issue on the github repo for this site: https://github.com/davidnormo/davidnormo.github.io

## Contents

- [Command](#command)
- [Strategy](#strategy)

## Command

[What is the Command pattern?](https://refactoring.guru/design-patterns/command)

In JS it't more typical to use a **callback** rather than a class. If there are many commands of the same type then the can be unified with a TS interface:

```ts
const handleSave = () => {
  // ... do something ...
};

// In this example `renderToolbar` isn't aware of how to save but hands it off to `handleSave`
renderToolbar({ onSave: handleSave });

// In a lot of cases there isn't a generic interface for callbacks that can be used interchangeably but when
// needed `renderToolbar` can define the type for it:

// renderToolbar.ts
type Options = { onSave: () => Promise<void> };
const renderToolbar = (opts: Options) => {
  // ...
};
```

## Strategy

[What is the Strategy pattern?](https://refactoring.guru/design-patterns/strategy)

In JS, we may use typescript interfaces still but it probably wouldn't be classes. The most common expression of the Strategy I've seen is to use an object to store the group of strategies and then to access them by some key:

```ts
// navigateBy.ts
enum NavigateType = {
  walk = 'walk';
  road = 'road';
  sea = 'sea';
}
type Navigation = (a: number, b: number) => void;

// `navigation` is an object that maps a navigation type string to a navigation function
// The Navigation type here enforces that all members match it. You can't add a function that doesn't match the type.
const navigation: Record<NavigateType, Navigation> = {
  walk: walkNavigation,
  road: roadNavigation,
  sea: seaNavigation,
}

// `navigateBy` calls the given navigation type function with the given parameters
export const navigateBy = (type: NavigateType, a: number, b: number) => {
  navigation[type](a, b);
}

// Alternatively we can just get the navigation function like this...
export const getNavigation = (type: NavigateType): Navigation => {
  return navigation[type];
}
```
