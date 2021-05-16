//
//  File.swift
//  
//
//  Created by Antti Juustila on 16.5.2021.
//

import Foundation

class ProcessorImpl: Processor {
   var filter: Filter?
   var word: String = ""

   func filtering(with filter: Filter) -> Processor {
      self.filter = filter
      return self
   }

   func process(char: Character) {
      precondition(filter != nil)
      if char.isPunctuation || char.isWhitespace {
         filter!.filter(word)
         word = ""
      } else {
         word.append(char)
      }
   }

   func finish() {
      precondition(filter != nil)
      filter!.finish()
   }

}
