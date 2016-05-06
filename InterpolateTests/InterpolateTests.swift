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
    
    func testLinearInterpolation() {
        let from: CGFloat = 0.0
        let to: CGFloat = 10.0
        var progressTest: CGFloat = 0.0
        let interpolation = Interpolate(from: from, to: to, apply: { (result) in
            XCTAssertEqual(progressTest*10, result)
        })
        progressTest = 0.25
        interpolation.progress = progressTest
        progressTest = 0.5
        interpolation.progress = progressTest
        progressTest = 0.75
        interpolation.progress = progressTest
    }
    
    func testEaseInInterpolation() {
        let from: CGFloat = 0.0
        let to: CGFloat = 10.0
        var progressTest: CGFloat = 0.0
        let interpolation = Interpolate(from: from, to: to, function: BasicInterpolation.EaseIn) { (result) in
            XCTAssertTrue(progressTest*10 > result)
        }
        progressTest = 0.25
        interpolation.progress = progressTest
        progressTest = 0.5
        interpolation.progress = progressTest
        progressTest = 0.75
        interpolation.progress = progressTest
    }
    
    func testEaseOutInterpolation() {
        let from: CGFloat = 0.0
        let to: CGFloat = 10.0
        var progressTest: CGFloat = 0.0
        let interpolation = Interpolate(from: from, to: to, function: BasicInterpolation.EaseOut) { (result) in
            XCTAssertTrue(progressTest*10 < result)
        }
        progressTest = 0.25
        interpolation.progress = progressTest
        progressTest = 0.5
        interpolation.progress = progressTest
        progressTest = 0.75
        interpolation.progress = progressTest
    }
    
}
