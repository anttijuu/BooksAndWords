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

      // AsyncCounter uses the Swift async await with task groups to handle word counting
      // in separate parallel subtasks. The word array is sliced into several pieces which are
      // handled by subtasks, and the partial results are then combined to a dictionary and returned here.
      let asyncCounter = AsyncCounter()

      // In a console app a semaphore is needed so that the main thread stops waiting for the
      // async tasks to finish before quitting the app. Otherwise, the console app main thread
      // runs to the end and exits the app before subtasks have finished the word counting.
      let taskSemaphore = DispatchSemaphore(value: 0)
      Task(priority: .userInitiated) {
         // Calculation of unique word frequencies is done in async counter. What is returned is
         // a dictionary of words and their counts.
         // After getting the results, the main thread here sorts the list by the word frequency
         // in descending order and prints out the top words.
         if let wordCounts = try? await asyncCounter.calculateFromArray(from: words, filtering: wordsToFilter) {
            var counter = 1
            wordCounts.sorted(by: { lhs, rhs in
               lhs.value > rhs.value
            }).prefix(topListSize).forEach { key, value in
               print("\(String(counter).rightJustified(width: 3)). \(key.leftJustified(width: 20, fillChar: ".")) \(value)")
               counter += 1
            }
         } else {
            print("Failed to async calculate words to dictionary.")
         }
         // Waiting for the async tasks to finish.
         taskSemaphore.signal()
      }
      taskSemaphore.wait()

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
