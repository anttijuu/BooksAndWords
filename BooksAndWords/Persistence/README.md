# Persistence

Persistence demonstrates one programming style to solve the frequent words task, where
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

This implementation is demonstrating using a *relational database* as a way to solve the problem, using Swift as the
programming language and SQLite as the database engine.

The implementation is inspired by the book [Exercises in Programming Style by Cristina Videira Lopes](https://www.routledge.com/Exercises-in-Programming-Style/Lopes/p/book/9780367350208).


## Dependencies

Events uses the Swift Argument Parser to handle the parameters and SQLite.swift as the API to SQLite database. See `Package.swift` for the dependencies.


## Building and running

Build from the command line:

```console
swift build -c release
```

and then run the app:

```console
./.build/x86_64-apple-macosx/release/persistence path-to-book.txt path-to-ignore-file.txt 100 
```

Assuming the binary is in `./.build/x86_64-apple-macosx/release` and user gives the two text files
and the count of the most frequent words to print out. Text files must be UTF-8 encoded plain text files.

After running, the app lists the top words with counts. You can also open the database created by the app using sqlite3 and view the contents of the database:

```console
> sqlite3 Bulk.txt.sqlite
sqlite> select * from words order by count desc limit 10;
he|32108
that|27021
his|20040
it|16443
for|16186
with|16070
was|14628
not|13568
han|13296
him|12886
sqlite> .quit
```

Database name is based on the book text file name, given as the first parameter to the app.


## Who did this

* (c) Antti Juustila
* INTERACT Research Group
* Study program for Information Processing Science
* University of Oulu, Finland
