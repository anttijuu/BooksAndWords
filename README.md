# Books and Words

This project contains several implementations of how to count the words in text files. All implementations are done using [Swift](https://www.swift.org) and execute from the command line.

Each of the implementation is implemented in a different programming style. The styles here are (mostly) from the book Exercises in Programming Style by Cristina Videira.

In addition to study different programming styles, an important goal of this effort is to find a way to handle *large* book files *fast* using different approaches.

Each implementation has the following inputs:

1. A book file to handle,
1. A file that lists words that are ignored while counting the words,
1. The number of top words to report (usually 100 by default).

Sample book files and an ignore file can be found zipped in the samples directory.

Some implementations may have additional inputs or options. See implementation readmes and code for details.

Details on how to build and execute the projects are explained in the readme of each of the projects.

Each project also has a `go.sh` shell script that launches the app after it has been build, with arguments. Modify or copy this as needed to test the implementation with different files.

## Performance comparison

The table below lists the implementation and the time performance of each implementation, from fastest to slowest.

Each implementation was built in release configuration: `swift build -c release`.

Measurements were done on Apple Mac Mini M1 with 16GB of RAM and 1 TB SSD disk. Only the terminal app (iTerm2) was running when executing the implemementations. Implementations were launched using the `go.sh` shell script present in each directory. Thus, the `Bulk.txt` file was used as the book, and `ignore-words.txt` was used as the ignore word file. Size of the Bulk.txt file is 17 069 578 bytes and it contains 2 379 820 words and 97 142 unique words.

| Implementation              |  Execution time (secs) |
|-----------------------------|-----------------------:|
| FunctionalParallel          |                1.44697 |
| SwiftKickForwardParallel    |                1.71460 |
| SwiftKickForward            |                2.03113 |
| InfiniteMirror              |                2.03755 |
| Functional                  |                2.40643 |
| BSTree                      |                2.79729 |
| SwiftPipeline               |                2.91402 |
| Events                      |                2.91830 |
| Outsource                   |                7.00010 |
| Persistence 1)              |               43.40234 |
| BadBook 2)                  |              139.83773 |

1) Note that the execution time of Persistence is the first run when the words in the book are inserted with word counts in a Sqlite database. The second run does not scan the book file but reads the word counts already produced, from the database. Then the execution time is only 0.02811 seconds. Lesson: if you need to do this many times, maybe consider caching the result e.g. in a database.
2) BadBook is a naive loop within a loop implementation, showing that O(m * n) time complexity with large data sets is not the way to do things. Here, n is the number of all words in a book while m is the number of unique words in the book file.

## Dependencies

All implementations use the [Swift Argument Parser](https://github.com/apple/swift-argument-parser) package. Additional dependencies are used in some of the implementations.

## Who did this

The implementations are inspired by the book [Exercises in Programming Style by Cristina Videira Lopes](https://www.routledge.com/Exercises-in-Programming-Style/Lopes/p/book/9780367350208).

These implementations are used in demonstrating different approaches to problem solving in the Data Structures and Algorithms course at the Study program of Information Processing Science, Faculty of Information Technology and Electrical Engineering at the University of Oulu, Finland.

* &copy; Antti Juustila, 2021-2022
* INTERACT Research Group
* Study program for Information Processing Science
* University of Oulu, Finland
