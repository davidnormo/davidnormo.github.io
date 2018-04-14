Reuse logic, avoid duplication, maintain performance with transducers
=====================================================================

21 Oct 2016

“What now?” may have been your first reaction. This post looks at how we can use advanced functional concepts to make your code more composable (and therefore reusable!). This is not a new concept but it’s not familiar to a lot of developers especially outside of the Clojure community, where they were invented.

Transducers aren’t incomprehensible but they require a bit of patience and learning.

TL;DR
-----

**Pros:** Composable transformation pipelines which are independent of their input and output sources and they perform really well. they perform really well.

**Cons:** Transducers can be hard to get to grips with and they aren’t well known.

What is a “transducer”?
-----------------------

A transducer is a function that accepts a reducing function and returns a reducing function. That’s it. Transducers are often wrapped with an initialising function that take extra arguments to augment the behaviour of the transducer like so:

Fig. 1

    const map = (fn) => { // `map` returns the transducer
      return (rf) => { // the transducer, accepts a reducing function
        return (acc, x) => { // and returns a reducing function
          rf(acc, fn(x)); // ...that calls `fn` on every input `x`
        };
      };
    };

    // `map` doesn't know anything about the input or output,
    // neither does the function it accepts,
    // it only cares about the items it's reducing over
    // (`xf` just stands for transducer)
    const xf = map(x => x + 1)
    // `sum` knows what the output is: a number
    const sum = (total, x) => total + x;
    // ...`transduce` is passed the input: an array
    // `transduce` is like `reduce`
    // Let's transform the array by adding 1 to all
    // elements and reduce by summing the result
    transduce(xf, sum, 0, [1,2,3,4,5]); // 20


Transducers were introduced in Clojure but there are ports of it to Javascript! For a more comprehensive look at transducers check out the following resources:

*   [Transducers.js: A Javascript Library for Transformation of Data](http://jlongster.com/Transducers.js--A-JavaScript-Library-for-Transformation-of-Data) [\[1\]](#ref8654)
*   [Transducers](http://clojure.org/reference/transducers) [\[2\]](#ref245)
*   [cognitect-labs/transducers-js](https://github.com/cognitect-labs/transducers-js) [\[3\]](#ref8752)

What are the pros?
------------------

So, what’s good about them? Here is the breakdown of their offering:

1.  [Composable transforms](#composable-transforms)
2.  [Independent of their input and output](#independent-of-their-input-and-output)
3.  [Performant](#performant)

### 1\. Composable transforms

Composition gives developers the ability to pick and choose, to build up transformations from other transducers and combinations of transducers. Let’s build on our earlier example but say this time we only wanted to sum the first 3 elements.

Fig. 2

    // `comp` stands for compose, it returns a function that
    // chains the functions together.
    // basically it does this: `comp(a,b,c)(x) => a(b(c(x)))`.
    // In our case it returns a transducer!
    const xf = comp (
      pick(3), // `pick` returns a transducer that lets n elements pass
      map(x => x + 1)
    );
    transduce(xf, sum, 0, [1,2,3,4,5]); // 9


Pretty neat huh? Composition is less restrictive than method chaining as traditionally provided by lodash/underscore \[4\]. (Note: Lodash now supports functional composition via `flow`)

It’s also a nicer abstraction than working with reducing functions directly. Although there is a complexity overhead, transducers are still actually quite readable.

And because they are all just functions with the same signature you can get clever and compose pipelines!

Fig. 3

    const xf1 = comp( pick(...), map(...) );
    const xf2 = comp( keep(...), filter(...) );
    // comp chains functions right to left
    // but transducers get evaluated left to right
    // so below `xf1` is called before `xf2`
    const xf3 = comp(
      xf1,
      xf2,
      map(...)
    );


### 2\. Independent of their input and output

A transducer operates only on the elements of the collection and knows nothing of the collection or of the result of the reduction. It doesn’t know if you are reducing from an array to a number, or from a stream or object. So you can reuse transducers on different data structures.

Fig. 4

    // `x` is a number but it doesn't know where it came from!
    const xf = map(x => x + 1);

    // an array sum into a number
    transduce(xf, sum, 0, [1,2,3]);
    // an array into another array!
    into([], xf, [1,2,3]);
    // immuatable list to a number!!
    transduce(xf, sum, 0, List([1,2,3]));


That means you can write a transducer once and use it in many contexts. This is because a transducer captures the essence of its step and avoids being tied to the data structure. For example, `map` is concerned with taking an input and returning a transformed input.

### 3\. Performant

Transducers are performant because they don’t build intermediate data structures. Let’s make that statement more concrete. Consider the following, non-transducer, alternative to [fig. 1](#fig1):

Fig. 5

    const arr = [1,2,3,4,5];

    // our `pick` in terms of reduce
    const tmp = arr.reduce((acc, x, i) => {
      if (i < 3) {
        acc.push(x);
      }

      return acc;
    }, []);

    // our `map` in terms of reduce
    const result = tmp.reduce((acc, x) => {
      acc += x + 1;
      return acc;
    }, 0 );

    result; // 9


You’ll notice that `tmp` is just the result of our `pick` reduce. This is an “intermediate aggregate”. A collection that is just temporary before being passed to the next step in the pipeline. James Longster[\[1\]](#ref8654) says it nicely:

> ...transducers create no intermediate collections. If you want to apply several transformations, usually each one is performed in order, creating a new collection each time.
>
> Transducers, however, take one item off the collection at a time and fire it through the whole transformation pipeline. So it doesn't need any intermediate collections; each value runs through the pipeline separately.

If we break the rules of big O notation for a minute, fig. 1 is roughly O(n) and fig. 5 is O(2n). Strictly speaking we drop constants and low-order terms in big O notation so they are both O(n) but benchmarks point out that one is more performant than the other[\[5\]](#ref8234).

What are the cons?
------------------

To include transducers in a JS project, you need to weigh up both sides of the argument. So what are the issues to be aware of when using transducers?

1.  **Complexity**
    If you are new to the concept of transducers then you don’t need me to tell you that transducers are not a simple concept to grasp, especially if you aren’t familiar with functional programming concepts. You’ve got to consider the ability of your co-workers and the time it would take for them to get comfortable with transducers.

2.  **Documentation and awareness**
    Libraries such as lodash have much more extensive documentation, transducers - less so. There are many more questions/answers for using other solutions which aim to solve the same problems that transducers aim to solve. So if you get stuck with transducers, there is a greater risk that you will be stuck for longer.

3.  **You might not get all the benefits of transducers**
    Unless you have ONE of the following, I wouldn’t suggest to use transducers in a Javscript project:


*   Your reducing function logic is becoming unwieldy and you’d benefit from a more composable approach OR
*   You suffer from performance problems because of reasons stated in
    [section 3](#performant) OR
*   You use multiple data types such as custom iterable types, immutable.js types, streams, observables

Conclusion
----------

Transducers are a really nice abstraction over reduce. If you work in a functional style codebase they may just make a nice fit. If not, it’s worth learning the concepts behind them. I’d recommend watching the talk[\[6\]](#ref2341) by Rich Hickey, the inventor, of transducers who gives both a great intro and walks through the internals of them also.

References:
-----------

\[1\] "Transducers.js: A Javascript Library for Transformation of Data" by James Longster, 2014
[http://jlongster.com/Transducers.js--A-JavaScript-Library-for-Transformation-of-Data](http://jlongster.com/Transducers.js--A-JavaScript-Library-for-Transformation-of-Data)

\[2\] "Transducers", Clojure docs
[http://clojure.org/reference/transducers](http://clojure.org/reference/transducers)

\[3\] cognitect-labs/transducers-js github repository
[https://github.com/cognitect-labs/transducers-js](https://github.com/cognitect-labs/transducers-js)

\[4\] "Why using _.chain is a mistake" by Izaak Schroeder, 2016
[https://medium.com/making-internets/why-using-chain-is-a-mistake-9bc1f80d51ba#.ooakaw2vr](https://medium.com/making-internets/why-using-chain-is-a-mistake-9bc1f80d51ba#.ooakaw2vr)

\[5\] "Transducers.js Round 2 with Benchmarks" by James Longster, 2014
[http://jlongster.com/Transducers.js-Round-2-with-Benchmarks](http://jlongster.com/Transducers.js-Round-2-with-Benchmarks)

\[6\] "Transducers" by Rich Hickey, 2014
[https://youtu.be/6mTbuzafcII](https://youtu.be/6mTbuzafcII)