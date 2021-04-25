import Foundation
import ArgumentParser

struct Events: ParsableCommand {
   static let configuration = CommandConfiguration(abstract: "A Swift command-line tool to count the most often used words in a book file.")

   @Argument(help: "The file name for the book file.")
   private var bookFile: String

   @Argument(help: "The file name for the stop words.")
   private var stopWordsFile: String

   @Argument(help: "The number of top words to list.")
   private var topListSize: Int

   private var start: Date?

   init() { }

   mutating func run() throws {
      print("Book file: \(bookFile).")
      print("Stop words file: \(stopWordsFile).")
      print("Listing \(topListSize) most common words.")

      start = Date()

      let dispatcher = EventDispatcher()
      _ = LoadHandler(dispatcher: dispatcher)
      _ = WordFilter(dispatcher: dispatcher)
      _ = WordCounter(dispatcher: dispatcher, topSize: topListSize)
      dispatcher.registerFinishHandler(for: finish)
      dispatcher.dispatch(Event.LoadStopWords, param: stopWordsFile)
      dispatcher.dispatch(Event.LoadFile, param: bookFile)
   }

   func finish() -> Void {
      let duration = start!.distance(to: Date())
      print(" >>>> Time \(duration) secs.")
   }
}

Events.main()
