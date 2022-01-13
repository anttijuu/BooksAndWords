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
      
      // In a console app a semaphore is needed so that the main thread stops waiting for the
      // async tasks to finish before quitting the app. Otherwise, the console app main thread
      // runs to the end and exits the app before subtasks have finished the word counting.
      let taskSemaphore = DispatchSemaphore(value: 0)
      // Calculation of unique word frequencies is done within task group tasks. What is returned is
      // a dictionary of words and their counts from a slice of the array.
      // After getting the results from parallel tasks, the partial results are joined and the dictionary
      // is sorted in descending order and prints out the top words.
      // Count the slice size of the array for the subtasks to handle.
      let sliceSize = words.count / 8
      for index in stride(from: 0, to: words.count - 1, by: sliceSize) {
         // Add tasks to the task group, they are then executed in parallel.
         let slice = words[index..<min(index+sliceSize,words.count-1)]
         // Prepare the unit of asynchronous work in a Task.
         Task(priority: .userInitiated) {
            // The word frequencies will be stored in this dictionary.
            var wordCounts = [String: Int]()

            // Launch the tasks in a task group.
            try! await withThrowingTaskGroup(of: [String: Int].self, body: { group in
               // Add a task to the task group
               group.addTask(priority: .userInitiated) { () -> [String: Int] in
                  // Each task asynchronously count the word frequencies of a slice of an array.
                  async let result = slice.filter { word in
                     word.count >= 2 && !wordsToFilter.contains(word)
                  }.reduce(into: [:]) { counts, word in
                     counts[word, default: 0] += 1
                  }
                  // Return the resulting dictionary from the task to the task group.
                  return await result
               }
               // Combine the results from the subtasks as they finish.
               for try await partial in group {
                  for (key, value) in partial {
                     if wordCounts[key] != nil {
                        wordCounts[key] = wordCounts[key]! + value
                     } else {
                        wordCounts[key] = value
                     }
                  }
               }
            })
            // Now subtasks have finished and results from those have been combined to wordCounts.
            // Sort the combined dictionary by the word count (value of the map).
            var counter = 1
            wordCounts.sorted(by: { lhs, rhs in
               lhs.value > rhs.value
            }).prefix(topListSize).forEach { key, value in
               print("\(String(counter).rightJustified(width: 3)). \(key.leftJustified(width: 20, fillChar: ".")) \(value)")
               counter += 1
            }
            // Signal that the async tasks are finished.
            taskSemaphore.signal()
         }
      }
      // Waiting for the async tasks to finish.
      taskSemaphore.wait()
      
      let duration = start.distance(to: Date())
      print(" >>>> Time \(duration) secs.")
   }
   
}
   
Functional.main()
