//
//  File.swift
//  
//
//  Created by Antti Juustila on 16.5.2021.
//

import Foundation

protocol Processor {
   func filtering(with filter: Filter) -> Processor
   func process(char: Character)
   func finish()
}
