//
//  File.swift
//  
//
//  Created by Antti Juustila on 8.12.2021.
//

import Foundation

actor AsyncCounter {

   var allWordCounts = [String : Int]()

   func calculateFromArray(from words: [String], filtering wordsToFilter: [String]) async {
      var partialResults = [[String: Int]]()

      await withTaskGroup(of: Void.self, body: { group in
         let spliceSize = words.count / 8
         print("spliceSize is \(spliceSize) for \(words.count) words")
         for index in stride(from: 0, to: words.count - 1, by: spliceSize) {
            group async {
               async let result = calculateFromSlice(slice: words[index..<min(index+spliceSize,words.count-1)], wordsToFilter)
               print("Partial result \(index) size is \(result.count)")
               return await result
            }
         }
      })
      for partialResult in partialResults {
         for (key, value) in partialResult {
            if allWordCounts[key] != nil {
               allWordCounts[key] = allWordCounts[key]! + value
            } else {
               allWordCounts[key] = value
            }
         }
      }
   }

   private func calculateFromSlice(slice: ArraySlice<String>, _ wordsToFilter: [String]) async -> [String: Int] {
      return slice.filter { word in
         word.count >= 2 && !wordsToFilter.contains(word)
      }.reduce(into: [:]) { counts, word in
         counts[word, default: 0] += 1
      }
   }

}
