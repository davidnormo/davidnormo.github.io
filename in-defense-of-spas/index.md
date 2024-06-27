---
layout: base.njk
tags: post
title: In Defense of SPAs
date: 2024-06-27
summary: For a few years now there's been a lot of focus, in the React community, on Server-Side Rendering (SSR) and particularly Server Rendered Components (SRC). But SPAs still make sense in some contexts. Let me explain.
draft: false
---

# In Defense of SPAs

For a few years now there's been a lot of focus, in the React community, on Server-Side Rendering (SSR) and particularly Server Rendered Components (SRC). I think this makes a lot of sense given the constraints and use cases for frontend applications in many settings.

It's probably fair to say that the majority of frontend applications being built are public facing. Or at least have users on a plethora of devices and a wide spectrum of network conditions. In these scenarios, SPAs have their drawbacks and don't make a great first choice.

Typical SPAs require an upfront cost for users to download the initial JS bundle for the application. Once it's downloaded the browser has to parse and evaluate it, blocking the main thread and preventing snappy user interaction or from rendering other content such as fonts or images. This can cause a large delay in the time before the site is ready for use and potentially before a user even sees some content.

In some commercial settings, SPAs don't make a great choice. For example, imagine if Wikipedia were an SPA. Imagine waiting an extra few seconds before you can read the opening paragraph of a page. A user may just give up and go elsewhere to find the info they want. In this case prioritising content so it is the first thing loaded is exactly what users want. So it would make sense for Wikipedia's frontend architecture to follow a SSR approach (with CDN level caching etc).

But with all the hype of server components (and to be fair it's a novel solution that deserves a lot of interest), I don't want the community to forget other use cases where SPAs still make sense. Frontend development is a much more varied and fragmented field than most want to admit. It's easy see the world through your current circumstances and with your companies business constraints. But it's not the same for everyone. I'm sure there's someone out there that's still working on a Backbone.js application - and probably has a good reason for it!

So here's some more context and detail for why SPAs make a good choice - using the example of my current employer.

## The Internal Tool

I've worked at T. Rowe Price (TRP) for a little over 3 years and the majority of frontend applications built there will never see the light of public web. They are hidden, exposed only to our internal users. They are accessible only on the corporate network or via a VPN connection. The corporate network is extremely fast (>500Mbps) compared to some conditions in public web (e.g. goat farmers in Peru with a poor edge connection). The users devices are all company owned therefore we can safely make assumptions about device capability, screen sizes, browsers and versions etc.

TRP's business doesn't really include public facing web applications. The business offers long term investment products (funds) suitable for pensions and long term financial goals. These funds are run by Portfolio Managers and their teams. So TRP supports them by providing a suite of internally developed tools to help them understand their holdings, risk exposure, ESG data etc. This is very common across many financial services companies: banks, asset managers, hedge funds, insurers etc. The kind of content that users view in these applications are calculated values: tabular data and charts based on daily ingested, intra-day ingested or live data feeds.

Given these constraints, _almost_ all of the problems with SPAs no longer exist. Users can't go to a competitor if the page is slow to load. They won't mind waiting a few seconds for their content. In fact, they probably keep the applications open in the browser almost permanently anyway. There is no business imperative for some of the features of SSR.

In fact, with these constraints, SPA becomes a preferable option to SSR:

- SPAs are _generally_ simpler than SSR apps<sup>1</sup> because they only run in one context. SSR apps have to run in both server and client contexts which introduces complexity.
- We don't need much run-time infrastructure to support an SPA. We could have a static asset server or even use a CDN. This is a big one for reducing infra cost as well as maintenance overhead (think of node version upgrades).
- There's no tricky caching problems with dynamic content in pages because it's all stitched together on the client. Additionally, at TRP, there's very little customisation of data for the individual user - multiple users see the same content which just simplifies caching in general anyway.

## Conclusion

There is no silver bullet. No single solution that works in every situation. There are constraints to work with, tradeoffs to make. The conversation in frontend tech is more exclusive than it should be at times. But we all work from our own context and it can be hard to understand anyone elses - until they talk about them. So here I am, talking about mine and why SPAs make sense in them.

That means that some of the recent changes in React aren't more than "oh, that's nice". They are focusing on different problems now. With that said, I've really enjoyed the problems React had solved for years (unidirectional data flow, UI as pure functions etc). React is still relevant in my context even with the new advances not being something we'd necessarily need.

**Footnotes**

[1] This is not an absolute statement. Some SPAs are more complex than some SSR apps. I'm just making pointing out the architectural difference.
