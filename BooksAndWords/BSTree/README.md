# Binary Search Tree

BSTree demonstrates one programming style to solve the frequent words task, where
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

This implementation is demonstrating *binary search trees* as a way to solve the problem, using Swift as the programming language. 

Words are read from the book file, then place into the binary search tree in alphabetical order. If the word is already in the tree, the frequency count of the word is increased. When all (unique) words are in the tree, it is exported into an array and then sorted. Finally, the most common words by frequency count are printed.

In addition to producing the result, the app generates (if the -dot true option is specified) a [GraphViz](https://graphviz.org) dot file depicting the structure of the binary tree holding the words of the book. After executing the app, you can convert the .dot file to e.g. svg file (assuming you have GraphViz installed):

```console
dot -Tsvg dotgraph.txt -otree.svg
```

And then opening the svg file (most browsers know how to do this). Note that if the book file is very large having thousands of different words, the graphic representation becomes quite difficult to view. Use small enough text files with maybe hundreds of words only, to have a manageable viewing experience. 

**Remember** to delete the `dotgraph.txt` file before running the app again, since the code always *appends* to that file.

> Note that GrahpViz cannot handle special characters in the .dot file node names. For example, if the text contains a word like "$5000", it is not possible to generate the graph. Obvious solution would be to replace special chars with allowed ones when generating .dot node names, but that is left as an exercise to the reader. You could also add problematic words with special chars to the ignore list (second parameter for the app), to solve issues related to this.

The `TreeNode`,  `DotGenerator` and the `ToArrayVisitor` classes implement the [Visitor](https://en.wikipedia.org/wiki/Visitor_pattern) design pattern.

## Dependencies

BSTree uses the Swift Argument Parser to handle the parameters.


## Building and running

Build from the command line:

```console
swift build -c release
```

and then run the app:

```console
./.build/release/bstree path-to-book.txt path-to-ignore-file.txt 100 
```

Assuming the binary is (linked) in `./.build/release` and user gives the two text files
and the count of the most frequent words to print out. Text files must be UTF-8 encoded plain text files.


## Who did this

The implementation is inspired by the book [Exercises in Programming Style by Cristina Videira Lopes](https://www.routledge.com/Exercises-in-Programming-Style/Lopes/p/book/9780367350208).

* (c) Antti Juustila
* INTERACT Research Group
* Study Program for Information Processing Science
* University of Oulu, Finland
