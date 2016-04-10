//
//  Interpolate.swift
//  Interpolate
//
//  Created by Roy Marmelstein on 10/04/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation

public protocol Interpolation {
    
    var current: NSValue { get set }
    var progress: CGFloat { get set }
    var completed: Bool { get set }
    var apply: (NSValue -> ()) { get set }

    func run()
    func next()
    func stop()
}


public class LinearInterpolation: Interpolation {
    
    public var current: NSValue
    public var completed = false
    public var progress: CGFloat = 0.0
    public var apply: (NSValue -> ())

    public let from: NSValue
    public let to: NSValue
    public let duration: CGFloat

    private var displayLink: CADisplayLink?
    
    public init(from: NSValue, to: NSValue, duration: CGFloat, apply: (NSValue -> ())) {
        self.current = from
        self.from = from
        self.to = to
        self.duration = duration
        self.apply = apply
    }
    
    @objc public func next() {
    
    }
    
    public func run() {
        displayLink?.invalidate()
        displayLink = CADisplayLink(target: self, selector: #selector(next))
        displayLink?.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    public func stop() {
        displayLink?.invalidate()
    }

    
}