import Foundation
import ArgumentParser

// Type aliases to make the func declarations easier to read:
typealias NoOpFunc = () -> Void
typealias ArrayFunc = ([String]) -> Void
typealias MapNoOpFunc = ([String: Int], NoOpFunc) -> Void
typealias ArrayMapNoOpFunc = ([String], MapNoOpFunc) -> Void
typealias ArrayArrayMapNoOpFunc = ([String], ArrayMapNoOpFunc) -> Void

struct KickForward: ParsableCommand {
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

      let start = Date()

      // readFile calls filterWords...
      readFile(file: bookFile, function: filterWords)

      let duration = start.distance(to: Date())
      print(" >>>> Time \(duration) secs.")
   }

   func readFile(file: String, function: ArrayArrayMapNoOpFunc) -> Void {
      let data = FileManager.default.contents(atPath: file)
      var words = [String]()
      if let data = data {
         let asString = String(decoding: data, as: UTF8.self)
         
         // Go through the string, pick words and add them to the array of words.
         var word = String()
         for letter in asString {
            if letter.isLetter {
               word.append(letter)
            } else {
               // Normalize word to lowercase
               words.append(word.lowercased())
               word = ""
            }
         }
      }
      // ...filterWords calls calculateFrequencies...
      function(words, calculateFrequencies)
   }

   func filterWords(words: [String], function: ArrayMapNoOpFunc) -> Void {
      let data = FileManager.default.contents(atPath: stopWordsFile)
      var wordsToFilter = [String]()
      var cleanedWords = [String]()
      if let data = data {
         let asString = String(decoding: data, as: UTF8.self)
         wordsToFilter = asString.components(separatedBy: CharacterSet(charactersIn: ",\n"))
      }
      for word in words {
         if wordsToFilter.firstIndex(of: word) == nil && !word.isNumeric && word.count >= 2 {
            cleanedWords.append(word)
         }
      }
      // ...calculateFrequencies calls printTop...
      print("File has \(cleanedWords.count) words.")
      function(cleanedWords, printTop)
   }

   func calculateFrequencies(words: [String], function: MapNoOpFunc) -> Void {
      var wordCounts = [String: Int]()
      for word in words {
         if wordCounts[word] != nil {
            wordCounts[word]! += 1
         } else {
            wordCounts[word] = 1
         }
      }
      // ..printTop calls noOp...
      print("File has \(wordCounts.count) unique words.")
      function(wordCounts, noOp)
   }

   func printTop(wordCounts: [String: Int], function: NoOpFunc) {
      let sorted = wordCounts.sorted( by: { $0.1 > $1.1 })
      var counter = 1
      for (key, value) in sorted {
         print("\(String(counter).rightJustified(width: 3)). \(key.leftJustified(width: 20, fillChar: ".")) \(value)")
         counter += 1
         if counter > topListSize {
            break
         }
      }
      // ...as printTop calls noOp...
      function()
   }

   func noOp() -> Void {
      // ... it does nothing.
   }

}

KickForward.main()
