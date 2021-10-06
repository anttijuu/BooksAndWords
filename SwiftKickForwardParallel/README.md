# Kick Forward Parallel

Kick Forward Parallel demonstrates one programming style to solve the frequent words task, where
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

This implementation is demonstrating a variation of the pipeline style, *kick forward* as a way to solve the problem, using Swift as the programming language. Additionally, several threads are used to, in parallel, handle the large file in chunks in various async queues. When each of the queues have done their work, they copy their result into a global wordcount storage. This is protected by a semaphore so that only one async thread at a time can write to the global wordcount storage.

Compare this implementation to the synchronous one thread implementation in Kick Forward project. The multiple async task queue is more efficient with large files. Synchronous implementation took 2.59091 secs to handle a file as this parallel implementation took 1.91931 secs. 

Probably with small files the overhead of managing async queues makes the parallel implementation slower. Check out yourself!

The problem solution has been implemented in steps, each step executed in one function. Additionally, each function has, as the last parameter, a function to call next after that function has done it's part of the job.

## Dependencies

Kick Forward Parallel uses the Swift Argument Parser to handle the parameters.


## Building and running

Build from the command line:

```console
swift build -c release
```

and then run the app:

```console
./.build/release/kickforward path-to-book.txt path-to-ignore-file.txt 100 
```

Assuming the binary is in `./.build/release` and user gives the two text files
and the count of the most frequent words to print out. Text files must be UTF-8 encoded plain text files.


## Who did this

The implementation is inspired by the book [Exercises in Programming Style by Cristina Videira Lopes](https://www.routledge.com/Exercises-in-Programming-Style/Lopes/p/book/9780367350208).


* (c) Antti Juustila
* INTERACT Research Group
* Study program for Information Processing Science
* University of Oulu, Finland
