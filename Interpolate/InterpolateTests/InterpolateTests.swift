//
//  InterpolateTests.swift
//  InterpolateTests
//
//  Created by Roy Marmelstein on 10/04/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import XCTest
@testable import Interpolate

class InterpolateTests: XCTestCase {
    
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
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        let value = IPValue(value: NSValue(CGRect: CGRectMake(0, 0, 20, 20)))
//        
//        let linearInterpolation = LinearInterpolation(identifier: "Move", from: 1.0, to: 3.0, duration: 0.3)
//        let simple = Interpolate(interpolations: [linearInterpolation]) { (interpolations) in
//            for interpolation in interpolations {
//                print("interpolation \(interpolation.identifier)")
//            }
//        }
//        self.measureBlock {
//            simple.execute()
//        }
    }
    
}
