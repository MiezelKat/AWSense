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
        
    }
    
    
    // MARK: - properties
    
    public private(set) var currentSession : SensingSession?
    
    private let sensingEvent : SensingEvent = SensingEvent()
    
    private let sensingManager : AWSSensorManager = AWSSensorManager.sharedInstance
    
    // MARK: - MessageEventHandler interface
    
    internal func handle(message : Message){
        switch message.type {
        case .startSensing:
            handleStartTriggered()
        case .stopSensing:
            handleStopTriggered()
        case .configuration :
            let m = message as! ConfigurationMessage
            handleConfigurationChanged(configuration: m.configuration, transmissionMode: m.transmissionMode)
        default: break
            // todo error handling
        }
    }
    
    // MARK: - SensingEventHandler interface
    
    public func handleSensing(data: AWSSensorData, type: AWSSensorType) {
        if(currentSession!.sensorConfig.enabledSensors.contains(type)){
            // todo handle sensing data
        }
    }
    
    // MARK: - methods
    
    private func handleStartTriggered(){
        
        sensingManager.startSensing(withSensors: currentSession!.sensorConfig.enabledSensors)
        
        CommunicationManager.instance.send(message: StartedSensingMessage(withStartDate: Date()))
        
        currentSession!.state = .running
        sensingEvent.raiseEvent(withType: .sessionStateChanged, forSession: currentSession!)
    }
    
    private func handleStopTriggered(){
        sensingManager.stopSensing(withSensors: currentSession!.sensorConfig.enabledSensors)
        
        CommunicationManager.instance.send(message: StoppedSensingMessage(withStopDate: Date()))
        
        currentSession!.state = .terminated
        sensingEvent.raiseEvent(withType: .sessionStateChanged, forSession: currentSession!)
    }
    
    private func handleConfigurationChanged(configuration: SensingConfiguration, transmissionMode mode : DataTransmissionMode){
        currentSession?.reset(transmissionMode: mode)
        currentSession?.reset(configuration: configuration)
        
        
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
