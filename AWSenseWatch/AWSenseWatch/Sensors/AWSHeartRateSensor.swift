//
//  AWSHeartRateSensor.swift
//  AWSenseWatch
//
//  Created by Katrin Haensel on 17/02/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import Foundation


import WatchKit
import Foundation
import HealthKit


class AWSHeartRateSensor : NSObject, AWSSensor, HKWorkoutSessionDelegate{
    
    static let sensorSingleton = AWSHeartRateSensor()
    
    static var sensorType : AWSSensorType {
        get{
            return AWSSensorType.heart_rate
        }
    }
    
    let healthStore: HKHealthStore
    
    //State of the app - is the workout activated
    var startedSensing = false
    
    var session : HKWorkoutSession?
    let heartRateUnit = HKUnit(from: "count/min")
    var currenQuery : HKQuery?
    
    private var event : AWSSensorEvent = AWSSensorEvent(type: sensorType)
    
    private var authorisationAllowed = false
    
    private override init(){
        healthStore = HKHealthStore()
        super.init()
        let quantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)
        
        
        
        if(quantityType != nil){
            let dataTypes = Set(arrayLiteral: quantityType!)
            healthStore.requestAuthorization(toShare: nil, read: dataTypes) { (success, error) -> Void in
                self.authorisationAllowed = success
                print("sensor allowed")
            }
        }
    }
    
    func register(eventHander : AWSSensorEventHandler){
        event.add(handler: eventHander)
    }
    
    func deregister(eventHander : AWSSensorEventHandler){
        event.remove(handler: eventHander)
    }
    
    func isAvailable() -> Bool {
        return HKHealthStore.isHealthDataAvailable() 
    }
    
    func isRegistered() -> Bool{
        return true
        // TODO:
    }
    
    func isSensing() -> Bool{
        return startedSensing
    }
    
    func startSensing(){
        startedSensing = true

        // If we have already started the workout, then do nothing.
        if (session != nil) {
            print ("session nil")
            return
        }
        
        // Configure the workout session.
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = .other
        workoutConfiguration.locationType = .indoor
        
        do {
            session = try HKWorkoutSession(configuration: workoutConfiguration)
            session?.delegate = self
        } catch {
            fatalError("Unable to create the workout session!")
        }
        print("start hk")
        healthStore.start(self.session!)
    }
    
    func stopSensing(){
        startedSensing = false
        if let workout = self.session {
            healthStore.end(workout)
        }
    }
    
    func createHeartRateStreamingQuery(_ workoutStartDate: Date) -> HKQuery? {
        
        guard let quantityType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate) else { return nil }
        let datePredicate = HKQuery.predicateForSamples(withStart: workoutStartDate, end: nil, options: .strictEndDate )
        //let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates:[datePredicate])
        
        
        let heartRateQuery = HKAnchoredObjectQuery(type: quantityType, predicate: predicate, anchor: nil, limit: Int(HKObjectQueryNoLimit)) { (query, sampleObjects, deletedObjects, newAnchor, error) -> Void in
        }
        
        heartRateQuery.updateHandler = {(query, samples, deleteObjects, newAnchor, error) -> Void in
            //self.anchor = newAnchor!
            self.sendHRUpdate(samples: samples)
        }
        return heartRateQuery
    }
    
    
    func sendHRUpdate(samples : [HKSample]?){
        guard let heartRateSamples = samples as? [HKQuantitySample] else {return}
        DispatchQueue.main.async {
            guard let sample = heartRateSamples.first else{return}
            let value = sample.quantity.doubleValue(for: self.heartRateUnit)
            print("value")
            self.event.raise(data: AWSHeartRateSensorData(timestamp: AWSTimestamp(date: sample.endDate) , heartRate: value ))
        }
    }
    
    /// HKWorkoutSessionDelegate
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        print("wk session")
        switch toState {
        case .running:
            workoutDidStart(date)
        case .ended:
            workoutDidEnd(date)
        default:
            print("Unexpected state \(toState)")
        }
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        // Do nothing for now
        print("Workout error")
    }
    
    
    func workoutDidStart(_ date : Date) {
        print ("wk start")
        if let query = createHeartRateStreamingQuery(date) {
            self.currenQuery = query
            healthStore.execute(query)
        } else {
            // TODO error
        }
    }
    
    func workoutDidEnd(_ date : Date) {
        healthStore.stop(self.currenQuery!)
        session = nil
    }
    
}
