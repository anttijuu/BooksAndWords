//
//  File.swift
//  
//
//  Created by Antti Juustila on 16.5.2021.
//

import Foundation

protocol Handler {
   func handle(_ word: String)
   func print() -> Handler
}
