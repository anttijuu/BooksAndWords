//
//  File.swift
//  
//
//  Created by Antti Juustila on 23.4.2021.
//

import Foundation

class WordCounter {

   private var dispatcher: EventDispatcher
   private var wordCounts: [String:Int] = [:]
   private var topListSize: Int

   init(dispatcher: EventDispatcher, topSize: Int) {
      self.dispatcher = dispatcher
      topListSize = topSize
      self.dispatcher.registerUnaryHandler(for: Event.VerifiedWord, handler: handle)
      self.dispatcher.registerFinishHandler(for: printTopList)
   }

   func handle(word: String) -> Void {
      if wordCounts[word] != nil {
         wordCounts[word]! += 1
      } else {
         wordCounts[word] = 1
      }
   }

   func printTopList() -> Void {
      let sorted = wordCounts.sorted( by: { $0.1 > $1.1 })
      var counter = 1
      for (key, value) in sorted {
         print("\(String(counter).rightJustified(width: 3)). \(key.leftJustified(width: 20, fillChar: ".")) \(value)")
         counter += 1
         if counter > topListSize {
            break
         }
      }
   }

}
