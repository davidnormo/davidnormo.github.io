---
layout: base.njk
tags: post
title: React 19 - use
date: 2024-12-07
summary: ...
draft: false
---

# React 19 - `use`

This week React 19 was released (5 Dec). I've had a look through of the feature set and wanted to share some thoughts. There's a lot to go through so I'll just start with one of the new APIs: `use`.

React documentation on [react.dev](https://react.dev/reference/react/use).

## Overview

`use` is not a hook but follows most of the same rules. It acts as resolving a resource (either a Promise or Context). For example, previously you might be doing something like this:

```tsx
import { fetchFriends } from "./api";

// Fetch when module is initialised
const friendsPromise = fetchFriends();

const FriendList = () => {
  const [friends, setFriends] = useState([]);

  useEffect(() => {
    friendsPromise.then((data) => setFriends(data));
  }, []);

  // ....
};
```

Now with `use` it might look like this:

```tsx
import { fetchFriends } from "./api";

// Fetch when module is initialised
const friendsPromise = fetchFriends();

const FriendList = () => {
  const friends = use(friendsPromise);

  // ....
};
```

`FriendList` will suspend until `friendsPromise` either resolves or rejects. The nearest suspense boundary will show the fallback while suspended. If the promise resolve the component will be rendered and the contents shown. If the promise rejects then the nearest error boundary will be triggered.

## Hook-ish

As mentioned earlier, `use` follows all the same rules of hooks apart from it's also allowed in/after flow control statements (`for`/`while`/`if` etc). So if your component returns early it can be followed by `use`. I suppose this means a component may/may not suspend depending. Otherwise it's usage should follow the same rules as the other hooks.

I'm not a huge fan of this divergence. It was bad enough when hooks came out that they have these "rules" and we can't treat them exactly like regular functions. But over time we've gotten use to it and I suppose the same will be said of this. Hopefully the linting rules will be updated to handle this difference to the hooks.

## Final Thoughts

I've been waiting for this API for a while and glad to see that it's in the v19 release. Anything that means I don't need to write another `useEffect` is a good thing in my books (but perhaps that's a topic for another time).

There are some gotchas, namely that React doesn't handle caching of promises (yet?). So if the promise is created in the component render then it may be re-created multiple times. This caching, apparently, can be handled by "suspense powered" libraries - although I'm not sure what the API for that looks like yet.

Most of the projects I work on day to day still have the request promises managed outside the React render cycle so this isn't a feature I'll be using regularly. It will be interesting to see how libraries will make use of it or encourage it's use alongside their APIs.
