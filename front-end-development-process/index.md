---
layout: base.njk
tags: post
title: Front End Development Process
date: 2023-02-14
summary: "..."
draft: true
eleventyExcludeFromCollections: true
permalink: false
---

# Front End Development Process

Feb 13, 2023

## Preamble

This process is for personal reference rather than something formal and complete. By writing the process down I can more easily consider and improve it over time.

I've split out each process by activity type (feature/bug/refactor) and tried to keep the number of steps short to help me remember them. Within each steps there will be many things to consider and not all of them applicable to the individual feature or bug I'm working on. The steps should be required but the considerations may not be.

## New Feature

Steps:

1. [Scope/Requirements/Understanding](#feature-scope)
2. [Test/Code/Refactor](#feature-code)
3. [Explorative testing](#feature-explorative-testing)
4. [Code review](#feature-review)
5. [Deploy](#deploy)

### <a name="feature-scope"></a>Scope/Requirements/Understanding

You may just scan through this list. For most "stories" in an existing product/project some of these may have already been considered. For newer projects they may not have it may take more time to go through.

This step feels like a callback to the old Waterfall&trade; days but doing this at the feature level will prevent you wasting time once starting to code and realising you need to stop. It takes a bit of discipline but worth doing. So stop, get a cup of tea and have a think.

Some of these details are worth adding to the ticket so 1) the team can see the info 2) you will probably forget it if you don't 3) it reduces cognitive stress by keeping less in your head. Don't be overly prescriptive, just write what is helpful.

<details>
<summary>What is the new thing?</summary>

This should be concise. Ideally a shortname (e.g. "sidebar" or "3rd party auth") with a 1 or 2 sentence summary. This is so you can easily communicate with the team/stakeholders. When you mention the shortname everyone knows what you are talking about or can use it as a search term to find related information.

Example:

> New Order  
> Allow user to create a new order from the product page.

</details>

<details>
<summary>Why are we building it?</summary>

Sometimes this is self explanitory where the need for it is obvious and can be excluded (e.g. "login page") - don't waste time and add extra fluff because of process. Sometimes the reason for something is nuanced or not obvious (e.g. "add load balancer").

Some teams want to stamp a key result or metric here. Just go with whatever the team want to do. This is project dependent. Some projects require strict reasoning on the feature level to go ahead because of cost or resource constraints. Some are just ongoing development and don't need it.

Example:

> This will enable users to buy stuff without neededing to call us up!

</details>

<details>
<summary>What are the main cases to consider?</summary>

Some teams use Given/When/Then statements which might be helpful. Usually just a line for each main case is pithy and clear enough. Sometimes it's helpful to call these Acceptance Criteria (ACs). These notes will be used by you and others in testing later so it's worth having them written down.

It might be that these are written ahead of any UX or design being done so it's best to avoid specifics about UI states, network requests etc.

Example:

> - If a user is logged in they can add to basket on the product page
> - If a guest user then they can also add to basket.
> - Restricted users can't add to basket.

</details>

<details>
<summary>Other considerations...</summary>
- What are the edge cases? (e.g. network timeouts and errors, browser back button)<br />
- UX considerations?<br />
- Are there any liscencing considerations?<br />
- Performance considerations? (page load, bundle size)<br />
- Runtime/efficiency considerations? (CPU/Memory/IO)<br />
- Security considerations? (parse inputs, escape outputs, cookies, information leaking etc)<br />
- Privacy considerations? (personal data, sensitve data e.g. credit card numbers)<br />
- Audit/logging/maintenance considerations?<br />
- Accessibility?<br />
- Does this require a feature flag?<br />
- Does this conflict with existing functionality?<br />
- Are the dependent assets ready? (images, UX wireframes, fonts etc)<br />
- How much time am I expected to spend working on it?<br />
</details>

### <a name="feature-code"></a>Test/Code/Refactor

TBC

### <a name="feature-explorative-testing"></a>Explorative testing

Once the bulk of the work is done, you probably have the main cases done. The temptation here is to jump to the code review step but you need to resist the urge and do some thorough testing of your own. Be responsible. Don't let others find things you've missed without checking.

### <a name="feature-review"></a>Code Review

A good code review is one that you'd be happy to review yourself. There's a good middle ground between not enough detail and too much detail.

### <a name="feature-deploy"></a>Deploy

TBC

## Bug

1. Reproduce/Evidence
2. Explore/Debug
3. Test/Code
4. Explorative testing

## Refactor
