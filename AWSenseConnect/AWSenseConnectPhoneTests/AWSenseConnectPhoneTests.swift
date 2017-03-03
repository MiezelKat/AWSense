//
//  AWSenseConnectPhoneTests.swift
//  AWSenseConnectPhoneTests
//
//  Created by Katrin Haensel on 02/03/2017.
//  Copyright © 2017 Katrin Haensel. All rights reserved.
//

import XCTest
@testable import AWSenseConnectPhone
@testable import AWSenseShared

class AWSenseConnectPhoneTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMessageParsing() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let startedMessage = ConfigurationMessage(withConfiguration: SensingConfiguration(), transmisssionMode: .stream)
        
        let payload = startedMessage.createPayload()
        print(payload)
        
        
        let parsedMessage = MessageParser.parseMessage(fromPayload: payload) as! ConfigurationMessage
        
        let parsedMessagePayload = parsedMessage.createPayload()
        print(parsedMessagePayload)
        
        XCTAssert(startedMessage.transmissionMode == parsedMessage.transmissionMode)
    }
    

    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
