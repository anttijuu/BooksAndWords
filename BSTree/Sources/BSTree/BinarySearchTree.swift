//
//  File.swift
//  
//
//  Created by Antti Juustila on 21.5.2021.
//

import Foundation

final class BinarySearchTree {
   var root: TreeNode?
   var wordCount = 0
   var uniqueWordCount = 0

	deinit {
		root = nil
	}
	
   func insert(_ word: String) {
      wordCount += 1
      if let root = root {
         uniqueWordCount += root.insert(word)
      } else {
         uniqueWordCount += 1
         root = TreeNode(word)
      }
   }

   func asArray(_ size: Int) -> [WordCount]? {
      guard root != nil else {
         return nil
      }
      let visitor = ToArrayVisitor(with: size)
      do {
         try root!.accept(visitor)
      } catch {
         print("Exception in exporting the tree to an array")
      }
      return visitor.array
   }

   func exportDot(with name: String, to fileName: String) {
      guard root != nil else {
         return
      }
      let dotVisitor = DotGenerator(file: URL(fileURLWithPath: fileName))
      do {
         dotVisitor.start(with: name)
         try root!.accept(dotVisitor)
         dotVisitor.finish()
      } catch {
         print("Exception in exporting the tree to dot file")
      }
   }
   
}
