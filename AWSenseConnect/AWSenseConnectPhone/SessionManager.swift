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
    
    }
    
    // MARK: - properties
    
    public private(set) var currentSession : RemoteSensingSession?
    
    private let remoteSensingEvent : RemoteSensingEvent = RemoteSensingEvent()
    
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
        case .sensingData:
            remoteSensingEvent.raiseEvent(withType: .remoteSessionDataReceived, forSession: currentSession!)
        default: break
            // todo error handling
        }
    }
    
    // MARK: - methods
    
    public func createSession(withName name: String? = nil, configuration: [AWSSensorType]? = nil, transmissionMode : DataTransmissionMode = .batch) throws -> RemoteSensingSession  {
        if(currentSession != nil && (currentSession!.state == .running || currentSession!.state == .prepareRunning || currentSession!.state == .prepareStopping )){
            throw RemoteSensingSessionError.cannotCreateSession(reason: "Invalid Session State: \(currentSession?.state)")
        }

        currentSession = RemoteSensingSession(withName: name, enabledSensors: configuration, transmissionMode: transmissionMode)
        remoteSensingEvent.raiseEvent(withType: .sessionCreated, forSession: currentSession!)
        return currentSession!
    }
    
    public func configureSession(withSensors sensors: [AWSSensorType]? = nil, transmissionMode : DataTransmissionMode? = nil) throws{
        if(sensors == nil && transmissionMode == nil){
            return
        }
        
        if(currentSession != nil && currentSession!.state == .created){
            if(sensors != nil){
                currentSession!.resetConfig(enabledSensors: sensors!)
            }
            if(transmissionMode != nil){
                currentSession!.reset(transmissionMode: transmissionMode!)
            }
            
            // Todo: send to watch
            
            let configMessage = ConfigurationMessage(withConfiguration: currentSession!.sensorConfig, transmisssionMode: currentSession!.transmissionMode)
            CommunicationManager.instance.send(message: configMessage)
            
        }else
        {
            throw RemoteSensingSessionError.cannotChangeSessionConfig(reason: "Session is running, terminated or archived")
        }
    }
    
    
    
    public func startSensing() throws{
        if(currentSession != nil && currentSession!.state == .created){
            
            currentSession!.state = .prepareRunning
            
            let message = StartSensingMessage()
            CommunicationManager.instance.send(message: message)
            
            remoteSensingEvent.raiseEvent(withType: .sessionStateChanged, forSession: currentSession!)
            
        }else if(currentSession == nil){
            throw RemoteSensingSessionError.invalidSessionState(reason: "Session cannot be started, create a session first")
        }
        else {
            throw RemoteSensingSessionError.invalidSessionState(reason: "Session cannot be started, it is already running, terminated or archived")
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
