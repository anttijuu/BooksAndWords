//
//  File.swift
//  
//
//  Created by Antti Juustila on 16.5.2021.
//

import Foundation

class CountingHandler: Handler {
   private var wordCounts: [String:Int] = [:]
   private var topCount: Int = 100

   init(topCount: Int) {
      self.topCount = topCount
   }
   
   func handle(_ word: String) {
      if wordCounts[word] != nil {
         wordCounts[word]! += 1
      } else {
         wordCounts[word] = 1
      }
   }

   func finish() {
      let sorted = wordCounts.sorted( by: { $0.1 > $1.1 })
      var counter = 1
      for (key, value) in sorted {
         Swift.print("\(String(counter).rightJustified(width: 3)). \(key.leftJustified(width: 20, fillChar: ".")) \(value)")
         counter += 1
         if counter > topCount {
            break
         }
      }
   }


}
