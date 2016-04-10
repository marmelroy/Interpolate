//
//  Interpolate.swift
//  Interpolate
//
//  Created by Roy Marmelstein on 10/04/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation

public protocol Interpolation {
    
    var current: IPValue { get set }
    var progress: CGFloat { get set }
    var completed: Bool { get set }
    var apply: (Interpolatable -> ()) { get set }

    func run()
    func next()
    func stop()
}


public class LinearInterpolation: Interpolation {
    
    public var current: IPValue
    public var completed = false
    public var progress: CGFloat = 0.0
    public var apply: (Interpolatable -> ())

    private let from: IPValue
    private let to: IPValue
    public let duration: CGFloat

    private var displayLink: CADisplayLink?
    
    public init(from: Interpolatable, to: Interpolatable, duration: CGFloat, apply: (Interpolatable -> ())) {
        self.current = from.vectorize()
        self.from = from.vectorize()
        self.to = to.vectorize()
        self.duration = duration
        self.apply = apply
    }
    
    @objc public func next() {
        apply(current.toInterpolatable())
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