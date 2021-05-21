//
//  File.swift
//  
//
//  Created by Antti Juustila on 21.5.2021.
//

import Foundation

extension String {
   // Modified from https://stackoverflow.com/a/52016010/10557366
   func rightJustified(width: Int, fillChar: String = " ", truncate: Bool = false) -> String {
      guard width > count else {
         return truncate ? String(suffix(width)) : self
      }
      return String(repeating: fillChar, count: width - count) + self
   }

   func leftJustified(width: Int, fillChar: String = " ", truncate: Bool = false) -> String {
      guard width > count else {
         return truncate ? String(prefix(width)) : self
      }
      return self + String(repeating: fillChar, count: width - count)
   }

   // From https://stackoverflow.com/a/44871156/10557366
   var isNumeric : Bool {
      return Double(self) != nil
   }

   // https://stackoverflow.com/a/50497673/10557366
   func appendLine(to url: URL) throws {
      try self.appending("\n").append(to: url)
   }
   
   func append(to url: URL) throws {
      let data = self.data(using: String.Encoding.utf8)
      try data?.append(to: url)
   }

}
