//
//  File.swift
//  
//
//  Created by Antti Juustila on 16.5.2021.
//

import Foundation

class ReaderImpl: Reader {

   var processor: Processor?

   func read(from file: String) -> Reader {
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
      return self
   }

   func process(with processor: Processor) -> Reader {
      self.processor = processor
      return self
   }

}
