# Outsource

Outsource demonstrates one programming style to solve the frequent words task, where an app reads a text file containing a book. App then calculates the most often used words and their frequencies from a text file, ignoring words listed in another file. 

Result could look like this:

```console
Listing 100 most common words.

130459 the
88163 and
69068 of
62796 ja
41071 to
32657 in
32104 he
27011 that
...
```

This implementation is demonstrating producing and handling *outsourcing* as a way to solve the problem, using Swift as the programming language. 

Outsourcing means here that the app is actually outsourcing the job to Unix commands. It is executing terminal commands in `zsh`: `tr`, `grep`, `sort`, `uniq`, `head` and `sed`, with one temporary file to do the job. Obviously the app works only in OS which has all these tools installed.

This implementation does not actually comply with the others. It doesn't handle the ignore file, that is still unfinished. Also it does count one character words, as the other implementations do not.

You can try this out using the bare command line command too, instead of this app. From the root directory, do:

```console
cat samples/WarPeace.txt | tr 'A-Z' 'a-z' | sed 's/--/ /g' | sed 's/[^a-z ]//g' | tr -s '[[:space:]]' '\n' | sort -r | uniq -c | sort -r | more -n100
```

And you will see the result from there too. This app just outsources the job to those commands.

## Dependencies

Outsource uses the Swift Argument Parser to handle the parameters, and the terminal commands (macOS, probably other *nix OSes too) listed above.


## Building and running

Build from the command line:

```console
swift build -c release
```

and then run the app to print 100 most frequent words in the book file:

```console
./.build/release/outsource path-to-book.txt path-to-ignore-file.txt 100 
```

Assuming the binary is (linked) in `./.build/release` and user gives the two text files
and the count of the most frequent words to print out. Text files must be UTF-8 encoded plain text files.


## Who did this

The implementation is inspired by the book [Exercises in Programming Style by Cristina Videira Lopes](https://www.routledge.com/Exercises-in-Programming-Style/Lopes/p/book/9780367350208). Though the book does not contain a programming style like this, I suspect.

* (c) Antti Juustila
* INTERACT Research Group
* Study program for Information Processing Science
* University of Oulu, Finland
