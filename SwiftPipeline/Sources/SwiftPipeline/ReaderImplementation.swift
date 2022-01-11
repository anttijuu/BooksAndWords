//
//  File.swift
//  
//
//  Created by Antti Juustila on 16.5.2021.
//

import Foundation

class ReaderImplementation: Reader {

   var processor: Processor?

   func reading(from file: String) {
      precondition(processor != nil)
      let data = FileManager.default.contents(atPath: file)
      if let data = data {
         let asString = String(decoding: data, as: UTF8.self)
         for char in asString {
            processor!.process(char)
         }
         processor!.finish()
      }
   }

   func processing(with processor: Processor) -> Reader {
      self.processor = processor
      return self
   }

}
