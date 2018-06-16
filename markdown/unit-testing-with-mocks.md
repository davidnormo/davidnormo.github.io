# Unit Testing with Mocks

At [Assert(js)](https://www.assertjs.com/) 2018, Justin Searls ([@searls](https://twitter.com/searls)) gave
a great and balanced talk about the value of mocking. Stop reading. Watch the talk.
All of it. Or read my [Too long didn't watch](/posts/dont-mock-me-summary/head) summary for the more impatient among you
but the talk is much more entertaining.

<div style="text-align: center">[!["Don't Mock Me" by Justin Searls at Assert\(js\) 2018](https://i.ytimg.com/vi/Af4M8GMoxi4/hqdefault.jpg?sqp=-oaymwEZCNACELwBSFXyq4qpAwsIARUAAIhCGAFwAQ==&rs=AOn4CLCdoQgCsfIPHzbmmx2NGN-xGw7kSg)](https://youtu.be/Af4M8GMoxi4)</div>

Before Justin's talk I fell into the "avoid mocking unless absolutely necessary" camp.
I didn't consider the pros and cons of either approach. I didn't think of the scenarios
in which using mocks would actually improve my tests.

I had read Martin Fowler's [UnitTest](https://martinfowler.com/bliki/UnitTest.html) article
and often sited it, refering to the benefit of "socialable" unit tests. These are closer
to the real world usage of the units and were blackbox tests meaning that your tests weren't
aware of the implementation details. This meant that I could refactor the unit without
having to change my tests at the same time.

<div style="text-align: center"><img alt="Module A depends on B which depends on C and each has it's own socialable unit test suite" src="/assets/a-b-c-with-tests.png" width="400px" /></div>

But there were some pain points. If I tested `A` that depended on `B` which in turn also
depended on `C`, my test would be covering `B` and `C`. But `B` also had it's own unit tests
and those also covered `C`. And finally `C` would have it's own unit tests. It felt that in some cases,
despite the tests being at different levels of abstraction, that some cases were repeated throughout.

There are also the times that when I changed the behaviour of `C`, then tests for `A` and `B` would also fail.
Sometimes I would have to modify `A` and `B` to pass new arguments along but not as often as you might think.
There is this subtle coupling between the tests of `A` + `B` and the behaviour of `C`. Even though the tests don't
reference the implementation of `C`, I have to change the tests when `C` changes.

<div style="text-align: center"><img alt="Module A depends on B which depends on C2, unit tests for A and B are failing because C's behaviour has changed" src="/assets/a-b-c2-failing-tests.png" width="400px" /></div>

That starts to sound like a violation of the Single Responsibility Principle (SRP). Perhaps the cases I'm testing in `A` and `B`
should really live in the test suite for `C`. Then the tests in `A` could simply check that `B` was called
by using a mock. Likewise in the tests for `B` a mock can help to verify that `C` is being called correctly.

<div style="text-align: center"><img alt="Module A depends on B which depends on C2, unit tests for A and B are failing because C's behaviour has changed" src="/assets/a-b-c-with-mocks.png" width="400px" /></div>

What are the benefits of this approach?

- The duplicate test cases go away and will only exist in the test suite for `C`.
- The tests for `A` and `B` become much simpler, as they only specify the relationships between the unit under test and it's dependencies.
- When `C`'s behaviour changes `A` and `B`'s tests won't need to change (unless their contracts change)
- The other unspoken dependencies of `A` and `B` can also be mocked out, so we get the above benefits again for these other modules.

What are the drawbacks?

- The tests for `A` and `B` are now more coupled to the unit they are testing. Refactoring them may require changing the tests also.
- There is now no unit test the covers the real path through the three modules. To have the same level of confidence that the code works correctly, we require another test to cover the full path.
