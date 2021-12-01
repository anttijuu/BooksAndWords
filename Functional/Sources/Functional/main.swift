import Foundation
import ArgumentParser

struct Functional: ParsableCommand {
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

      var data = FileManager.default.contents(atPath: bookFile)
      var words = [String]()
      var wordsToFilter = [String]()
      if let data = data {
         var asString = String(decoding: data, as: UTF8.self)
         asString = asString.lowercased()
         words = asString.split{ $0.isWhitespace || $0.isPunctuation }.map{ String($0) }
      }
      data = FileManager.default.contents(atPath: stopWordsFile)
      if let data = data {
         let asString = String(decoding: data, as: UTF8.self)
         wordsToFilter = asString.components(separatedBy: CharacterSet(charactersIn: ",\n"))
      }
      
      var counter = 1
      words.filter { word in
         word.count >= 2 && !wordsToFilter.contains(word)
      }.reduce(into: [:]) { counts, word in
         counts[word, default: 0] += 1
      }.sorted(by: { lhs, rhs in
         lhs.value > rhs.value
      }).prefix(topListSize).forEach { key, value in
         print("\(String(counter).rightJustified(width: 3)). \(key.leftJustified(width: 20, fillChar: ".")) \(value)")
         counter += 1
      }

      let duration = start.distance(to: Date())
      print(" >>>> Time \(duration) secs.")
   }

}

Functional.main()
