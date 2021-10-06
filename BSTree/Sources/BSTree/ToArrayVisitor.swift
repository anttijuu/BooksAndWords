//
//  ToArrayVisitor.swift
//  
//
//  Created by Antti Juustila on 21.5.2021.
//

import Foundation

class ToArrayVisitor: Visitor {

   var array: [WordCount]

   init() {
      array = [WordCount]()
   }

   func visit(node: TreeNode) throws {
      if let left = node.left {
         try left.accept(self)
      }
      array.append(WordCount(word: node.word, count: node.count))
      if let right = node.right {
         try right.accept(self)
      }
   }

}
