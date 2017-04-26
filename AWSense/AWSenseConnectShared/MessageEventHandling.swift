//
//  MessageEventHandling.swift
//  AWSenseConnect
//
//  Created by Katrin Haensel on 02/03/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation


internal class MessageEvent{
    
    private var eventHandlers = [MessageEventHandler]()
    
    internal func raiseEvent(withMessage message: Message) {
        for handler in self.eventHandlers {
            handler.handle(message: message)
        }
    }
    
    internal func add(handler: MessageEventHandler){
        eventHandlers.append(handler)
    }
    
    internal func remove(handler: MessageEventHandler){
        eventHandlers = eventHandlers.filter { $0 !== handler }
    }
}

internal protocol MessageEventHandler : class {
    
    func handle(message : Message)
    
}



