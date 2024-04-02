---
layout: base.njk
tags: post
title: Open/Closed React.js
date: 2024-30-03
summary: I don't see this principle used a lot in front end code bases but it really should.
---

## The Open Closed Principle in React.js code bases

Imagine we are building the UI for an online airline checkout. Users choose their flight, then can choose a series of options before paying. We'll hone in on the options code. In the first iteration we add support for the first option which just has an `open` boolean flag. The code we are writing is a small summary list that shows the options the user has selected:

```ts
export type Option = {
  open: boolean;
}

export default function OptionsList({ options }: { options: Option[] }) {
  return options.map((option) => (
    if (!option.open) {
      return null;
    }

    return <OptionItem option={option} />
  ));
}
```

If the option is not `open`, then we don't render it. Pretty simple right? Next we add the next option which has a `startDate`:

```tsx
export type Option = {
  open?: boolean;
  startDate?: string;
}

export default function OptionsList({ options }: { options: Option[] }) {
  return options.map((option) => (
    if (!option.open || !option.startDate) {
      return null;
    }

    return <OptionItem option={option} />
  ));
}
```

So now an `Option` can have either `open` or `startDate`. If either of those is falsy then we don't render the option. This is still simple code, right?

No. This is not simple. This was just easy to add. Why isn't this simple? Because it's complex, meaning that we are interweaving things that should be separate. Or another way of putting it is we are introducing coupling between `OptionsList` and every type of option.

Imagine now we are adding another option type, this time with a `checked` property:

```tsx
export type Option = {
  open?: boolean;
  startDate?: string;
  checked?: boolean;
}

export default function OptionsList({ options }: { options: Option[] }) {
  return options.map((option) => (
    if (!option.open || !option.startDate || !option.checked) {
      return null;
    }

    return <OptionItem option={option} />
  ));
}
```

Again, this looks deceptively simple. But we are just adding more stuff into the ball of mud. So why is this code bad?

1. When we add a new option we need to remember all the places we need to update to support it. In the example above, we need to remember to update our `if` statement to not render it when it's not selected.

2. If we want to delete this option in future, we need to do the same. Otherwise we have dead code floating around the code base that isn't used and just adds cruft and extra bytes to our bundles.

3. The `Option` type isn't very helpful. It's just a bag of optional properties that doesn't give us any understanding of when one property exists and another doesn't.

The reason why this code violates the Open Closed Principle is that `OptionList` is not closed to modification. It's only technical open to extension if 2 different options share the same properties. But that's also a it grim.

Let's refactor this so that we close it to modifications but keep it open to extension:

```tsx
// Option.ts
export interface Option {
  isSelected() => boolean;
}

// OptionList.tsx
export default function OptionsList({ options }: { options: Option[] }) {
  return options.map((option) => (
    if (!option.isSelected()) {
      return null;
    }

    return <OptionItem option={option} />
  ));
}
```

Now, when a new option is added or removed, no change to `OptionList` is needed.

Let's take a look at some of our options:

```tsx
// OpenOption.ts
class OpenOption implements Option {
  constructor(public open: boolean) {}

  isSelected() {
    return this.open;
  }
}

// DatedOption.ts
class DatedOption implements Option {
  constructor(public startDate: string) {}

  isSelected() {
    return !!this.startDate;
  }
}

// CheckedOption.ts
class CheckedOption implements Option {
  constructor(public checked: boolean) {}

  isSelected() {
    return this.checked;
  }
}
```

Quick pause. If the use of classes is starting to make you feel uneasy and imaginings of OOP and Java are coming to mind, hold on. Don't snub it just yet. Let's see where this takes us. We all have preferences, some not very objective let's be honest. In the name of clean code, let's press on and see if we can find some treasure.

Looking at the above code, you may be asking "Dave, how do these new classes get used? Surely we'd have to change some code somewhere to add them in!" Yep, we would and here's how:

```tsx
// OptionFactory.ts
export const optionFactory = (opt: Record<string, any>): Option => {
  switch (true) {
    case typeof opt.open === 'boolean':
      return new OpenOption(opt);
    case typeof opt.startDate === 'string':
      return new DatedOption(opt);
    case typeof opt.checked === 'boolean':
      return new CheckedOption(opt);
    default:
      return new UnknownOption();
  }
}

// CheckoutPage.tsx
function CheckoutPage() {
  const [options, setOptions] = useState<Option[]>([]);
  useEffect(() => {
    fetchOptions().then(opts => {
      setOptions(opts.map(opt => optionFactory(opt))
    });
  }, []);

  return <>...<OptionList options={options} />...</>
}
```

So when we'll need to keep the factory up to date when we add and remove new `Option` types but not all the places that use the options.

You may be thinking "That's way more code! How is that simpler?!" It is simpler because `OptionsList` doesn't know anything about the internals of each option. Although we've added more code (which was less easy) we have made the code simpler. Notice particularly that there is no large conditional that combines all of the options together.

So at this point, the code was less easy to make simpler than just adding the extra conditon in `OptionsList`. Isn't writing easy code more maintainable? If all code is easy to write, it's easy to maintain, right? This is an interesting problem. Because on one side, yes easy code is easy to maintain. But on the other, if we always write easy code then it doesn't stay easy.

All code starts out easy. Writing something from scratch is easy. But without simplifying it, easy code becomes more and more complicated. As we add more and more conditions and branches the code becomes less understandable. Eventually it is no longer easy to change and the only option is to rewrite everything and start again.

However, what happens when we spend a bit more time and care to make the code simpler? The code is not so complex and remains at a constant level of easiness to change.

Here is an interesting question to ask ourselves: is the simpler code easy to understand? As you've seen this code evolve, your understanding of `OptionList` is quite clear. However imagine reading it for the first time. You'd understand that in some cases an option isn't rendered but you don't see the specific circumstances. We've hidden that level of information. We've added a layer of indirection which introduces a mental cost to understand. But the tradeoff is that our code is less coupled. So if newbies come to the code, they will need to take some time to understand what is going on before it becomes apparent. Once that context is loaded into their brains they are able to work more easily with the code.

Now, imagine testing `OptionList`. In our first version we need to add more tests for the large `if` statement we were building. With every condition added we'd be adding more and more tests for `OptionList`. However, now with the closed version there's nothing new to test! We can pass a `MockOption` that tests the call to `isSelected()` and we are done.

## Round Up

Now it's confession time. I have never seen code like this in a React (or any UI) code base. Perhaps there's some ideas like the above in some libraries but not where the majority of my work is done. I've seen plenty of "this was easy now it's a mess" code in UI code bases. I have some theories as to why that is but perhaps that's for another time.

We've used classes here but they could quite easily have been plain objects. Or using a library that provides multimethods or something similar - any construct that provides us with polymorphism would work really. But classes, at this point of time, are the de facto built in construct. You never know, maybe JS will get type classes at some point. So while I've used classes above, I would not use inheritance, perhaps only sparingly.

Ok. So here we are. We have some pretty clean code. It mixes the functional patterns used in React with a sprinkling of OOP for some polymorphic goodness. Perhaps those golden oldies were right after all? Perhaps it's the new dogs that need to learn old tricks.
