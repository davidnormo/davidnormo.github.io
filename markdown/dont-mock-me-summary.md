# "Don't Mock Me" by Justin Searls at Assert(js) 2018 Summary

At [Assert(js)](https://www.assertjs.com/) 2018, Justin Searls ([@searls](https://twitter.com/searls)) gave a great and balanced talk about the value of mocking.

[Watch "Don't Mock Me" by Justin Searls at Assert\(js\) 2018](https://youtu.be/Af4M8GMoxi4)

## 1. Don't partially mock the subject
- may cause tests to fail unexpectedly in future
- When the test subject is partially mocked this is an antipattern called the "Contaminated Test Subject"

## 2.  Don't partially mock dependencies
- Partially mocking a module's dependencies is usually be caused by developers not wanting to "overmock" or not agreeing on how to mock properly.
- May cause ping-ponging between mocking and unmocking modules over time

## 3. Design tests to fail
- Decide when to do isolation testing (fully mock) and when to do logic testing (zero mocking)

## 2. Wrap awkward 3rd parties
- To protect your codebase from changes in the library
- to make mocking simpler in other tests

## 3. "Functions should do or delegate, never both"
- delegators can be isoltation tested via mocks
- ‎logic functions can be pure and tested behaviourly

## 4. Outside in testing with mocks
