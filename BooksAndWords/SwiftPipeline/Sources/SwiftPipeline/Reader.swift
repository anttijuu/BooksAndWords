//
//  File.swift
//  
//
//  Created by Antti Juustila on 16.5.2021.
//

import Foundation

protocol Reader {
   func read(from file: String) -> Reader
   func process(with processor: Processor) -> Reader
}
