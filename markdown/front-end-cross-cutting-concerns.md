# Front End Cross Cutting Concerns

Along with each bug or improvement comes a list of unwritten related functionality. 
In fact there are some items on this list that are common to all tasks that touch the UI.
There is a general term used for these types of requirements: cross cutting concerns.

What is a cross cutting concern? First, let's try to define what we mean by concern. 
Wikipedia provides this gem:

> ...a concern is a particular set of information that has an effect on the code of a computer program.

[source](https://en.wikipedia.org/wiki/Concern_(computer_science))

That doesn't exactly clarify things. A dictionary defintion looks a bit more promising:

**Concern** - _noun_ - "something that involves or affects you or is important to you" - [source](https://dictionary.cambridge.org/dictionary/english/concern)

So if we say our code is made up of multiple concerns, i.e. there are different bits that affect/are important to someone then a cross cutting concern (which I'll refer to as CCC onwards) is another concern that is intermingled in multiple other concerns.
And this is where the problems usually occur, with the intermingling. A CCC in its nature introduces coupling.

So what are some of theses pernicious CCCs? Here are a handful that I come in to contact with in UI codebases:

- Logging
- SEO
- Analytics
- Localisation
- Accessibility
- Cross Browser Compatibility
- Caching
- Error handling
- Asynchronous UI states
- State management

Some of these are more subtle that we give them credit. The dark art of Search Engine Optimisation (SEO) for example: by changing a UI component, what is the effect on our search ranking? Some on the other hand are more straightforward, logging for example.

The key thing to consider when dealing with coupling is - what will the impact of changing either of the modules be? 

For example, imagine a 
