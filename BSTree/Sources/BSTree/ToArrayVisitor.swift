//
//  ToArrayVisitor.swift
//  
//
//  Created by Antti Juustila on 21.5.2021.
//

import Foundation

/**
 This visitor Traverses the BST tree in order and exports the words with highest counts to a fixed size array.
 
 If the array size is, for example, 100, the words with 100 highest counts will be added to the array.

 This is a bit more complicated than just to "export" all tree nodes to the array, but on the other hand, it is
   more memory friendly.
 
 Exporting all nodes from the tree to an array has memory complexity of `O(2n)`, this approach
   has memory complexity of `O(n + 100)`.
 
 Time complexity to export all nodes is `O(n)`, and the time complexity to export to
 a fixed size array is `O(a * n)` where a is the size of the array. The a is usually quite low (e.g. 100),
 but still this has an effect on the time performance. When saving memory and using this implementation,
 exporting the tree to an array took in three test runs 0.016 seconds in average. When exporting the
 whole array, this took 0.0046 seconds in average. Total execution time being around 2.75 seconds.
 
 Test runs were executed with release builds on Mac Mini M1 with 16GB RAM using the 17MB Bulk.txt.
 
 One has to decide whether it is more important to try to save memory with large datasets with a cost of
 slightly increased execution time, or allow higher (double) load on the memory to gain faster execution time.
*/
class ToArrayVisitor: Visitor {
   
   var array: [WordCount]
   let size: Int
   var lastIndex: Int = 0
   
   init(with size: Int) {
      self.size = size
      array = [WordCount]()
      array.reserveCapacity(size)
   }
   
   func visit(node: TreeNode) throws {
      if let left = node.left {
         try left.accept(self)
      }
      // Only add a word to table if a) table has less than size elements or
      // b) if the table is full, find a word in the array that has the smallest word count (smaller than this node)
      // and replace that word with the word in this node.
      if lastIndex < size {
         // There is room in the array, so just add the word in the table.
         array.append(WordCount(word: node.word, count: node.count))
         lastIndex += 1
      } else {
         // Table is full, find a word that has smaller count than this node and is the smallest of those.
         var smallestCount = Int.max
         var smallestIndex = -1;
         for index in 0..<lastIndex {
            if array[index].count < node.count && array[index].count < smallestCount {
               smallestCount = array[index].count;
               smallestIndex = index;
            }
         }
         // If such word was found, replace that with the word in this node.
         if smallestIndex >= 0 {
            array[smallestIndex] = WordCount(word: node.word, count: node.count)
         }
      }
      if let right = node.right {
         try right.accept(self)
      }
   }
   
}
