//
//  File.swift
//  
//
//  Created by Antti Juustila on 4.1.2022.
//

import Foundation

//
//  File.swift
//
//
//  Created by Antti Juustila on 21.5.2021.
//

import Foundation

indirect enum EnumTreeNode {
   case Empty
   case Node(left: EnumTreeNode, hash: Int, word: String, count: Int, right: EnumTreeNode)

   init() {
      self = .Empty
   }

   init(_ word: String) {
      self = .Node(left: .Empty, hash: word.hashValue, word: word, count: 1, right: .Empty)
   }

   func accept(_ visitor: Visitor) throws {
      try visitor.visit(node: self)
   }
}

extension EnumTreeNode {
   func insert(_ newWord: String) -> EnumTreeNode {
      switch self {
         case .Empty:
            return EnumTreeNode.Node(left: .Empty, hash: newWord.hashValue, word: newWord, count: 1, right: .Empty)

         case let .Node(left, hash, word, count, right):
            if newWord.hashValue == hash {
               return EnumTreeNode.Node(left: left, hash: word.hashValue, word: word, count: count + 1, right: right)
            } else if newWord.hashValue < hash {
               return EnumTreeNode.Node(left: left.insert(newWord), hash: hash, word: word, count: count, right: right)
            } else {
               return EnumTreeNode.Node(left: left, hash: hash, word: word, count: count, right: right.insert(newWord))
            }
      }
   }
}

