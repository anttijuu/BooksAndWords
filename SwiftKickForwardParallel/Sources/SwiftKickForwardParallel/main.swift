import Foundation
import ArgumentParser

// Type aliases to make the func declarations easier to read:
typealias NoOpFunc = @Sendable () -> Void
typealias ArrayFunc = @Sendable (ArraySlice<String>) -> [String: Int]
typealias ArrayNoOpFunc = @Sendable (ArraySlice<String>, NoOpFunc) -> [String: Int]
typealias ArrayArrayNoOpFunc = @Sendable (ArraySlice<String>, ArrayNoOpFunc) -> [String: Int]
typealias MapNoOpFunc = @Sendable ([String: Int], NoOpFunc) -> [String: Int]
typealias ArrayMapNoOpFunc = @Sendable ([String], MapNoOpFunc) -> [String: Int]
typealias ArrayArrayMapNoOpFunc = @Sendable ([String], ArrayMapNoOpFunc) -> [String: Int]

actor WordCounts {
	var map: [String: Int] = [:]

	func append(_ item: (key: String, value: Int)) async {
		if map[item.key] != nil {
			map[item.key] = map[item.key]! + item.value
		} else {
			map[item.key] = item.value
		}
	}

	func get() async -> [String: Int] {
		return map
	}
}

final class KickForwardParallel: ParsableCommand {

   static let configuration = CommandConfiguration(abstract: "A Swift command-line tool to count the most often used words in a book file.")

   @Argument(help: "The file name for the book file.")
   private var bookFile: String

   @Argument(help: "The file name for the stop words.")
   private var stopWordsFile: String

   @Argument(help: "The number of top words to list.")
   private var topListSize: Int

   var wordsToFilter = [String]()

	func run() async throws {
      print("Book file: \(bookFile).")
      print("Stop words file: \(stopWordsFile).")
      print("Listing \(topListSize) most common words.")

      let start = Date()

      // readFile calls filterWords...
      await readFile(file: bookFile, function: filterWords)

      let duration = start.distance(to: Date())
      print(" >>>> Time \(duration) secs.")
   }

	@Sendable
	func readFile(file: String, function: @escaping ArrayArrayNoOpFunc) async -> Void {
      var data = FileManager.default.contents(atPath: file)
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
      data = FileManager.default.contents(atPath: stopWordsFile)
      if let data = data {
         let asString = String(decoding: data, as: UTF8.self)
         wordsToFilter = asString.components(separatedBy: CharacterSet(charactersIn: ",\n"))
      }

      let sliceSize = words.count / 8
      // print("spliceSize is \(sliceSize) for \(words.count) words")
      //var map: [String: Int] = [:]
		let map = WordCounts()
      // print("Starting dispatch queues")

      let queue = DispatchQueue(label: "com.anttijuustila.kickforward", qos: .userInteractive, attributes: .concurrent)
      let group = DispatchGroup()
      let mapSemaphore = DispatchSemaphore(value: 1)
      // ...filterWords calls calculateFrequencies...
      for index in stride(from: 0, to: words.count - 1, by: sliceSize) {
         group.enter()
         queue.async { [self, words] in
				let pieces = function(words[index..<min(index+sliceSize,words.count-1)], self.calculateFrequencies)
            // print("Waiting for map...")
            mapSemaphore.wait()
            for (key, value) in pieces {
					await map.append((key, value))
            }
            // print("...signalling map")
            mapSemaphore.signal()
            group.leave()
         }
      }
      // print("Waiting for threads...")
      group.wait()
      // print("Map has before printing \(map.count) elements")
		printTop(wordCounts: await map.get())
   }

	@Sendable
   func filterWords(words: ArraySlice<String>, function: ArrayNoOpFunc) -> [String: Int] {
      var cleanedWords = [String]()
      for word in words {
         if wordsToFilter.firstIndex(of: word) == nil && !word.isNumeric && word.count >= 2 {
            cleanedWords.append(word)
         }
      }
      return function(cleanedWords[1...], noOp)
   }

	@Sendable
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

	@Sendable
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

	@Sendable
   func noOp() -> Void {
      // ... it does nothing.
   }

}

KickForwardParallel.main()
