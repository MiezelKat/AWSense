//
//  AWPeriphalEvent.swift
//  AWSense
//
//  Created by Katrin Haensel on 26/04/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation

public class AWSessionStateChangedEvent{
    
    private var eventHandlers = [AWSessionStateChangedEventHandler]()
    
    public func raiseEvent(withType type: AWSessionStateChangedEventType) {
        for handler in self.eventHandlers {
            handler.handle(withType: type)
        }
    }
    
    public func add(handler: AWSessionStateChangedEventHandler){
        eventHandlers.append(handler)
    }
    
    public func remove(handler: AWSessionStateChangedEventHandler){
        eventHandlers = eventHandlers.filter { $0 !== handler }
    }
}

public protocol AWSessionStateChangedEventHandler : class {
    
    func handle(withType type: AWSessionStateChangedEventType)
    
}

public enum AWSessionStateChangedEventType{
    case awSessionAvailable
    case awSessionUnavailable
    case awAppNotInstalled
}
