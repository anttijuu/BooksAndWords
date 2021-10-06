# Books and Words

This project contains several implementations of how to count the words in text files. All implementations are done using [Swift](https://www.swift.org) and execute from the command line.

Each of the implementation is implemented in a different programming style. The styles here are (mostly) from the book Exercises in Programming Style by Cristina Videira.

Each implementation has the following inputs:

1. A book file to handle,
1. A file that lists words that are ignored while counting the words,
1. The number of top words to report (usually 100 by default).

Sample book files and an ignore file can be found zipped in the samples directory.

Some projects may have additional inputs or options.

Details on how to build and execute the projects are explained in the readme of each of the projects.

Each project also has a `go.sh` shell script that launches the app after it has been build, with arguments. Modify or copy this as needed to test the implementation with different files.

## Dependencies

All implementations use the [Swift Argument Parser](https://github.com/apple/swift-argument-parser) package. Additional dependencies are used in some of the implementations.

## Who did this

The implementations are inspired by the book [Exercises in Programming Style by Cristina Videira Lopes](https://www.routledge.com/Exercises-in-Programming-Style/Lopes/p/book/9780367350208).

These implementations are used in demonstrating different approaches to problem solving in the Data Structures and Algorithms course at the Study program of Information Processing Science, Faculty of Information Technology and Electrical Engineering at the University of Oulu, Finland.

* (c) Antti Juustila
* INTERACT Research Group
* Study program for Information Processing Science
* University of Oulu, Finland
