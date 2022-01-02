//
//  Visitor.swift
//  
//
//  Created by Antti Juustila on 21.5.2021.
//

import Foundation

protocol Visitor: AnyObject {
   func visit(node: TreeNode) throws
}
