//
//  File.swift
//  
//
//  Created by Antti Juustila on 23.4.2021.
//

import Foundation

class EventDispatcher {

   private var unaryHandlers: [Event:UnaryStringOperation] = [:]
   private var finishHandlers: [FinishOperation] = []

   func registerUnaryHandler(for name: Event, handler: @escaping UnaryStringOperation) {
      unaryHandlers[name] = handler
   }

   func registerFinishHandler(for handler: @escaping FinishOperation) {
      finishHandlers.append(handler)
   }

   func dispatch(_ event: Event, param: String?) {
      if let param = param {
         unaryHandlers[event]?(param)
      } else if event == Event.Finish {
         for handler in finishHandlers {
            handler()
         }
      }
   }
}
