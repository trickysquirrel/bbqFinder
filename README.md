# bbqFinder
An attempt at creating consistent code, otherwise known as side effectless code, and on the way look at how a clean architecture in a modern iOS app would look like (added in A/B testing on view controllers just to make things interesting)

**btw this is just a draft and is still heavily being worked on, but please feel free to contribute.**

This repo contains a basic swift mobile app to allow users to find bbq’s in Australia, see there location and directions and share them with others.  In here I’m attempting to create more consistent code base (read below) which becomes easier when starting to use architecture such as VMP or VIPER.  If your interested in those have a watch/read of the following two resources.  (note: architecture is still in flux which is why the view controller factor and the module factory are inconsistent and poorly written, I want to try a few things before i settle on an idea)

https://www.youtube.com/watch?v=o_TH-Y78tt4
https://www.objc.io/issues/13-architecture/viper/


Any way back to consistent code, or side affectless code.

eh? you say

Side effected code is code that changes it behaviour over time, which generally leads to these little beauties…

```
Terminating app due to uncaught exception 'NSGenericException', reason: '*** Collection <__NSDictionaryM: 0x1566aa130> was mutated while being enumerated.

Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '*** -[__NSSetM addObject:]: object cannot be nil’

Terminating app due to uncaught exception 'NSRangeException', reason: ‘-[ClassXXX _contentOffsetForScrollingToRowAtIndexPath:atScrollPosition:]: section (0) beyond bounds

Terminating app due to uncaught exception 'NSRangeException', reason: '*** -[__NSArrayI objectAtIndex:]: index 4294967295 beyond bounds [0 .. 1]'
```
oh how I love seeing these, and they are all cause by state.

Its important to note that these are real bugs reported on an app totally TDD unit tested all the way.  But because the codes behaviour changes over time its very difficult to capture these issues in unit test as those tests only test a snapshot of how you think the code works or is used, not actually how its used or works it works over time.

If we can somehow create more code who’s behaviour does not change over time (consistent code), e.g no matter the time or the thread the code is always consistent, could we decrease the number of issue shown above.  In doing so creating unit tests that tell us how the code works over its lifecycle and not just a snapshot.

One solution is to look at functional programming (FP).  Now I’m not advocating to ditch OOP and switch to FP all the way, but if we take a leaf out of the FP programming handbook and apply it to OOP I think we could improve things a bit.  One advantage FP has on this war on bugs is that it does not contain any state, therefore abolishing those bugs mentioned above. But I think my mind would explode right now if I had to rewrite all my apps in an FP style, and I’m not even sure where I would begin or if its 100% possible.

The premise is simple, in FP all functions are broken down to their smallest components and take in all the parameters required to do their job.  So in OOP if we created classes targeted at specific jobs who’s internal state does not change after creation, the the classes methods/functions should remains consistent no matter when or how they are run.

Before we move on, what would side affected code look like that we are trying to avoid…
```
@interface Command : ParentObject

@property (nonatomic, Strong) SomeClass *propertyA;
@property (nonatomic, Strong) SomeClass *propertyB;

- (void)executeWithCompletion:(CompletionHandler)completion;
- (void)doSomethingElse;

@end
```
You create the command, set the properties, then execute and wait for the response to be returned.  And yes you know this totally works without any issues as you have the tests to prove it and the code runs fine.

So where are the problems?

Well you’ve created some useful code, but there was a bug or two, so you’ve had to tweak a few things on the way, other developers have started to use the object elsewhere in ways you did not envisage, extending it a bit for more functionality.  Maybe they set propertyB before propertyA and without realising it now does something different (for those of you who override setters).  Maybe amending the properties after execute is called changes the outcome.  Maybe someone else owns propertyA who amends it during the execute of the class, or doSomethingElse is called at the wrong time, and who knows what is lurking in ParentObject.

Basically if something can happen it will happen, especially after code is refactored or expanded.  So if you create an object that can have side effects then its going to bite back at some point.

How can we make this better:
```
@interface Command : NSObject

- (Command)initWithPropertyA(SomeClass *)propertyA propertyB:(SomeClass *)propertyB;
- (void)executeWithCompletion:(CompletionHandler)completion;

@end
```

Now you can only create the command with the correct properties in the correct order.  Those properties can no longer be amended after creation.  We don’t need to worry about the parent class any more (injection over inheritance), and due to the removal of the other methods it now only does one thing, but does it really well.  

So are we all done?…

Well we still have an issue, probably the trickiest one.  Objects can easily be shared around and owned by many other objects, so even though our command does not change propertyA, whats to stop the second owner of propertyA changing its internals?  Maybe propertyA can change its own internal state?  The only way this really hangs together is if all classes/objects in the codebase never change their internal state.

If we wanted to achieve this in swift we would have to remove all mentions of ‘var’ as object properties.  But in iOS app’s as far as I’m aware we cannot remove these, for example IBOutlet’s and re-usable cells, basically most visual things need state.  The delegate pattern also relies on state, with weak to break the retain cycle.   As long as we have those types of objects then we will never achieve stateless code.  I guess you could create a non visual app that the user cannot interact with, not sure how popular that would be.

It looks like we are stuck with var properties for the meantime, at least we know the danger spots now, so lets try to have as few vars as possible, and where possible “tell don’t ask’ vars.

Multiple parent classes:
In other places were appropriate we can also reduce the effects of objects having multiple parents by (in swift) making them ValueTypes.  

Or more drastically (not done this yet) the class copies its injected objects.  I’ve bet you’ve seen this idea time and time again.  Ever seen anyone pass in a string to a class only to copy it so that if its amended externally it does not affect the class.  We happily do that with strings but never do this with other object types which probably have more of a say over how the class operates.
```
@property (nonatomic, copy, readonly) NSString *objectId;

- (instancetype)initWithObjectId:(NSString *)objectId {
    self = [super init];
    if (self) {
        _objectId = objectId.copy;
    }
    return self;
}
```
So the rules I want to follow in this app are..

1. Class properties are only ever set in init, and are not changed after that
2. Inject rather than inherit (although I’ve used inheritance in the tests, if I’m keeping the test code as clean as the working code then this should go at some point)
2. Unless required, objects do not have multiple owners
3. (Not done yet) Objects where possible protect themselves by making copies of classes they depend on
4. Keep each class simple and do one thing
5. In tests create objects as they are actual used in the running of the code and not how thought they are going to be used (maybe a clean architecture here can help out too with factors)
6. Its ok to have vars as long as their influence is local to the func that its declared in
7. Its ok to have vars but don’t ask them whats going on

If any one has got any other great ideas and would like to submit any changes let me know.
