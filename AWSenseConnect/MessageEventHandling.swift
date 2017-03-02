//
//  MessageEventHandling.swift
//  AWSenseConnect
//
//  Created by Katrin Haensel on 02/03/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation
import AWSenseWatch


public class MessageEvent{
    
    private var eventHandlers = [MessageEventHandler]()
    
    public func raise( message: Message, withType type: MessageType) {
        for handler in self.eventHandlers {
            handler.handle(message: message , withType: type)
        }
    }
    
    public func add(handler: MessageEventHandler){
        eventHandlers.append(handler)
    }
    
    public func remove(handler: MessageEventHandler){
        eventHandlers = eventHandlers.filter { $0 !== handler }
    }
}

public protocol MessageEventHandler : class {
    
    func handle(message : Message, withType type: MessageType)
    
}



