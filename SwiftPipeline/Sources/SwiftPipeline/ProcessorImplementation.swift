//
//  File.swift
//  
//
//  Created by Antti Juustila on 16.5.2021.
//

import Foundation

class ProcessorImplementation: Processor {
   var filter: Filter?
   var word: String = ""

   func filtering(with filter: Filter) -> Processor {
      self.filter = filter
      return self
   }

   func process(_ char: Character) {
      precondition(filter != nil)
      if char.isLetter {
         word.append(char)
      } else {
         filter!.filter(word.lowercased())
         word = ""
      }
   }

   func finish() {
      precondition(filter != nil)
      filter!.finish()
   }

}
