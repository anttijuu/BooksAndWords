//
//  File.swift
//  
//
//  Created by Antti Juustila on 23.4.2021.
//

import Foundation

extension String {
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

   var isNumeric : Bool {
      return Double(self) != nil
   }
}
