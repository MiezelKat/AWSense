//
//  WatchConnectivityManager
//  AWSenseConnect
//
//  Created by Katrin Haensel on 22/02/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation
import WatchConnectivity



/// Commication Manager class
class CommunicationManager: NSObject, WCSessionDelegate {
    
    
    /// Singleton Instance
    static let sharedInstance = CommunicationManager()
    
    // MARK: - Properties
    
    var session : WCSession?
    
    private let event : MessageEvent = MessageEvent()
    
    // MARK: - Initialization
    
    /// Init
    private override init() {
        super.init()
        if WCSession.isSupported() {
            session = WCSession.default()
            
            session?.delegate = self
            session?.activate()
        }
    }
    
    // MARK: - EventHandler
    
    // thats bogus
    
    func subscribe(handler: MessageEventHandler){
        event.add(handler: handler)
    }
    
    func unscribe(handler : MessageEventHandler){
        event.remove(handler: handler)
    }
    
    // Mark: - Send Messages
    
    func updateApplicationContext(_ applicationContext: [String : Any]){
        if(session != nil) {
            //Sends a dictionary of values that a paired and active device can use to synchronize its state. The system sends context data when the opportunity arises, with the goal of having the data ready to use by the time the counterpart wakes up.
            do {
                try session?.updateApplicationContext(applicationContext)
            } catch {
                print("error")
            }
        }
    }
    
    func sendMessage(message: [String : Any]){
        
        if(session?.isReachable)!{
            session?.sendMessage(message, replyHandler: nil, errorHandler: nil)
        }else
        {
            session?.transferUserInfo(message)
        }
    }
    
    
    
    
    // MARK: - WCSessionDelegate Implementation
    
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("session (in state: \(session.activationState.rawValue)) received application context \(applicationContext)")
        
        //configureDeviceDetailsWithApplicationContext(applicationContext: applicationContext)
        
        // NOTE: The guard is here as `watchDirectoryURL` is only available on iOS and this class is used on both platforms.
        #if os(iOS)
            print("session watch directory URL: \(session.watchDirectoryURL?.absoluteString)")
        #endif
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        #if os(watchOS)
            guard let morseCode = userInfo["MorseCode"] as? String else {
                // If the expected values are unavailable in the `userInfo`, then skip it.
                return
            }
            
            // Inform the delegate.
   //         delegate?.watchConnectivityManager(self, updatedWithMorseCode: morseCode)
        #endif
    }
    
    func session(_ session: WCSession, didFinish userInfoTransfer: WCSessionUserInfoTransfer, error: Error?) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            print("completed transfer of \(userInfoTransfer)")
        }
    }
    
    // MARK: WCSessionDelegate - Asynchronous Activation
    
    // The next method is required in order to support asynchronous session activation as well as for quick watch switching.
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("session activation failed with error: \(error.localizedDescription)")
            return
        }
        
        print("session activated with state: \(activationState.rawValue)")
        
     //   configureDeviceDetailsWithApplicationContext(applicationContext: session.receivedApplicationContext)
        
        // NOTE: The guard is here as `watchDirectoryURL` is only available on iOS and this class is used on both platforms.
        #if os(iOS)
            print("session watch directory URL: \(session.watchDirectoryURL?.absoluteString)")
        #endif
    }
    
    #if os(iOS)
    // The next 2 methods are required in order to support quick watch switching.
    func sessionDidBecomeInactive(_ session: WCSession) {
    /*
     The `sessionDidBecomeInactive(_:)` callback indicates sending has been disabled. If your iOS app
     sends content to its Watch extension it will need to stop trying at this point. This sample
     doesn’t send content to its Watch Extension so no action is required for this transition.
     */
    
    print("session did become inactive")
    }
    
    
    func sessionDidDeactivate(_ session: WCSession) {
    print("session did deactivate")
    
    /*
     The `sessionDidDeactivate(_:)` callback indicates `WCSession` is finished delivering content to
     the iOS app. iOS apps that process content delivered from their Watch Extension should finish
     processing that content and call `activateSession()`. This sample immediately calls
     `activateSession()` as the data provided by the Watch Extension is handled immediately.
     */
    session.activate()
    }
    #endif
}
