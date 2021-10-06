# Kick Forward

Kick Forward demonstrates one programming style to solve the frequent words task, where
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

This implementation is demonstrating a variation of the pipeline style, *kick forward* as a way to solve the problem, using Swift as the programming language. 

The problem solution has been implemented in steps, each step executed in one function. Additionally, each function has, as the last parameter, a function to call next after that function has done it's part of the job.

In the beginning, the file is read using the function `readFile`, and it is given the next function (`filterWords`) to call:

```Swift
// readFile calls filterWords...
readFile(file: bookFile, function: filterWords)
```
Then in `readFile`, the `filterWords` function is called (as `function`) and it is given the next function `calculateFrequencies` to call:

```Swift
func readFile(file: String, function: ArrayArrayMapNoOpFunc) -> Void {
  .... 
   // ...filterWords calls calculateFrequencies...
   function(words, calculateFrequencies)
}
```
And so on, until the chain ends and all functions have been executed.


## Dependencies

Kick Forward uses the Swift Argument Parser to handle the parameters.


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
