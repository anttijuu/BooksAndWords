//
//  File.swift
//  
//
//  Created by Antti Juustila on 23.4.2021.
//

import Foundation

typealias UnaryStringOperation = (String) -> Void
typealias FinishOperation = () -> Void

enum Event: String {
   case LoadStopWords
   case LoadFile
   case ProcessRawWord
   case ProcessVerifiedWord
   case Finish
}
