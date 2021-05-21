//
//  File.swift
//  
//
//  Created by Antti Juustila on 21.5.2021.
//

import Foundation

class DotGenerator: Visitor {

   let file: URL
   var level: Int = 0

   init(file: URL) {
      self.file = file
   }

   func start() {
      do {
         try "digraph TOLLuK {".appendLine(to: file)
         try "node [shape=record, style=\"rounded,filled\"]".appendLine(to: file)
      } catch {
         fatalError("Error in creating .dot file, aborting \(error)")
      }
   }

   func finish() {
      do {
         try "}".appendLine(to: file)
      } catch {
         fatalError("Error in writing .dot file, aborting \(error)")
      }
   }

   func visit(node: TreeNode) throws {
      if let left = node.left {
         level += 1
         try left.accept(self)
         level -= 1
         try label(between: node, and: left, onEdge: "L").appendLine(to: file)
      }
      let str = "".rightJustified(width: level) + label(for: node)
      try str.appendLine(to: file)
      if let right = node.right {
         level += 1
         try right.accept(self)
         level -= 1
         try label(between: node, and: right, onEdge: "R").appendLine(to: file)
      }
   }

   private func name(for node: TreeNode) -> String {
      return "node_" + node.word
   }

   private func label(for node: TreeNode) -> String {
      return name(for: node) + " [ label=\"{ " + node.word + " | " + String(node.count) + " }\" ]"
   }

   private func label(between upperNode: TreeNode, and lowerNode: TreeNode, onEdge edge: String) -> String {
      name(for: upperNode) + " -> " + name(for: lowerNode) + " [ label=\"" + edge + "\" ]"
   }

}
