//
//  File.swift
//  
//
//  Created by Antti Juustila on 4.1.2022.
//

import Foundation

final class EnumBinarySearchTree {
   var root: EnumTreeNode = .Empty
   var wordCount = 0
   var uniqueWordCount = 0

   func insert(_ word: String) {
      wordCount += 1
      root = root.insert(word)
   }

   func asArray(_ size: Int) -> [WordCount]? {
      switch root {
         case .Empty:
            return nil
         default:
            let visitor = ToArrayVisitor(with: size)
            do {
               try root.accept(visitor)
               uniqueWordCount = visitor.uniqueWordCount
            } catch {
               print("Exception in exporting the tree to an array")
            }
            return visitor.array
      }
   }

   func exportDot(with name: String, to fileName: String) {
      switch root {
         case .Empty:
            return
         default:
            let dotVisitor = DotGenerator(file: URL(fileURLWithPath: fileName))
            do {
               dotVisitor.start(with: name)
               try root.accept(dotVisitor)
               dotVisitor.finish()
            } catch {
               print("Exception in exporting the tree to dot file")
            }
      }
   }

}
