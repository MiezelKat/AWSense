//
//  ViewController.swift
//  AWSenseConnectTest
//
//  Created by Katrin Haensel on 22/02/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import UIKit
import HealthKit
import CoreMotion

import AWSenseShared
import AWSenseConnectPhone

class MainViewController: UITableViewController, RemoteSensingEventHandler {



    @IBOutlet weak var heartRateSwitch: UISwitch!
    
    @IBOutlet weak var accelerometerSwitch: UISwitch!
    
    @IBOutlet weak var deviceMotionSwitch: UISwitch!
    
    @IBOutlet weak var batchSwitch: UISwitch!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var startSensingButton: UIButton!
    
    @IBOutlet weak var sessionStatusLabel: UILabel!
    
    @IBOutlet weak var sessionTimeLabel: UILabel!
    
    @IBOutlet weak var stopSessionButton: UIButton!
    
    @IBOutlet var beforeStartCollection: [UISwitch]!
    
    var timer : Timer?
    
    let sessionManager = SessionManager.instance
    
    var sessionStartDate : Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        sessionManager.subscribe(handler: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startButtonPressed(_ sender: Any) {
        
        //disableStartSessionElements()
        
        var enabledSensors = [AWSSensorType]()
        
        if(heartRateSwitch.isOn){
            enabledSensors.append(.heart_rate)
        }
        if(accelerometerSwitch.isOn){
            enabledSensors.append(.accelerometer)
        }
        if(deviceMotionSwitch.isOn){
            enabledSensors.append(.device_motion)
        }
        
        let transmissionMode : DataTransmissionMode = batchSwitch.isOn ? .batch : .stream
        
        do {
            try sessionManager.startSensingSession(withName: nameTextField.text, configuration: enabledSensors, transmissionMode: transmissionMode)
            
        }catch let error as Error{
            print(error)
        }
        
        
    }
    
    func disableStartSessionElements(){
        beforeStartCollection.forEach({ (s) in
                s.isEnabled = false
            })
        startSensingButton.isEnabled = false
        nameTextField.isEnabled = false
    }
    
    func enableSessionRunningElements(){
        // todo
    }
    
    @IBAction func stopButtonPressed(_ sender: Any) {
        if(timer != nil){
            timer!.invalidate()
        }
        do{
            try sessionManager.stopSensing()
            
        }catch let error as Error{
            print(error)
        }
    }
    
    public func handle(withType type: RemoteSensingEventType, forSession session: RemoteSensingSession) {
        if(type == .sessionCreated){
            self.sessionStatusLabel.text = "session created"
        }else if(type == .sessionStateChanged){
            DispatchQueue.main.async {
                self.sessionStatusLabel.text = session.state.rawValue
                
                if(session.state == .running){
                    self.sessionStartDate = Date()
                    self.timer = Timer.init(timeInterval: 1, target: self, selector: #selector(self.updateTimerLabel), userInfo: nil, repeats: true)
                }
            }
        }
    }
    
    public func updateTimerLabel(){
        DispatchQueue.main.async {
            self.sessionTimeLabel.text = Date().timeIntervalSince(self.sessionStartDate!).description
        }
    }
    
}

