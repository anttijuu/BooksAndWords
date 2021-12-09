//
//  File.swift
//  
//
//  Created by Antti Juustila on 8.12.2021.
//

import Foundation

// A class to handle the async counting of words from the array in slices.
class AsyncCounter {

   func calculateFromArray(from words: [String], filtering wordsToFilter: [String]) async throws -> [String: Int] {
      // Here the final results from subtasks is combined.
      var results = [String: Int]()
      
      try await withThrowingTaskGroup(of: [String: Int].self, body: { group in
         // Count the slice size of the array for the subtasks to handle.
         let spliceSize = words.count / 8
         for index in stride(from: 0, to: words.count - 1, by: spliceSize) {
            group.addTask(priority: .userInitiated) { () -> [String: Int] in
               async let result = self.calculateFromSlice(slice: words[index..<min(index+spliceSize,words.count-1)], wordsToFilter)
               return await result
            }
         }
         // Combine the results from the subtasks as they finish.
         for try await partial in group {
            for (key, value) in partial {
               if results[key] != nil {
                  results[key] = results[key]! + value
               } else {
                  results[key] = value
               }
            }
         }
      })
      return results
   }

   // The subtask for calculating word frequencies from a slice fo the array of words.
   private func calculateFromSlice(slice: ArraySlice<String>, _ wordsToFilter: [String]) async -> [String: Int] {
      return slice.filter { word in
         word.count >= 2 && !wordsToFilter.contains(word)
      }.reduce(into: [:]) { counts, word in
         counts[word, default: 0] += 1
      }
   }

}
