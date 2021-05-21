# Bad Book

Bad Book demonstrates one programming style to solve the frequent words task, where
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

This implementation is demonstrating a *naive* way to solve the problem, using Swift as the programming language. 

Why naive and therefore bad, as the name of the project implies? While the solution works, and is fast with small text files, it fails with big files -- the performance is not acceptable. A small text file, like the book *War and Peace* by Leo Tolstoy (3.2 Mb text file) is handled in a couple of secods, a larger 17.2 Mb text file takes over 167 seconds to handle. 

The implementation is based on simple loops and arrays as data structures, and finally using sorting to get the results.

The implementation is inspired by the book [Exercises in Programming Style by Cristina Videira Lopes](https://www.routledge.com/Exercises-in-Programming-Style/Lopes/p/book/9780367350208).

## Dependencies

Events uses the Swift Argument Parser to handle the parameters.


## Building and running

Build from the command line:

```console
swift build -c release
```

and then run the app:

```console
./.build/x86_64-apple-macosx/release/badbook path-to-book.txt path-to-ignore-file.txt 100 
```

Assuming the binary is in `./.build/x86_64-apple-macosx/release` and user gives the two text files
and the count of the most frequent words to print out. Text files must be UTF-8 encoded plain text files.


## Who did this

* (c) Antti Juustila
* INTERACT Research Group
* Study program for Information Processing Science
* University of Oulu, Finland
