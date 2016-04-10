//
//  LinearInterpolation.swift
//  Interpolate
//
//  Created by Roy Marmelstein on 10/04/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation

public class LinearInterpolation: Interpolation {
    
    public var current: IPValue
    public var diffVectors = [CGFloat]()
    public var completed = false
    public var progress: CGFloat = 0.0 {
        didSet {
            progress = max(0, min(progress, 1.0))
            let progressDiff = progress - oldValue
            let vectorCount = from.vectors.count
            for index in 0..<vectorCount {
                current.vectors[index] += diffVectors[index]*progressDiff
            }
            apply(current.toInterpolatable())
        }
    }
    public var apply: (Interpolatable -> ())
    
    private let from: IPValue
    private let to: IPValue
    private let duration: CGFloat
    
    
    public var displayLink: CADisplayLink?
    
    public init(from: Interpolatable, to: Interpolatable, duration: CGFloat, apply: (Interpolatable -> ())) {
        let fromVector = from.vectorize()
        let toVector = to.vectorize()
        self.current = fromVector
        self.from = fromVector
        self.to = toVector
        self.duration = duration
        self.apply = apply
        
        self.diffVectors = calculateDiff(fromVector, to: toVector)
    }
    
    @objc public func next() {
        progress += 1/(self.duration*60)
        if progress >= 1.0 {
            progress = 1.0
            completed = true
            stop()
        }
    }
    
    public func run() {
        displayLink?.invalidate()
        displayLink = CADisplayLink(target: self, selector: #selector(next))
        displayLink?.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    public func stop() {
        completed = true
        displayLink?.invalidate()
    }
    
}