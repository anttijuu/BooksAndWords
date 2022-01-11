//
//  File.swift
//  
//
//  Created by Antti Juustila on 23.4.2021.
//

import Foundation

class LoadHandler {

   private var dispatcher: EventDispatcher

   init(dispatcher: EventDispatcher) {
      self.dispatcher = dispatcher
      self.dispatcher.registerUnaryHandler(for: Event.LoadFile, handler: handle)
   }

   func handle(file: String) -> Void {
      let data = FileManager.default.contents(atPath: file)
      if let data = data {
         var asString = String(decoding: data, as: UTF8.self)
         asString = asString.lowercased()
         // Go through the string, pick word and dispatch it to next handler.
         var word = String()
         for letter in asString {
            if letter.isLetter {
               word.append(letter)
            } else {
               // Normalize word to lowercase
               word = word.lowercased()
               dispatcher.dispatch(Event.ProcessRawWord, param: word)
               word = ""
            }
         }
      }
      dispatcher.dispatch(Event.Finish, param: nil)
   }
}
