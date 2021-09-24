//
//  File.swift
//  
//
//  Created by Antti Juustila on 23.4.2021.
//

import Foundation

class WordFilter {

   private var dispatcher: EventDispatcher
   private var wordsToFilter: [String] = []

   init(dispatcher: EventDispatcher) {
      self.dispatcher = dispatcher
      self.dispatcher.registerUnaryHandler(for: Event.LoadStopWords, handler: handle)
      self.dispatcher.registerUnaryHandler(for: Event.RawWord, handler: handleRawWord)
   }

   func handle(file: String) -> Void {
      let data = FileManager.default.contents(atPath: file)
      if let data = data {
         let asString = String(decoding: data, as: UTF8.self)
         wordsToFilter = asString.components(separatedBy: CharacterSet(charactersIn: ",\n"))
      }
   }

   func handleRawWord(word: String) -> Void {
      if wordsToFilter.firstIndex(of: word) == nil && !word.isNumeric && word.count >= 2 {
         dispatcher.dispatch(Event.VerifiedWord, param: word)
      }
   }
   
}
