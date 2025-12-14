---
layout: base.njk
tags: post
title: Circular Dependencies
date: 2019-02-02
summary: Circular or recursive dependencies are modules that eventually depend upon themselves. This causes unexpected errors at run time such as module exports seemingly being undefined...
permalink: circular-dependencies-js/
---

## Circular Dependencies

Feb 2, 2019

Circular or recursive dependencies are modules that eventually depend upon themselves. This causes unexpected errors at run time such as module exports seemingly being undefined.

### An example

Consider the following code

```js
// a.js
const { b } = require("./b");
function a() {
  b();
}
module.exports.a = a;
a();

// b.js
const { a } = require("./a");
function b() {
  a();
}
module.exports.b = b;
```

We have 2 modules, `a.js` and `b.js`. `a` depends on `b` and `b` depends on `a` - a circular dependency!

Let’s execute the code to see what happens:

```bash
$ node ./a
/Users/davidnormo/tmp/b.js:4
  a()
  ^

TypeError: a is not a function
    at b (/Users/davidnormo/tmp/b.js:4:3)
    at a (/Users/davidnormo/tmp/a.js:4:2)
    at Object.<anonymous> (/Users/davidnormo/tmp/a.js:7:1)
    ...
```

What happened? We got a `TypeError` which means that the error occured at runtime. The code was compiled by the JS engine (V8 in our case) so the circular dependency wasn’t caught early. This is because dependencies in Node are resolved at runtime, `require` is just another function.

When it came to executing the code, the stack trace tells us the story. Reading from the bottom upwards (I’ve cut out the start of the stack that references node internals):

- `at Object.<anonymous> (/Users/davidnormo/tmp/a.js:7:1)` This is the a.js module (as the module is wrapped in a function by node) at line 7, calls `a()`
- `at a (/Users/davidnormo/tmp/a.js:4:2)` At line 4 of a.js `a` calls `b()`
- `at b (/Users/davidnormo/tmp/b.js:4:3)` At line 4 of b.js `a` is called
- `TypeError: a is not a function` At this point the error is thrown.

So if `a` is not a function when `b` tries to call it, what is it? It’s `undefined`.

I don’t know exactly how the internal node module resolution mechanism works - it’s something I want to do a bit more research on - but this is one of the tricky cases.

The above example is obviously contrived to illustrate the point. The times I’ve found this out in the wild have had many more modules involves e.g.

```text
a -requires-> b -requires-> c -requires-> d -requires-> a
```

These are a lot harder to work out what is going on. You have to try and keep the module dependency tree in your head or keep all the files open in your editor.

### How to fix

In our simple example not only do the modules a.js and b.js depend on each other but the functions `a` and `b` call each other. This is a very tight coupling. If all the code was put in the same module the functions would call each other recursively until we get a “Maximum call stack size exceeded” error. In this case it is probably best to inline `b` into `a`.

In the case that the modules depend recursively but not the functions, you can extract out another module that doesn’t depend on one of the modules in the recursive loop. Or you can duplicate some code from one of the modules in the loop (a short term fix).

### Round up

So next time you see strange errors where module dependencies are inexplicably causing an error, think, it may be caused by a circular dependency!
