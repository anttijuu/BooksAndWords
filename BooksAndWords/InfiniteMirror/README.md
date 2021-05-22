# Infinite Mirror

Infinite Mirror demonstrates one programming style to solve the frequent words task, where
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

This implementation is demonstrating *recursion* as a way to solve the problem using Swift as the
programming language.

A function `count` is called recursively to handle smaller and smaller pieces of the array to collect the word counts from the array of words, read from the book file.


## Dependencies

Infinite Mirror uses the Swift Argument Parser to handle the parameters.


## Building and running

Build from the command line:

```console
swift build -c release
```

and then run the app:

```console
./.build/x86_64-apple-macosx/release/infinitemirror path-to-book.txt path-to-ignore-file.txt 100 
```

Assuming the binary is in `./.build/x86_64-apple-macosx/release` and user gives the two text files
and the count of the most frequent words to print out. Text files must be UTF-8 encoded plain text files.

If you have issues with stack overflow, try changing the `recursionLimit` to something smaller than currently in the code:

```Swift
let recursionLimit = 10_000
```
This is because with large data sets, the recursive function call stack becomes very deep, and the stack memory reserved for the app may run out of space. Therefore, the level of recursion is limited so that the array of words is processed in pieces that should not cause stack overflow. The `recursionLimit` can be used to control this.

## Who did this

The implementation is inspired by the book [Exercises in Programming Style by Cristina Videira Lopes](https://www.routledge.com/Exercises-in-Programming-Style/Lopes/p/book/9780367350208).


* (c) Antti Juustila
* INTERACT Research Group
* Study program for Information Processing Science
* University of Oulu, Finland
