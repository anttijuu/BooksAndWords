import Foundation
import ArgumentParser

struct SwiftPipeline: ParsableCommand {
   static let configuration = CommandConfiguration(abstract: "A Swift command-line tool to count the most often used words in a book file.")

   @Argument(help: "The file name for the book file.")
   private var bookFile: String

   @Argument(help: "The file name for the stop words.")
   private var stopWordsFile: String

   @Argument(help: "The number of top words to list.")
   private var topListSize: Int

   init() { }

   mutating func run() throws {
      print("Book file: \(bookFile).")
      print("Stop words file: \(stopWordsFile).")
      print("Listing \(topListSize) most common words.")

      let start = Date()

      ReaderImpl()
         .processing(with: ProcessorImpl()
            .filtering(with: FilterImpl()
               .preparing(from: stopWordsFile)
               .handling(with: HandlerImpl(topCount: topListSize))))
         .reading(from: bookFile)

      let duration = start.distance(to: Date())
      print(" >>>> Time \(duration) secs.")
   }

}

SwiftPipeline.main()

