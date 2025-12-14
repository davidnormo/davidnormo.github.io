---
layout: base.njk
tags: post
title: Binary Addition
date: 2024-01-22
summary: Nothing ground breaking but just some practice to keep sharp. Write a function that takes 2 numbers, adds them and returns binary as a string.
permalink: binary-addition/
---

# Binary Addition

Nothing ground breaking but just some practice to keep sharp:

```ts
// Write a function that takes 2 numbers, adds them and returns binary as a string.
// addBinary(1,2) -> "11"
// addBinary(20, 30) -> "110010"
```

Sounds straight forward but I had actually forgotten how to convert a decimal number to binary (without cheating by using something like [`Number.prototype.toString`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/toString)). Turns out the algorithm is trivial:

```ts
// 50 divided by 2 is 25, remainder 0
// 25 divided by 2 is 12, remainder 1
// 12 divided by 2 is 6,  remainder 0
// 6 divided by 2 is 3,   remainder 0
// 3 divided by 2 is 1,   remainder 1
// 1 divided by 2 is 0,   remainder 1

// The binary is all the remainders in reverse: "110010"
```

So here goes:

```ts
function addBinary(a: number, b: number): string {
  let s: number = a + b;
  let bin = "";
  while (s > 0) {
    // `s` modulo 2 gives the remainder which we prepend to the string
    bin = String(s % 2) + bin;
    // Update `s` by dividing and flooring to remove the remainder
    s = Math.floor(s / 2);
  }
  return bin;
}
```

Nice little warm up.
