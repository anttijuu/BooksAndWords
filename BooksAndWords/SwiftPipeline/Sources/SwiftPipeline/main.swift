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

      _ = reader()
            .processing(with: processor()
               .filtering(with: filter()
                  .preparing(from: stopWordsFile)
                  .handling(with: handler(topListSize))))
            .reading(from: bookFile)

      let duration = start.distance(to: Date())
      print(" >>>> Time \(duration) secs.")
   }

   private func reader() -> Reader {
      return ReaderImpl()
   }

   private func processor() -> Processor {
      return ProcessorImpl()
   }

   private func filter() -> Filter {
      return FilterImpl()
   }

   private func handler(_ topSize: Int) -> Handler {
      return HandlerImpl(topCount: topSize)
   }
}

SwiftPipeline.main()

