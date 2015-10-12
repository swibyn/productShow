//
//  WebApiTest.swift
//  ProductShow
//
//  Created by s on 15/10/12.
//  Copyright (c) 2015年 gaozgao. All rights reserved.
//

import UIKit
import XCTest

class WebApiTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        WebApi.SendEquipCode(["eqNo":"EQNO","eqName":"EQNAME"], completedHandler: { (response, data, error) -> Void in
            var errorPointer: NSErrorPointer = nil
            var json:AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: errorPointer)
            println("json=\(json)")
        XCTAssert(true, "Pass")
        })
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
