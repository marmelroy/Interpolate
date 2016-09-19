//
//  InterpolatableTests.swift
//  Interpolate
//
//  Created by Roy Marmelstein on 03/05/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import XCTest
@testable import Interpolate

class InterpolatableTests: XCTestCase {
    
    func testVectorizeCGPoint() {
        let original = CGPoint(x: 20, y: 40)
        let vector = original.vectorize()
        XCTAssertTrue(vector.vectors.count == 2)
        XCTAssertEqual(vector.vectors[1], 40)
    }
    
    func testVectorizeCGRect() {
        let original = CGRect(x: 20, y: 40, width: 60, height: 80)
        let vector = original.vectorize()
        XCTAssertTrue(vector.vectors.count == 4)
        XCTAssertEqual(vector.vectors[1], 40)
    }
    
    func testVectorizeCGSize() {
        let original = CGPoint(x: 20, y: 40)
        let vector = original.vectorize()
        XCTAssertTrue(vector.vectors.count == 2)
        XCTAssertEqual(vector.vectors[1], 40)
    }

    func testVectorizeNSNumber() {
        let original = NSNumber(value: 40)
        let vector = original.vectorize()
        XCTAssertTrue(vector.vectors.count == 1)
        XCTAssertEqual(vector.vectors[0], 40)
    }
    
    func testVectorizeInt() {
        let original: Int = 40
        let vector = original.vectorize()
        XCTAssertTrue(vector.vectors.count == 1)
        XCTAssertEqual(vector.vectors[0], 40)
    }
    
    func testVectorizeDouble() {
        let original: Double = 40
        let vector = original.vectorize()
        XCTAssertTrue(vector.vectors.count == 1)
        XCTAssertEqual(vector.vectors[0], 40)
    }
    
    func testVectorizeCGFloat() {
        let original: CGFloat = 40
        let vector = original.vectorize()
        XCTAssertTrue(vector.vectors.count == 1)
        XCTAssertEqual(vector.vectors[0], 40)
    }
    
    func testVectorizeCGAffineTransform() {
        let original = CGAffineTransform(scaleX: 0.5, y: 0.6)
        let vector = original.vectorize()
        XCTAssertTrue(vector.vectors.count == 6)
        XCTAssertEqual(vector.vectors[0], 0.5)
    }
    
    func testVectorizeCATransform3D() {
        let original = CATransform3DMakeScale(0.6, 0.5, 0.4)
        let vector = original.vectorize()
        XCTAssertTrue(vector.vectors.count == 16)
        XCTAssertEqual(vector.vectors[0], 0.6)
    }

    func testVectorizeUIColor() {
        let original = UIColor.red
        let vector = original.vectorize()
        XCTAssertTrue(vector.vectors.count == 4)
        XCTAssertEqual(vector.vectors[0], 1.0)
    }
    
}
