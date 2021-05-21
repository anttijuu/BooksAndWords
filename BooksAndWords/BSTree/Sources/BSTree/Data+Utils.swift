//
//  File.swift
//  
//
//  Created by Antti Juustila on 21.5.2021.
//

import Foundation

// https://stackoverflow.com/a/50497673/10557366

extension Data {
   func append(to url: URL) throws {
      if let fileHandle = try? FileHandle(forWritingTo: url) {
         defer {
            fileHandle.closeFile()
         }
         fileHandle.seekToEndOfFile()
         fileHandle.write(self)
      } else {
         try write(to: url)
      }
   }
}
