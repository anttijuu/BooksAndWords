import Foundation
import ArgumentParser

struct BSTree: ParsableCommand {
   static let configuration = CommandConfiguration(abstract: "A Swift command-line tool to count the most often used words in a book file.")

   @Argument(help: "The file name for the book file.")
   private var bookFile: String

   @Argument(help: "The file name for the stop words.")
   private var stopWordsFile: String

   @Argument(help: "The number of top words to list.")
   private var topListSize: Int

   @Option(help: "To generate dot file of the tree or not")
   var dot: Bool = false

   init() { }

   func run() throws {
      print("Book file: \(bookFile).")
      print("Stop words file: \(stopWordsFile).")
      print("Listing \(topListSize) most common words.")

      // Start the timing
      let start = Date()

      // Read the stopwords, a.k.a. filter words from another file.
      var data = FileManager.default.contents(atPath: stopWordsFile)
      var wordsToFilter = [String]()
      if let data = data {
         let asString = String(decoding: data, as: UTF8.self)
         wordsToFilter = asString.components(separatedBy: CharacterSet(charactersIn: ",\n"))
      }

      // Start reading book into memory from file.
      data = FileManager.default.contents(atPath: bookFile)
      // Read words to BST implemented with classes.
      // Optionally use EnumBinarySearchTree to test out how enum based implementation works.
      let tree = BinarySearchTree()
      if let data = data {
         let asString = String(decoding: data, as: UTF8.self)
         // Go through the string, pick words and filter outs the ones not to include.
         var word = String()
         for letter in asString {
            if letter.isLetter {
               word.append(letter)
            } else {
               // Normalize word to lowercase
               word = word.lowercased()
               if wordsToFilter.firstIndex(of: word) == nil && word.count >= 2 {
                  tree.insert(word)
               }
               word = ""
            }
         }
         // Now all words have been counted into the tree.
         // Use the asArray to get the most frequent words from the tree.
         // Then sort the array by the count, descending.
         let exportStart = Date()
         if let result = tree.asArray(topListSize) {
            let exportDuration = exportStart.distance(to: Date())
            print("Export took: \(exportDuration)")
            let sorted = result.sorted( by: { $0.count > $1.count })
            var counter = 1
            // Then print out the most common ones, starting from the beginning.
            for wordFrequency in sorted {
               print("\(String(counter).rightJustified(width: 3)). \(wordFrequency.word.leftJustified(width: 20, fillChar: ".")) \(wordFrequency.count)")
               counter += 1
               if counter > topListSize {
                  break
               }
            }
         }
         print("Count of words: \(tree.wordCount), count of unique words: \(tree.uniqueWordCount)")
      }
      // Print out how long this took.
      let duration = start.distance(to: Date())
      print(" >>>> Time \(duration) secs.")
      // And we are done!
      if dot {
         let fileName = "dotgraph.txt"
         print("Exporting tree structure to \(fileName), use dot -Tsvg \(fileName) -otree.svg to view it.")
         var name = URL(fileURLWithPath: bookFile).lastPathComponent
         if name.contains(".") {
            name = String(name.prefix(upTo: name.lastIndex(of: ".")!))
         }
         tree.exportDot(with: name, to: fileName)
      }
   }

}

BSTree.main()
