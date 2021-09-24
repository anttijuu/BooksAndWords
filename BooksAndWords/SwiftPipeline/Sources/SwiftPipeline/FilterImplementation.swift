//
//  File.swift
//  
//
//  Created by Antti Juustila on 16.5.2021.
//

import Foundation

class FilterImplementation: Filter {

   private var wordsToFilter: [String] = []
   private var handler: Handler?

   func preparing(from file: String) -> Filter {
      let data = FileManager.default.contents(atPath: file)
      if let data = data {
         let asString = String(decoding: data, as: UTF8.self)
         wordsToFilter = asString.components(separatedBy: CharacterSet(charactersIn: ",\n"))
      }
      return self
   }

   func handling(with handler: Handler) -> Filter {
      self.handler = handler
      return self
   }

   func filter(_ word: String) {
      precondition(handler != nil)
      if wordsToFilter.firstIndex(of: word) == nil && !word.isNumeric && word.count >= 2 {
         handler!.handle(word)
      }
   }

   func finish() {
      precondition(handler != nil)
      handler!.finish()
   }

}
