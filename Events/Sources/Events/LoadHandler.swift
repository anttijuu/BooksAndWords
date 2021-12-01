//
//  File.swift
//  
//
//  Created by Antti Juustila on 23.4.2021.
//

import Foundation

class LoadHandler {

   private var dispatcher: EventDispatcher
   private var words: [String] = []

   init(dispatcher: EventDispatcher) {
      self.dispatcher = dispatcher
      self.dispatcher.registerUnaryHandler(for: Event.LoadFile, handler: handle)
   }

   func handle(file: String) -> Void {
      let data = FileManager.default.contents(atPath: file)
      if let data = data {
         var asString = String(decoding: data, as: UTF8.self)
         asString = asString.lowercased()
         words = asString.split{ $0.isWhitespace || $0.isPunctuation }.map{ String($0) }
      }
      for word in words {
         dispatcher.dispatch(Event.ProcessRawWord, param: word)
      }
      words.removeAll()
      dispatcher.dispatch(Event.Finish, param: nil)
   }
}
