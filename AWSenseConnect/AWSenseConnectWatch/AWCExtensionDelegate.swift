//
//  AWCExtensionDelegate.swift
//  AWSenseConnect
//
//  Created by Katrin Haensel on 24/04/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import WatchKit
import HealthKit

open class AWCExtensionDelegate: NSObject, WKExtensionDelegate, HKWorkoutSessionDelegate {
    
    let healthStore = HKHealthStore()
    var session : HKWorkoutSession?

    
    open func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
    }
    
    open func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    open func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }
    
    open func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                // Be sure to complete the background task once you’re done.
                backgroundTask.setTaskCompleted()
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                // Be sure to complete the connectivity task once you’re done.
                connectivityTask.setTaskCompleted()
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                // Be sure to complete the URL session task once you’re done.
                urlSessionTask.setTaskCompleted()
            default:
                // make sure to complete unhandled task types
                task.setTaskCompleted()
            }
        }
    }
    
    open func handle(_ workoutConfiguration: HKWorkoutConfiguration) {
        do {
            session = try HKWorkoutSession(configuration: workoutConfiguration)
            session!.delegate = self
            healthStore.start(session!)
        } catch {
            fatalError("Unable to create the workout session!")
        }
    }
    
    /// HKWorkoutSessionDelegate
    
    public func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        print("wk session")
    }
    
    public func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        // Do nothing for now
        print("Workout error")
    }
    
    
    public func workoutDidStart(_ date : Date) {
        print ("wk start")

    }
    
    func workoutDidEnd(_ date : Date) {
        print("wk ended")
    }

}


