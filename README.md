# Let's Play: Refactor the Mega-Controller

Hello! This project needs some explanation.

This is the companion source for a talk I've been giving under the same name. You can [watch the "improvised" version](https://realm.io/news/andy-matuschak-refactor-mega-controller/) of it at Realm; this source corresponds to a more prepared version I gave at NSSpain.

The idea is to take a highly-coupled, highly-ugly view controller implementation and to incrementally isolate, abstract, and test components of it, reducing dependencies of each piece along the way.

I've tried to use this project to demonstrate some of the architectural design principles I've been developing for Swift. The source probably won't make much sense outside of the context of the talk, but perhaps in time I'll annotate the source with docstrings so that it can be read on its own.

If you're reading this outside the context of my talk, I'll offer this caveat: all added layers of abstraction also add complexity. Not all of these steps will necessarily be worth it given the tradeoffs of your own project. This project attempts to demonstrate aggressive isolation for instructive purposes, but I don't always advocate that in practice.

## How to read the refactorings

The progressive refactorings are represented in the Git history. `HEAD` represents where the refactoring stopped. You'll want to step back to the first revision, then step forward to see how each step was refactored.

## Now you try!

I did these refactorings pretty quickly. You should feel free to try your hand at cleaning up this awful view controller on your own; send me pull requests, and we'll chat about 'em!