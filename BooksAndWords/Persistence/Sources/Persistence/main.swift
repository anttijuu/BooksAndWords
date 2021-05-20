import Foundation
import ArgumentParser

struct Persistence: ParsableCommand {
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
      let dbName = "./" + bookFile.suffix(from: bookFile.lastIndex(of: "/")!) + ".sqlite"
      let dataBase = BookDatabase()
      if dataBase.create(for: dbName) {
         insertWords(to: dataBase)
         queryTop(from: dataBase)
      } else {
         queryTop(from: dataBase)
      }
      dataBase.close()
      let duration = start.distance(to: Date())
      print(" >>>> Time \(duration) secs.")
   }

   private func insertWords(to db: BookDatabase) {
      let data = FileManager.default.contents(atPath: bookFile)
      var words = [String]()
      if let data = data {
         var asString = String(decoding: data, as: UTF8.self)
         asString = asString.lowercased()
         words = asString.split{ $0.isWhitespace || $0.isPunctuation }.map{ String($0) }
      }
      let filter = readFilterWords()
      do {
         try db.connection!.transaction {
            for word in words {
               if filter.firstIndex(of: word) == nil && !word.isNumeric && word.count >= 2 {
                  if try !db.addWord(word) {
                     print("Error in adding word to db, aborting.")
                     break;
                  }
               }
            }
         }
      } catch {
         print("Database operation failed \(error)")
      }
   }

   private func queryTop(from db: BookDatabase) {
      do {
         let sorted = try db.getTop(topListSize).sorted( by: { $0.1 > $1.1 })
         var counter = 1
         for (key, value) in sorted {
            print("\(String(counter).rightJustified(width: 3)). \(key.leftJustified(width: 20, fillChar: ".")) \(value)")
            counter += 1
            if counter > topListSize {
               break
            }
         }
      } catch  {
         print("Database operation failed \(error)")
      }
   }

   private func readFilterWords() -> [String] {
      var wordsToFilter: [String] = []
      let data = FileManager.default.contents(atPath: stopWordsFile)
      if let data = data {
         let asString = String(decoding: data, as: UTF8.self)
         wordsToFilter = asString.components(separatedBy: ",")
      }
      return wordsToFilter
   }

}

Persistence.main()

