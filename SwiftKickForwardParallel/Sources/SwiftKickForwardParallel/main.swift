import Foundation
import ArgumentParser

// Type aliases to make the func declarations easier to read:
typealias NoOpFunc = () -> Void
typealias ArrayFunc = (ArraySlice<String>) -> [String: Int]
typealias ArrayNoOpFunc = (ArraySlice<String>, NoOpFunc) -> [String: Int]
typealias ArrayArrayNoOpFunc = (ArraySlice<String>, ArrayNoOpFunc) -> [String: Int]
typealias MapNoOpFunc = ([String: Int], NoOpFunc) -> [String: Int]
typealias ArrayMapNoOpFunc = ([String], MapNoOpFunc) -> [String: Int]
typealias ArrayArrayMapNoOpFunc = ([String], ArrayMapNoOpFunc) -> [String: Int]

final class KickForwardParallel: ParsableCommand {

   static let configuration = CommandConfiguration(abstract: "A Swift command-line tool to count the most often used words in a book file.")

   @Argument(help: "The file name for the book file.")
   private var bookFile: String

   @Argument(help: "The file name for the stop words.")
   private var stopWordsFile: String

   @Argument(help: "The number of top words to list.")
   private var topListSize: Int

   var wordsToFilter = [String]()

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

   func readFile(file: String, function: @escaping ArrayArrayNoOpFunc) -> Void {
      var data = FileManager.default.contents(atPath: file)
      var words = [String]()
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

      let spliceSize = words.count / 8
      print("spliceSize is \(spliceSize) for \(words.count) words")
      var map: [String: Int] = [:]
      print("Starting dispatch queues")
      let queue = DispatchQueue(label: "com.anttijuustila.kickforward", qos: .userInteractive, attributes: .concurrent)
      let group = DispatchGroup()
      let mapSemaphore = DispatchSemaphore(value: 1)
      // ...filterWords calls calculateFrequencies...
      for index in stride(from: 0, to: words.count - 1, by: spliceSize) {
         group.enter()
         queue.async {
            let pieces = function(words[index..<min(index+spliceSize,words.count-1)], self.calculateFrequencies)
            print("Waiting for map...")
            mapSemaphore.wait()
            for (key, value) in pieces {
               if map[key] != nil {
                  map[key] = map[key]! + value
               } else {
                  map[key] = value
               }
            }
            print("...signalling map")
            mapSemaphore.signal()
            group.leave()
         }
      }
      print("Waiting for threads...")
      group.wait()
      print("Map has before printing \(map.count) elements")
      printTop(wordCounts: map)
   }

   func filterWords(words: ArraySlice<String>, function: ArrayNoOpFunc) -> [String: Int] {
      var cleanedWords = [String]()
      for word in words {
         if wordsToFilter.firstIndex(of: word) == nil && !word.isNumeric && word.count >= 2 {
            cleanedWords.append(word)
         }
      }
      return function(cleanedWords[1...], noOp)
   }

   func calculateFrequencies(words: ArraySlice<String>, function: NoOpFunc) ->  [String: Int] {
      var wordCounts = [String: Int]()
      for word in words {
         if wordCounts[word] != nil {
            wordCounts[word]! += 1
         } else {
            wordCounts[word] = 1
         }
      }
      function()
      return wordCounts
   }

   func printTop(wordCounts: [String: Int]) -> Void {
      let sorted = wordCounts.sorted( by: { $0.1 > $1.1 })
      var counter = 1
      for (key, value) in sorted {
         print("\(String(counter).rightJustified(width: 3)). \(key.leftJustified(width: 20, fillChar: ".")) \(value)")
         counter += 1
         if counter > topListSize {
            break
         }
      }
   }

   func noOp() -> Void {
      // ... it does nothing.
   }

}

KickForwardParallel.main()
