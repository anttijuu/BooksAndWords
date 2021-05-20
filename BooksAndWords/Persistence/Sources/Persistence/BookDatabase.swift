//
//  File.swift
//  
//
//  Created by Antti Juustila on 19.5.2021.
//

import Foundation
import SQLite

class BookDatabase {

   var connection: Connection?
   var words = Table("words")
   let word = Expression<String>("word")
   let count = Expression<Int>("count")

   init() {
   }

   public func create(for book: String) -> Bool {
      do {
         try connection = Connection(book)
         try connection!.run(words.create{ t in
            t.column(word, primaryKey: true)
            t.column(count)
         })
      } catch  {
         print("Failed to create db for \(book)")
         return false
      }
      return true
   }

   public func addWord(_ readWord: String) throws -> Bool {
      guard connection != nil else {
         return false
      }
      var found = false
      for _ in try connection!.prepare(words.select(word, count).filter(word == readWord)) {
         found = true
         let found = words.filter(word == readWord)
         try connection!.run(found.update(count++))
         break
      }
      if !found {
         try connection!.run(words.insert(word <- readWord, count <- 1))
      }
      return true
   }

   public func getTop(_ topCount: Int) throws -> [String: Int] {
      var result = [String: Int]()
      guard connection != nil else {
         return result
      }
      let query = words.select(*)
         .order(count.desc)
         .limit(topCount)
      for wordFound in try connection!.prepare(query) {
         result[wordFound[word]] = wordFound[count]
      }
      return result
   }

   public func close() {
      connection = nil
   }
}
