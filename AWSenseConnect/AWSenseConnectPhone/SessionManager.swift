//
//  SessionManager.swift
//  AWSenseConnect
//
//  Created by Katrin Haensel on 03/03/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation
import AWSenseShared

public class SessionManager : MessageEventHandler{
    
    // MARK: - singleton
    
    public static let instance : SessionManager = SessionManager()
    
    private init() {
        CommunicationManager.instance.subscribe(handler: self)
    }
    
    // MARK: - properties
    
    public private(set) var currentSession : RemoteSensingSession?
    
    private let remoteSensingEvent : RemoteSensingEvent = RemoteSensingEvent()
    
    private let sensingBuffer = RemoteSensingDataBuffer.instance
    
    // MARK: - MessageEventHandler interface
    
    internal func handle(message : Message){
        switch message.type {
        case .startedSensing:
            assert(currentSession!.state == .prepareRunning)
            currentSession!.state = .running
            remoteSensingEvent.raiseEvent(withType: .sessionStateChanged, forSession: currentSession!)
        case .stoppedSensing:
            assert(currentSession!.state == .prepareStopping)
            currentSession!.state = .stopped
            remoteSensingEvent.raiseEvent(withType: .sessionStateChanged, forSession: currentSession!)
            sensingBuffer.serialiseAll()
        case .sensingData:
            let pm = message as! SensingDataMessage
            let data = pm.sensingData
            let t = pm.sensingDataType
            remoteSensingEvent.raiseEvent(withType: .remoteSessionDataReceived, forSession: currentSession!, withData: data)
            sensingBuffer.append(sensingData: data, forType: t)
        default: break
            // todo error handling
        }
    }
    
    // MARK: - methods
    
    public func startSensingSession(withName name: String? = nil, configuration: [AWSSensorType]? = nil, transmissionMode : DataTransmissionMode = .batch) throws{
        
        if(currentSession != nil && currentSession!.state != .stopped) {
            throw RemoteSensingSessionError.invalidSessionState(reason: "Session cannot be started, it is already running, terminated or archived")
        }
        
        currentSession = RemoteSensingSession(withName: name, enabledSensors: configuration, transmissionMode: transmissionMode)
        remoteSensingEvent.raiseEvent(withType: .sessionCreated, forSession: currentSession!)
        
        sensingBuffer.initialise(withSession: currentSession!)
        
        if(currentSession != nil && currentSession!.state == .created){
            
            currentSession!.state = .prepareRunning
            
            let message = StartSensingMessage(withConfiguration: currentSession!.sensorConfig, transmisssionMode: currentSession!.transmissionMode)
            CommunicationManager.instance.send(message: message)
            
            remoteSensingEvent.raiseEvent(withType: .sessionStateChanged, forSession: currentSession!)
            
        }

    }
    
    public func stopSensing() throws{
        if(currentSession != nil && (currentSession!.state == .running || currentSession!.state == .prepareRunning)){
            
            currentSession!.state = .prepareStopping
            
            let message = StopSensingMessage()
            CommunicationManager.instance.send(message: message)
            
            remoteSensingEvent.raiseEvent(withType: .sessionStateChanged, forSession: currentSession!)
            
        }else if(currentSession == nil){
            throw RemoteSensingSessionError.invalidSessionState(reason: "Session cannot be stopped, create a session first")
        }
        else {
            throw RemoteSensingSessionError.invalidSessionState(reason: "Session cannot be stopped, it is not running at the moment")
        }
    }
    
    public func getSessionStatus() -> RemoteSensingSessionState?{
        if(currentSession == nil){
            return .undefined
        }else{
            return currentSession!.state
        }
    }
    
    public func isWatchReachable() -> Bool{
        return CommunicationManager.instance.isReachable()
    }
    
    public func subscribe(handler: RemoteSensingEventHandler){
        remoteSensingEvent.add(handler: handler)
    }
    
    public func unsubscribe(handler: RemoteSensingEventHandler){
        remoteSensingEvent.remove(handler: handler)
    }
    
}
