//
//  SensingSessionEvents.swift
//  AWSenseConnect
//
//  Created by Katrin Haensel on 03/03/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation

public class SensingEvent{
    
    private var eventHandlers = [SensingEventHandler]()
    
    public func raiseEvent(withType type: SensingEventType, forSession session: SensingSession) {
        for handler in self.eventHandlers {
            handler.handle(withType: type, forSession: session)
        }
    }
    
    public func add(handler: SensingEventHandler){
        eventHandlers.append(handler)
    }
    
    public func remove(handler: SensingEventHandler){
        eventHandlers = eventHandlers.filter { $0 !== handler }
    }
}

public protocol SensingEventHandler : class {
    
    func handle(withType type: SensingEventType, forSession session: SensingSession)
    
}

public enum SensingEventType{
    case sessionStateChanged
    case sessionCreated
}
