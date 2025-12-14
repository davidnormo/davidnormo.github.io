---
layout: base.njk
tags: post
title: Designing a Query Lang
date: 2018-08-10
summary: A little over a year ago, I helped to design a query language (similar to SQL) for users of a wealth management product we were building. I worked on the initial language design and the front end experience while Bruno Felix built the final version and hooked it up to our client’s Java backend....
permalink: designing-a-query-lang/
---

## Designing a Query Lang

Aug 10, 2018

A little over a year ago, I helped to design a query language (similar to SQL) for users of a wealth management product we were building. I worked on the initial language design and the front end experience while Bruno Felix built the final version and hooked it up to our client’s Java backend.

The potential users of the product would not be DBAs, programmers or even be particularly computer savvy. Their day to day tools included Microsoft Excel and had grown so used to it that, during our first round of user testing, some were reluctant to use anything else. Therefore the product, including the query language, had to be simple enough for them to understand and be picked up quickly.

The dataset we were querying had values that changed over time as the records pointed to market positions whose value changed as the market did. Therefore a “SELECT” query didn’t return a single result but instead created a stream of results that we would need to continually render.

I wanted to transpile this query language into EPL to run in the Esper engine. I was unfamilar with Esper and EPL and if you are also, think of Esper as the database working on inbound streams of data and EPL is the query language to form an outbound stream of results. These were the tools being used by our client at the time.

I prototyped the query language in Javascript in a day or so, which pulled data from a randomly generated dataset. The aim was to see if I could write a simple query language, familarise myself with lexing, parsing, etc, and present it to the client as the main interface of the product which their users will interact with.

An example query may have been:

```text
get crypto where price > 200m
```

This would roughly translate to:

```sql
# Aggregate the position records (sum) and filter (where) the aggregates by those greater than 200 million.
SELECT * from (SELECT SUM(price) from Positions) where price > 200000000
```

We knew ahead of time that there was a limited number of columns and we knew the types of the columns which meant that we could infer the column aggregate function (sum, concat etc). That meant less syntax for the end user to learn, win!

It occurred to me that the user would probably want a lot of the same tools that developers use everyday to help them construct their queries, such as syntax highlighting and autocompletion. However we didn’t want the network latency to hinder the user experience; who wants to wait for a round trip before knowing there’s a syntax error! The final query language was § written using ANTLR which we’d use to generate the Java parser. Luckily, ANTLR also supports generating Javascript which we could use to parse the statements on the client, check for syntax errors, use the AST (Abstract Syntax Tree) for highlighting and for autocompletion.

Unfortunately I moved on from Signal Noise before seeing the final version. Although it was fun working on context free grammars and mixing more computer science stuff with software engineering, I have my doubts as to how successful the query language will be. Thinking of similar implementations such as Jira’s JQL, I don’t know how well used or liked it is verus filters and drop down menus. The client even said that they had tried a query language before without much success.

Still I learned a lot and had fun working with Bruno et al so for me it was a great success.
