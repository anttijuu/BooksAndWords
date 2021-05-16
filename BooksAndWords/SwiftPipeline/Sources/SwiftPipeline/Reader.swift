//
//  File.swift
//  
//
//  Created by Antti Juustila on 16.5.2021.
//

import Foundation

protocol Reader {
   func reading(from file: String) -> Reader
   func processing(with processor: Processor) -> Reader
}
