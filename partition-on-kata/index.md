---
layout: base.njk
tags: post
title: The Partition On Kata
date: 2020-04-03
summary: The partition on kata is as follows...
---

## The Partition On Kata

Apr 3, 2020

The partition on kata is as follows:

> Given the fn `partitionOn(predicate, arr)` modify array so that all items in the list are re-ordered with all items that fail the predicate are first and all items that pass it follow after. The return value of the the array should be the index of the first item that passed the predicate.
>
> For example:
>
> const arr = \[1,2,3,4,5\] partitionOn(isEven, arr) // => 3 console.log(arr) // => \[1,3,5,2,4\]

(My solutions below are in Javascript)

I’ve seen many solutions to this kata that try to make 2 separate arrays, one that pass the predicate and one that fail and then merge the 2 arrays at the end:

```js
function partitionOn(predicate, arr) {
  let f = arr.filter((e) => !pred(e));
  let t = arr.filter(pred);
  arr.length = 0;
  for (let i = 0; i < f.length; i++) arr.push(f[i]);
  for (let i = 0; i < t.length; i++) arr.push(t[i]);
  return f.length;
}
```

While this code looks asthetically pleasing (something to do with the double filter statements, followed by double for loops), it’s not very performant. It’s still O(n) but multiple subsequent loops won’t be great for long arrays.

There is a variation of this approach without the additional loops:

```js
function partitionOn(predicate, arr) {
  let t = [],
    f = [];
  items.forEach(function (val) {
    pred(val) ? t.push(val) : f.push(val);
  });
  items.length = 0;
  items.splice(0, 0, ...f.concat(t));
  return f.length;
}
```

Not bad. In terms of CPU performance it’s pretty good but memory? We have to allocate extra space for the pass and fail arrays. It’s still O(n) for memory but we can do better.

What if we don’t try to make 2 separate arrays. Can we change the array in place?

Here is my attempt:

```js
function partitionOn(predicate, arr) {
  let b = -1;
  for (let i = 0; i < arr.length; i++) {
    if (predicate(arr[i])) continue;

    b++;
    if (b === i) continue;

    let val = arr[i];
    arr.splice(i, 1);
    arr.splice(b, 0, val);
  }
  return b + 1;
}
```

Don’t be put off by the for loop and continue statements! We have a more performant algorithm in both CPU and memory. The algorithm is essentially this:

1.  Initialise `b` to -1
2.  For each item in array
3.  If item passes predicate continue to next item
4.  If item fails predicate increment `b`
5.  Remove item from array
6.  Insert item into array at position `b`
7.  return `b` plus 1

While the code may not be as pleasing and there is no use of those popular filter or forEach functions, the simple for loop makes for faster code.
