# Events

Events demonstrates one programming style to solve the frequent words task, where
an app reads a text file containing a book. App then calculates the most often used words and their 
frequencies from a text file, ignoring words listed in another file. 

Result could look like this:

```console
Listing 100 most common words.
1. he.................. 32108
2. that................ 27021
3. his................. 20040
4. it.................. 16443
5. for................. 16186
6. with................ 16070
7. was................. 14628
8. not................. 13568
9. han................. 13296
10. him................. 12886
11. hanen............... 12428
...
```

This implementation is demonstrating producing and handling *synchronous callbacks* as a way to solve the problem, using Swift as the programming language. The style is often characterized by the Hollywood "do not call us, we call you" kind of programming.

Each of the workers (`LoadHandler`, `WordFilter`, and `WordCounter`) register themselves (or their functions) to the `EventDispatcher`. In registration, the workers tell which kind of events they are interested in. When the event is then dispatched to the `EventDispatcher`, it calls the registered functions with possible parameters.

## Dependencies

Events uses the Swift Argument Parser to handle the parameters.


## Building and running

Build from the command line:

```console
swift build -c release
```

and then run the app:

```console
./.build/release/events path-to-book.txt path-to-ignore-file.txt 100 
```

Assuming the binary is (linked) in `./.build/release` and user gives the two text files
and the count of the most frequent words to print out. Text files must be UTF-8 encoded plain text files.


## Who did this

The implementation is inspired by the book [Exercises in Programming Style by Cristina Videira Lopes](https://www.routledge.com/Exercises-in-Programming-Style/Lopes/p/book/9780367350208).


* (c) Antti Juustila
* INTERACT Research Group
* Study program for Information Processing Science
* University of Oulu, Finland
