//
//  File.swift
//  
//
//  Created by Antti Juustila on 21.5.2021.
//

import Foundation

final class DotGenerator: Visitor {

   let file: URL
   var level: Int = 0
   var fileHandle: FileHandle! = nil

   init(file: URL) {
      self.file = file
   }

   func start(with name: String) {
      do {
         try "".data(using: .utf8)?.write(to: file)
         if let handle = try? FileHandle(forWritingTo: file) {
            fileHandle = handle
            fileHandle.write("digraph \(name) {".data(using: .utf8)!)
            fileHandle.write(" node [shape=record, style=\"rounded,filled\"] ".data(using: .utf8)!)
         } else {
         }
      } catch {
         fatalError("Error in creating .dot file, aborting \(error)")
      }
   }

   func finish() {
      precondition(fileHandle != nil, "fileHandle is nil, call start() first with valid file name")
      do {
         fileHandle.write("}".data(using: .utf8)!)
         try fileHandle.close()
      } catch {
         fatalError("Error in writing .dot file, aborting \(error)")
      }
   }

   func visit(node: TreeNode) throws {
      precondition(fileHandle != nil, "fileHandle is nil, call start() first with valid file name")
      let str = "".rightJustified(width: level) + label(for: node)
      fileHandle.write(str.data(using: .utf8)!)
      if let left = node.left {
         level += 1
         try left.accept(self)
         level -= 1
         let str = ("".rightJustified(width: level) + label(between: node, and: left, onEdge: " L"))
         fileHandle.write(str.data(using: .utf8)!)
      }
      if let right = node.right {
         level += 1
         try right.accept(self)
         level -= 1
         let str = ("".rightJustified(width: level) + label(between: node, and: right, onEdge: " R"))
         fileHandle.write(str.data(using: .utf8)!)
      }
   }

   private func name(for node: TreeNode) -> String {
      return "node_" + convertSpecialCharacters(node.word)
   }

   private func label(for node: TreeNode) -> String {
      return name(for: node) + " [ label=\"{ " + node.word + " | " + String(node.count) + " }\" ]\n"
   }

   private func label(between upperNode: TreeNode, and lowerNode: TreeNode, onEdge edge: String) -> String {
      name(for: upperNode) + " -> " + name(for: lowerNode) + " [ label=\"" + edge + "\" ]\n"
   }

   // MARK: - ValueTreeNode

   func visit(node: EnumTreeNode) throws {
      precondition(fileHandle != nil, "fileHandle is nil, call start() first with valid file name")
      switch node {
         case .Empty:
            return
         case let .Node(left, _, word, count, right):
            var str = "".rightJustified(width: level) + label(for: word, and: count)
            fileHandle.write(str.data(using: .utf8)!)
            switch left {
               case .Empty:
                  break
               case let .Node(_, _, leftWord, _, _):
                  level += 1
                  try left.accept(self)
                  level -= 1
                  str = ("".rightJustified(width: level) + label(between: word, and: leftWord, onEdge: " L"))
                  fileHandle.write(str.data(using: .utf8)!)
                  level += 1
            }
            switch right {
               case .Empty:
                  break
               case let .Node(_, _, rightWord, _, _):
                  level += 1
                  try right.accept(self)
                  level -= 1
                  str = ("".rightJustified(width: level) + label(between: word, and: rightWord, onEdge: " R"))
                  fileHandle.write(str.data(using: .utf8)!)
                  level += 1
            }
      }
   }

   private func name(for word: String) -> String {
      return "node_" + convertSpecialCharacters(word)
   }

   private func label(for word: String, and count: Int) -> String {
      return name(for: word) + " [ label=\"{ " + word + " | " + String(count) + " }\" ]\n"
   }

   private func label(between upperNode: String, and lowerNode: String, onEdge edge: String) -> String {
      name(for: upperNode) + " -> " + name(for: lowerNode) + " [ label=\"" + edge + "\" ]\n"
   }

   private func convertSpecialCharacters(_ string: String) -> String {
      var newString = string
      let char_dictionary = ["$" : "s",
         "&amp;" : "&",
         "&lt;" : "<",
         "&gt;" : ">",
         "&quot;" : "\"",
         "&apos;" : "'"
      ];
      for (escaped_char, unescaped_char) in char_dictionary {
         newString = newString.replacingOccurrences(of: escaped_char, with: unescaped_char, options: NSString.CompareOptions.literal, range: nil)
      }
      return newString
   }

}
