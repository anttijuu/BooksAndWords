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

      let bookData = FileManager.default.contents(atPath: bookFile)
      // var wordsToFilter = [String]()
      
      guard let bookData = bookData else {
         print("Failed to read book file contents")
         return
      }
      var asString = String(decoding: bookData, as: UTF8.self)
      asString = asString.lowercased()
      let words = asString.split{ $0.isWhitespace || $0.isPunctuation }.map{ String($0) }

      let filterData = FileManager.default.contents(atPath: stopWordsFile)
      guard let filterData = filterData else {
         print("Failed to read ignore word file contents")
         return
      }
      let filterAsString = String(decoding: filterData, as: UTF8.self)
      let wordsToFilter = filterAsString.components(separatedBy: CharacterSet(charactersIn: ",\n"))

      let asyncCounter = AsyncCounter()

      let spliceSize = words.count / 8
      print("spliceSize is \(spliceSize) for \(words.count) words")
      Task {
         await asyncCounter.calculateFromArray(from: words, filtering: wordsToFilter)
         var counter = 1
         await asyncCounter.allWordCounts.sorted(by: { lhs, rhs in
            lhs.value > rhs.value
         }).prefix(topListSize).forEach { key, value in
            print("\(String(counter).rightJustified(width: 3)). \(key.leftJustified(width: 20, fillChar: ".")) \(value)")
            counter += 1
         }
      }

      let duration = start.distance(to: Date())
      print(" >>>> Time \(duration) secs.")
   }
   
   func calculateFromSlice(slice: ArraySlice<String>, _ wordsToFilter: [String]) async -> [String : Int] {
      return slice.filter { word in
            word.count >= 2 && !wordsToFilter.contains(word)
         }.reduce(into: [:]) { counts, word in
            counts[word, default: 0] += 1
         }
   }
   

}

Functional.main()
