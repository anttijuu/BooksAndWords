# Functional

Functional demonstrates one programming style to solve the frequent words task, where an app reads a text file containing a book. App then calculates the most often used words and their frequencies from a text file, ignoring words listed in another file. 

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

This implementation is demonstrating [functional programming](https://en.wikipedia.org/wiki/Functional_programming) as a way to solve the problem, using Swift as the programming language. The code uses the Swift collection methods:

1. `filter` to filter out words to ignore from the array of words read from the file,
1. `reduce` to create a *dictionary* of words with word counts,
1. `sorted` to sort the dictionary by the word count,
1. `prefix` to select only top 100 elements from the dictionary, and finally
1. `forEach` to print out the top 100 elements to the console.


```Swift
words.filter { word in
   word.count >= 2 && !wordsToFilter.contains(word)
}.reduce(into: [:]) { counts, word in
   counts[word, default: 0] += 1
}.sorted(by: { lhs, rhs in
   lhs.value > rhs.value
}).prefix(topListSize).forEach{ key, value in
   print("\(String(counter).rightJustified(width: 3)). \(key.leftJustified(width: 20, fillChar: ".")) \(value)")
   counter += 1
}
```

## Dependencies

Functional uses the Swift Argument Parser to handle the parameters.


## Building and running

Build from the command line:

```console
swift build -c release
```

and then run the app:

```console
./.build/release/functional path-to-book.txt path-to-ignore-file.txt 100 
```

Assuming the binary is in `./.build/release` and user gives the two text files and the count of the most frequent words to print out. Text files must be UTF-8 encoded plain text files.


## Who did this

The implementation is inspired by the book [Exercises in Programming Style by Cristina Videira Lopes](https://www.routledge.com/Exercises-in-Programming-Style/Lopes/p/book/9780367350208).


* (c) Antti Juustila
* INTERACT Research Group
* Study program for Information Processing Science
* University of Oulu, Finland
