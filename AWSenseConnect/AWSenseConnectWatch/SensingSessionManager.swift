//
//  SensingSessionManager.swift
//  AWSenseConnect
//
//  Created by Katrin Haensel on 03/03/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation
import AWSenseShared
import AWSenseWatch

public class SensingSessionManager : MessageEventHandler, AWSSensorEventHandler{


    // MARK: - singleton
    
    public static let instance : SensingSessionManager = SensingSessionManager()
    
    private init() {
        sensingManager =  AWSSensorManager.sharedInstance
        CommunicationManager.instance.subscribe(handler: self)
    }
    
    
    // MARK: - properties
    
    public private(set) var currentSession : SensingSession?
    
    private let sensingEvent : SensingEvent = SensingEvent()
    
    private let sensingManager : AWSSensorManager
    
    // MARK: - MessageEventHandler interface
    
    internal func handle(message : Message){
        switch message.type {
        case .startSensing:
            let m = message as! StartSensingMessage
            handleStart(configuration: m.configuration, transmissionIntervall: m.transmissionIntervall)
        case .stopSensing:
            handleStopTriggered()
        default: break
            // todo error handling
        }
    }
    
    // MARK: - SensingEventHandler interface
    
    public func handleSensing(data: AWSSensorData, type: AWSSensorType) {        
        if(currentSession!.sensorConfig.enabledSensors.contains(type)){
            SensingDataManager.instance.manage(sensingData: data, forType: type)
        }
    }
    
    // MARK: - methods
    
    private func handleStart(configuration: SensingConfiguration, transmissionIntervall intervall : DataTransmissionInterval){

        currentSession = SensingSession(enabledSensorSet: configuration.enabledSensors, transmissionIntervall: intervall)
        
        // prepare the data manager
        
        SensingDataManager.instance.initialise(withSession: currentSession!)
        
        sensingManager.register(eventhandler: self, withConfiguration: currentSession!.sensorConfig)
        sensingManager.startSensing(withSensors: currentSession!.sensorConfig.enabledSensors)
        
        CommunicationManager.instance.send(message: StartedSensingMessage(withStartDate: Date()))
        
        currentSession!.state = .running
        sensingEvent.raiseEvent(withType: .sessionStateChanged, forSession: currentSession!)
    }
    
    private func handleStopTriggered(){
        sensingManager.stopSensing(withSensors: currentSession!.sensorConfig.enabledSensors)
        sensingManager.deregister(eventhandler: self, withConfiguration: currentSession!.sensorConfig)
        
        SensingDataManager.instance.sessionStopped()
        
        CommunicationManager.instance.send(message: StoppedSensingMessage(withStopDate: Date()))
        
        currentSession!.state = .terminated
        sensingEvent.raiseEvent(withType: .sessionStateChanged, forSession: currentSession!)
    }
    
    
    public func isPhoneReachable() -> Bool{
        return CommunicationManager.instance.isReachable()
    }
    
    public func subscribe(handler: SensingEventHandler){
        sensingEvent.add(handler: handler)
    }
    
    public func unsubscribe(handler: SensingEventHandler){
        sensingEvent.remove(handler: handler)
    }
    
}
