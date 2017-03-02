//
//  Event.swift
//  AWSenseWatch
//
//  Created by Katrin Haensel on 17/02/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation


public class AWSSensorEvent {
    
    private let type : AWSSensorType
    
    init(type: AWSSensorType){
        self.type = type
    }
    
    private var eventHandlers = [AWSSensorEventHandler]()
    
    public func raise(data: AWSSensorData) {
        for handler in self.eventHandlers {
            handler.handleSensing(data: data, type: type)
        }
    }
    
    public func add(handler: AWSSensorEventHandler){
        eventHandlers.append(handler)
    }
    
    public func remove(handler: AWSSensorEventHandler){
        eventHandlers = eventHandlers.filter { $0 !== handler }
    }
}

public protocol AWSSensorEventHandler : class {
    
    func handleSensing(data : AWSSensorData, type : AWSSensorType)
    
}




