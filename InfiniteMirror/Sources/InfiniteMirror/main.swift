import Foundation
import ArgumentParser

struct InfiniteMirror: ParsableCommand {
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

      var words = [String]()
      var wordsToFilter = [String]()
      var counts: [String:Int] = [:]

      var data = FileManager.default.contents(atPath: stopWordsFile)
      if let data = data {
         let asString = String(decoding: data, as: UTF8.self)
         wordsToFilter = asString.components(separatedBy: CharacterSet(charactersIn: ",\n"))
      }
      data = FileManager.default.contents(atPath: bookFile)
      if let data = data {
         var asString = String(decoding: data, as: UTF8.self)
         asString = asString.lowercased()
         words = asString.split{ $0.isWhitespace || $0.isPunctuation }.map{ String($0) }
      }
      let recursionLimit = 30_000
      
      // 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
      for index in stride(from: 0, to: words.count - 1, by: recursionLimit) {
         count(from: words[index..<min(index+recursionLimit,words.count-1)], ignoring: wordsToFilter, to: &counts)
      }
      
      let sorted = counts.sorted( by: { $0.1 > $1.1 })
      var counter = 1
      for (key, value) in sorted {
         print("\(String(counter).rightJustified(width: 3)). \(key.leftJustified(width: 20, fillChar: ".")) \(value)")
         counter += 1
         if counter > topListSize {
            break
         }
      }
      let duration = start.distance(to: Date())
      print(" >>>> Time \(duration) secs.")
   }

   // 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
   func count(from words: ArraySlice<String>, ignoring stopWords: [String], to wordCounts: inout [String:Int]) {
      if words.count == 0 {
         return
      } else {
         let word = words[words.startIndex]
         if stopWords.firstIndex(of: word) == nil && !word.isNumeric && word.count >= 2 {
            if wordCounts[word] != nil {
               wordCounts[word]! += 1
            } else {
               wordCounts[word] = 1
            }
         }
         count(from: words[words.startIndex + 1..<words.endIndex], ignoring: stopWords, to: &wordCounts)
      }
   }
}

InfiniteMirror.main()
