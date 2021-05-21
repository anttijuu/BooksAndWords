import Foundation
import ArgumentParser

struct BadBook: ParsableCommand {
   static let configuration = CommandConfiguration(abstract: "A Swift command-line tool to count the most often used words in a book file.")

   @Argument(help: "The file name for the book file.")
   private var bookFile: String

   @Argument(help: "The file name for the stop words.")
   private var stopWordsFile: String

   @Argument(help: "The number of top words to list.")
   private var topListSize: Int

   init() { }

   func run() throws {
      print("Book file: \(bookFile).")
      print("Stop words file: \(stopWordsFile).")
      print("Listing \(topListSize) most common words.")

      // Start the timing
      let start = Date()

      // Start reading book into memory from file.
      var data = FileManager.default.contents(atPath: bookFile)
      // Read words into an array of Strings
      var words = [String]()
      if let data = data {
         var asString = String(decoding: data, as: UTF8.self)
         // Normalize all chars to lowercase
         asString = asString.lowercased()
         // Split the long string (the book contents) based on whitespace and
         // punctuation into the array of Strings.
         words = asString.split{ $0.isWhitespace || $0.isPunctuation }.map{ String($0) }
      }
      // Read the stopwords, a.k.a. filter words from another file.
      data = FileManager.default.contents(atPath: stopWordsFile)
      var wordsToFilter = [String]()
      if let data = data {
         let asString = String(decoding: data, as: UTF8.self)
         wordsToFilter = asString.components(separatedBy: ",")
      }
      // Prepare an array of words that does not contain the words to filter.
      var cleanedWords = [String]()
      // Go through all the words and filter outs the ones not to include.
      for word in words {
         if wordsToFilter.firstIndex(of: word) == nil && !word.isNumeric && word.count >= 2 {
            cleanedWords.append(word)
         }
      }
      // Prepare the array containing unique words and their frequencies.
      var wordFrequencies = [WordFrequency]()
      // For all filtered words...
      for word in cleanedWords {
         // ...see if is already in the array...
         if let foundIndex = wordFrequencies.firstIndex(where: { $0.word == word } ) {
            // ..if yes, increase the count by one...
            wordFrequencies[foundIndex].count += 1
         } else {
            // ...and if not, add it to the array with count of one.
            wordFrequencies.append(WordFrequency(word: word, count: 1))
         }
      }
      // Now all words have been counted.
      // Sort the array by the count, descending.
      let sorted = wordFrequencies.sorted( by: { $0.count > $1.count })
      var counter = 1
      // Then print out the most common ones, starting from the beginning.
      for wordFrequency in sorted {
         print("\(String(counter).rightJustified(width: 3)). \(wordFrequency.word.leftJustified(width: 20, fillChar: ".")) \(wordFrequency.count)")
         counter += 1
         if counter > topListSize {
            break
         }
      }
      // Print out how long this took.
      let duration = start.distance(to: Date())
      print(" >>>> Time \(duration) secs.")
      // And we are done!
   }

}

BadBook.main()
