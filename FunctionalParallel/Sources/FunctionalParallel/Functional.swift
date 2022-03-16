import Foundation

import ArgumentParser


class WordCounter {
   func countWords(from words: [String], wordsToFilter: [String]) async -> [String: Int] {
      // Launch the tasks in a task group.
      await withTaskGroup(of: [String: Int].self) { group in
         // Prepare the unit of asynchronous work in a Task.

         let sliceSize = words.count / 8
         // The word frequencies will be stored in this dictionary.
         var wordCounts = [String: Int]()
         // Add a task to the task group
         for index in stride(from: 0, to: words.count - 1, by: sliceSize) {
            // Add tasks to the task group, they are then executed in parallel.
            group.addTask(priority: .userInitiated) { () -> [String: Int] in
               let slice = words[index..<min(index+sliceSize - 1,words.count - 1)]
               // Each task asynchronously count the word frequencies of a slice of an array.
               //print("Starting... \(slice.startIndex)...\(slice.endIndex)")
               async let result = slice.filter { word in
                  word.count >= 2 && !wordsToFilter.contains(word)
               }.reduce(into: [:]) { counts, word in
                  counts[word, default: 0] += 1
               }
               // Return the resulting dictionary from the task to the task group.
               //print("Returning...")
               return await result
            }
         }
         // Combine the results from the subtasks as they finish.
         for await partial in group {
            //print("Combining to final...")
            for (key, value) in partial {
               if wordCounts[key] != nil {
                  wordCounts[key] = wordCounts[key]! + value
               } else {
                  wordCounts[key] = value
               }
            }
         }
         return wordCounts
      }
   }
}

@main
struct Functional: AsyncParsableCommand {
   static let configuration = CommandConfiguration(abstract: "A Swift command-line tool to count the most often used words in a book file.")
   
   @Argument(help: "The file name for the book file.")
   private var bookFile: String
   
   @Argument(help: "The file name for the stop words.")
   private var stopWordsFile: String
   
   @Argument(help: "The number of top words to list.")
   private var topListSize: Int
   

   mutating func run() async throws {
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
      let asString = String(decoding: bookData, as: UTF8.self)
      
      // Go through the string, pick words and add them to the array of words.

      var words: [String] = []
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
      
      // Read the words to ignore
      let filterData = FileManager.default.contents(atPath: stopWordsFile)
      guard let filterData = filterData else {
         print("Failed to read ignore word file contents")
         return
      }
      let filterAsString = String(decoding: filterData, as: UTF8.self)
      let wordsToFilter = filterAsString.components(separatedBy: CharacterSet(charactersIn: ",\n"))

      // Calculation of unique word frequencies is done within task group tasks. What is returned is
      // a dictionary of words and their counts from a slice of the array.
      // After getting the results from parallel tasks, the partial results are joined and the dictionary
      // is sorted in descending order and prints out the top words.
      // Count the slice size of the array for the subtasks to handle.

      let wordCounter = WordCounter()
      let wordCounts = await wordCounter.countWords(from: words, wordsToFilter: wordsToFilter)

      // Now subtasks have finished and results from those have been combined to wordCounts.
      // Sort the combined dictionary by the word count (value of the map).
      var counter = 1
      wordCounts.sorted(by: { lhs, rhs in
         lhs.value > rhs.value
      }).prefix(topListSize).forEach { key, value in
         print("\(String(counter).rightJustified(width: 3)). \(key.leftJustified(width: 20, fillChar: ".")) \(value)")
         counter += 1
      }

      let duration = start.distance(to: Date())
      print(" >>>> Time \(duration) secs.")
   }
   
}

