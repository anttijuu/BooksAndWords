//
//  File.swift
//  
//
//  Created by Antti Juustila on 21.5.2021.
//

import Foundation

class TreeNode {
   let word: String
   var count: Int

   var left: TreeNode?
   var right: TreeNode?

   init(_ word: String) {
      self.word = word
      count = 1
   }

   func insert(_ word: String) -> Int {
      if word == self.word {
         count += 1
         return 0
      } else {
         if word < self.word {
            if let left = left {
               return left.insert(word)
            } else {
               left = TreeNode(word)
               return 1
            }
         } else {
            if let right = right {
               return right.insert(word)
            } else {
               right = TreeNode(word)
               return 1
            }
         }
      }
   }

   func accept(_ visitor: Visitor) throws {
      try visitor.visit(node: self)
   }

}