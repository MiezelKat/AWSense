//
//  RemoteSensingSessionEvents.swift
//  AWSenseConnect
//
//  Created by Katrin Haensel on 03/03/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation
import AWSenseShared

public class RemoteSensingEvent{
    
    private var eventHandlers = [RemoteSensingEventHandler]()
    
    public func raiseEvent(withType type: RemoteSensingEventType, forSession session: RemoteSensingSession? = nil, withData data: [AWSSensorData]? = nil) {
        for handler in self.eventHandlers {
            handler.handle(withType: type, forSession: session, withData: data)
        }
    }
    
    public func add(handler: RemoteSensingEventHandler){
        eventHandlers.append(handler)
    }
    
    public func remove(handler: RemoteSensingEventHandler){
        eventHandlers = eventHandlers.filter { $0 !== handler }
    }
}

public protocol RemoteSensingEventHandler : class {
    
    func handle(withType type: RemoteSensingEventType, forSession session: RemoteSensingSession?, withData data: [AWSSensorData]?)
    
}

public enum RemoteSensingEventType{
    case remoteSessionDataReceived
    case sessionStateChanged
    case sessionCreated
}
