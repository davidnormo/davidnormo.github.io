---
layout: base.njk
tags: post
title: Re-thinking CSS-in-JS
date: 2025-07-11
summary: I really like JSS apart from, well almost everything. Time to build another one I suppose...
permalink: rethinking-css-in-js/
---

## Re-thinking CSS-in-JS

July 11, 2025

I really like the concepts of CSS-in-JS (or JSS). Being able to add styles alongside the behaviour feels natural. Changing styles based on UI state is easy. Styling components in isolation (i.e. no cascading) means that as the code grows the complexity of styling doesn't get in the way. Gone are the days where the code change grinds to a halt because of a specificity war between old and new CSS styles.

Except it hasn't.

All the JSS libraries render their styles to stylesheets, with class names. When those styles change, because of UI state for example, new stylesheets are created and added with new class names. So there's a subtle specificity gotcha hanging around: The ordering of the styles in the DOM.

Most of the time this isn't a problem because the library manages it for us. However, what if we are migrating between 2 styling libraries? For example between any major versions of material UI? One library can inject the styles in one order and the other in a different order 💥

JSS libs are also annoying for their generated CSS class names. Of course, if we are rendering these styles to stylesheets we need them and they need to be unique to avoid collisions. But in our unit tests the class names may change if we change the styles. So we need a way of un-uniquifying them in unit tests.

What about applying a style to a nested div from outside a component? "No problem" says JSS with atrocities like:

```ts
createStyles({
  root: {
    "& .someNestedDiv": {
      color: "red",
    },
  },
});
```

It's irritated me but I can make it work. I can get the styles to work eventually. Even with the occasional `!important` 👀 (I thought we were done with those days!)

And then there's the performance! What is going on in these JSS libs that they are impacting the speed of painting to the screen! Well, they have to gather up these styles, generate unique ids, render them into a stylesheet and clean up old stylesheets (hopefully) - and probably a whole lot more. All on the **main thread**. This is what they have to do in order for it all to work.

Surely there has to be a better way. All I want is: no cascading styles, no class names, no stylesheets. Basically just inline styles. But obviously I want things like `:hover` and media queries and animations which inline styles can't do.

This thought gnawed away at my brain, in the background, for a long time. Eventually, I had a few spare hours and thought "let's give it a go". And out popped...

[ninjass 🥷](https://github.com/davidnormo/ninjass)

```ts
import { createStyle } from "ninjass";

// A react example...
const MyComponent = () => {
  return (
    <div
      css={createStyle({
        color: "green",
        ":hover": { color: "red" },
      })}
    >
      Hello world!
    </div>
  );
};
```

<img alt="hello world gif" src="./helloworld.gif" />

This is barely more than a proof of concept but it can:

- Render JSS to inline styles
- Handle things like `:hover` and `@media (...)`
- It event supports SSR
- All with zero pre-compiling!

## How does it work?

Instead of the styles being written to a stylesheet they are added as inline styles to the DOM element. Then there's a bit of (nin)jazzy magic to handle things like hovers and media queries with their equivalent DOM APIs e.g. (`mouseover`/`mouseout` and `window.matchMedia`).

To make this work I had to monkey patch the DOM. Not in a "lets tweak how HTMLElement works so that WC3 will start crying and the TC39 committee will come at me with pitch forks" kind of way. Just enough monkeying around to hook into the `Element.prototype.setAttribute` behaviour and that's it.

"What about SSR?", I hear you ask. Well if the library is run on the server then
instead of working with the DOM APIs it serialises the styles as part of the HTML. Then when the HTML is parsed by the browser, the library will "hydrate" onto the DOM APIs - before the component tree is re-rendered.

This also means we get the minimum styles necessary returned from the server without any jiggerypokery or dark configuration magic.

## Conclusion

Will I be using ninjass in my next project at work? Probably not. Unless there's interest in it, I'm happy to just let it be my little therapeutic outlet.

JSS doesn't have to have the pitfalls it does today. I think we've just gone down a bad path and haven't stepped back far enough to reevaluate effectively.

<hr />

**You've read this far, I'm impressed. If you want to see more from ninjass (docs, examples, support for other things like `:focus` or another web framework), open an issue on [the repo](https://github.com/davidnormo/ninjass) or give it a star.**
