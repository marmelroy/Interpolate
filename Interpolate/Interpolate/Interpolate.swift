//
//  Interpolate.swift
//  Interpolate
//
//  Created by Roy Marmelstein on 10/04/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation

public class Interpolate {
    
    let interpolations: [Interpolation]
    
    let actions: ([Interpolation] -> ())

    init(interpolations: [Interpolation], actions: ([Interpolation] -> ())) {
        self.interpolations = interpolations
        self.actions = actions
    }
    
    func execute() {
        actions(self.interpolations)
    }
    
}

public protocol Interpolation {
    
    var identifier: String { get set }
    
    var current: NSValue { get set }
}


public class LinearInterpolation: Interpolation {
    
    public var identifier: String
    public var current: NSValue

    public let from: NSValue
    public let to: NSValue
    public let duration: CGFloat
    
    init(identifier: String, from: NSValue, to: NSValue, duration: CGFloat) {
        self.current = from
        self.from = from
        self.to = to
        self.duration = duration
        self.identifier = identifier
    }
    
    public func begin() {
    
    }
    
}