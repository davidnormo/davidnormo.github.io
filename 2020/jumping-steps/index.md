---
layout: base.njk
tags: post
title: Jumping Steps
date: 2020-04-14
summary: hired.com allows those looking for jobs to complete assessments to improve their prospects. One of the programming problems I had to solve was...
permalink: jumping-steps/
---

## Jumping Steps

Apr 14, 2020

hired.com allows those looking for jobs to complete assessments to improve their prospects. One of the programming problems I had to solve was:

> A flight of stairs has `n` steps, you are able to jump 1, 2, or 3 steps at a time.
>
> How many different ways are you able to climb the stairs in different combinations of jumps?
>
> E.g. n = 3 then the answer is 4 because: 111, 21, 12, 3

Somewhere in the back of my mind some maths with combinations and permutations came to mind. This seemed like the best approach to start with because the math would be much faster than the brute force approach.

But what was the equation? What it `n` factorial? Kind of, but there was something about only stepping 1, 2 or 3 steps at a time. I spent a _long_ time doing some trial and error. I did not get very far.

I decided to reassess. How hard would it be to brute force the solution? To generate all possible combinations and count them?

I started by writing down the results by hand:

> n = 3
>
> 111 21 12 3
>
> answer: 4
>
> ---
>
> n = 4
>
> 1111 211 121 112 22 31 13
>
> answer: 7
>
> ---
>
> n = 5
>
> 11111 2111 1211 1121 1112 221 212 122 311 131 113 32 23
>
> answer: 13

At this point my mind had a pattern for working out the answers.

All of them started with a string of 1s, `n` long. From their I replaced 1s with a 2 and ran through the different permutations: 111, 21, 12

Then I’d do the same but for 3 and find those permutations.

The results formed a tree that I could build recursively. So I started coding!

```js
const solution = (n) => {
  return consumeAndIterate(n, Array(n).fill(1).join("")).length;
};
```

The funny array expression is Javascripts silly way of filling a new fixed length array with values. `consumeAndIterate` will be my poorly named, recursive function. It will return an array with all the possible combinations, so returning the length with get me the final count.

```js
const consumeAndIterate = (n, str) => {
  const results = [];
  for (let i = 0; i < str.length; i++) {
    // But what do go here?
  }
  return results;
};
```

After I got the frame of the code out of the way, I stopped to think. How do I go from `'111' => '21'`? Well, I can add the current index and add it with the next and if they make 2 add it to my results array.

```js
const consumeAndIterate = (n, str) => {
  const results = [str];
  for (let i = 0; i < str.length; i++) {
    if (parseInt(str[i]) + parseInt(str[i + 1]) === 2) {
      results.push("2" + str.substring(i + 2));
    }
  }
  return results;
};
```

I hit a bug already. This works for `'111' => '21'` but not `'12'` because I’m not adding the substring onto the front of the string before pushing it into the results array.

```js
const consumeAndIterate = (n, str) => {
  const results = [str];
  for (let i = 0; i < str.length; i++) {
    if (parseInt(str[i]) + parseInt(str[i + 1]) === 2) {
      results.push(str.substring(0, i) + "2" + str.substring(i + 2));
    }
  }
  return results;
};
```

Ok great. So how about `'111' => '3'`…

```js
const consumeAndIterate = (n, str) => {
  const results = [str];
  for (let i = 0; i < str.length; i++) {
    if (parseInt(str[i]) + parseInt(str[i + 1]) === 2) {
      results.push(str.substring(0, i) + "2" + str.substring(i + 2));
    }
    if (parseInt(str[i]) + parseInt(str[i + 1]) + parseInt(str[i + 2]) === 3) {
      results.push(str.substring(0, i) + "3" + str.substring(i + 3));
    }
  }
  return results;
};
```

So for `n` = 3 this works. In terms of our tree, there is only 2 levels:

```text
    111
     ---------
     |   |   |
    21  12   3
```

But if `n` = 4 then the tree would look like:

```text
    1111
     -----------------
     |   |   |   |   |
    211 121 112  31  13
     |
     22
```

This is where the recursion needs to come into play:

```js
const consumeAndIterate = (n, str) => {
  const results = [str];
  for (let i = 0; i < str.length; i++) {
    if (parseInt(str[i]) + parseInt(str[i + 1]) === 2) {
      results.push(
        ...consumeAndIterate(
          n,
          str.substring(0, i) + "2" + str.substring(i + 2)
        )
      );
    }
    if (parseInt(str[i]) + parseInt(str[i + 1]) + parseInt(str[i + 2]) === 3) {
      results.push(
        ...consumeAndIterate(
          n,
          str.substring(0, i) + "3" + str.substring(i + 3)
        )
      );
    }
  }
  return results;
};
```

Another bug!

```js
consumeAndIterate(4, "1111");
// => ["1111", "211", "22", "31", "121", "13", "112", "22"]
// notice "22" repeated!
```

My solution at this point was to take this resulting array and remove duplicate values before returngin the length:

```js
const uniq = (arr) => {
  const obj = {};
  arr.forEach((x) => {
    obj[x] = undefined;
  });
  return Object.keys(obj);
};
const solution = (n) => {
  // start recursing with string of 1s
  let result = consumeAndIterate(n, Array(n).fill(1).join(""));
  // results aren't unqiue!
  return uniq(result).length;
};
```

That works but it isn’t the cleanest solution. We could prevent duplicate values from being added to the `results` array in `consumeAndIterate` if it knew which values had already been added…

```js
const replaceIndexWithNum = (str, i, num) => {
  return str.substring(0, i) + num + str.substring(i + num);
};

const consumeAndIterate = (n, str, results = {}) => {
  results[str] = true;

  for (let i = 0; i < str.length; i++) {
    const add2 = parseInt(str[i]) + parseInt(str[i + 1]);
    const strWith2 = replaceIndexWithNum(str, i, 2);
    if (add2 === 2 && !results[strWith2]) {
      consumeAndIterate(n, strWith2, results);
    }

    const add3 = add2 + parseInt(str[i + 2]);
    const strWith3 = replaceIndexWithNum(str, i, 3);
    if (add3 === 3 && !results[strWith3]) {
      consumeAndIterate(n, strWith3, results);
    }
  }

  return results;
};

const solution = (n) => {
  // start recursing with string of 1s
  const result = consumeAndIterate(n, Array(n).fill(1).join(""));
  return Object.keys(result).length;
};
```
