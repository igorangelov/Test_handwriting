//
//  HandwritingTests.swift
//  HandwritingTests
//
//  Created by Igor Angelov on 17/12/2016.
//  Copyright © 2016 Igor Angelov. All rights reserved.
//

import XCTest

@testable import Handwriting


class HandwritingTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        
        /*Test cache */
        
        let str: String = "Apple";
        let data: NSData = str.data(using: String.Encoding.utf8)! as NSData
        
        SupraCacheManager.pushDataToCache(url: "test.com", expiredAt: SupraCacheManager.makeExpiredDayWeek(weekLater: 1), data: data )
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    /*Test cache Simple way*/
    func testCacheSimpleWay()
    {
        SupraCacheManager.getData(url: "test.com", expiredAt: SupraCacheManager.makeExpiredDayWeek(weekLater: 1), completion: { (errors, data) -> Void in
            
            XCTAssert(errors == nil)
            
            let datastring = NSString(data: data as! Data, encoding: String.Encoding.utf8.rawValue)
            XCTAssert(datastring == "Apple")
            
        }, callResource: nil)
    }
}
