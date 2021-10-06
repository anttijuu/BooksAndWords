//
//  File.swift
//  
//
//  Created by Antti Juustila on 16.5.2021.
//

import Foundation

protocol Filter {
   func preparing(from file: String) -> Filter
   func handling(with handler: Handler) -> Filter
   func filter(_ word: String)
   func finish()
}
