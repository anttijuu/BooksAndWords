//
//  File.swift
//  
//
//  Created by Antti Juustila on 16.5.2021.
//

import Foundation

class ReaderImpl: Reader {

   var processor: Processor?

   func reading(from file: String) {
      precondition(processor != nil)
      let data = FileManager.default.contents(atPath: file)
      if let data = data {
         var asString = String(decoding: data, as: UTF8.self)
         asString = asString.lowercased()
         for char in asString {
            processor!.process(char: char)
         }
         processor!.finish()
      }
   }

   func processing(with processor: Processor) -> Reader {
      self.processor = processor
      return self
   }

}
