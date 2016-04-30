//
//  Interpolate.swift
//  Interpolate
//
//  Created by Roy Marmelstein on 10/04/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation

public class Interpolate {
    
    public var current: IPValue
    public var diffVectors = [CGFloat]()
    public var progress: CGFloat = 0.0 {
        didSet {
            progress = max(0, min(progress, 1.0))
            let nextInternalProgress = self.adjustedProgress(progress)
            let easingProgress = nextInternalProgress - internalProgress
            internalProgress = nextInternalProgress
            let vectorCount = from.vectors.count
            for index in 0..<vectorCount {
                current.vectors[index] += diffVectors[index]*easingProgress
            }
            
            apply(current.toInterpolatable())
        }
    }
    
    public var apply: (Interpolatable -> ())
    
    private let from: IPValue
    private let to: IPValue
    private let function: InterpolationFunction
    private var internalProgress: CGFloat = 0.0
    private var duration: CGFloat = 0.3
    
    public var displayLink: CADisplayLink?
    
    public init(from: Interpolatable, to: Interpolatable, apply: (Interpolatable -> ()), function: InterpolationFunction = BasicInterpolation.Linear) {
        let fromVector = from.vectorize()
        let toVector = to.vectorize()
        self.current = fromVector
        self.from = fromVector
        self.to = toVector
        self.apply = apply
        self.function = function
        self.diffVectors = calculateDiff(fromVector, to: toVector)
    }
    
    func adjustedProgress(progressValue: CGFloat) -> CGFloat {
        return function.apply(progressValue)
    }
    
    @objc public func next() {
        progress += 1/(self.duration*60)
        if progress >= 1.0 {
            progress = 1.0
            stop()
        }
    }
    
    public func animate(duration: CGFloat) {
        self.duration = duration
        displayLink?.invalidate()
        displayLink = CADisplayLink(target: self, selector: #selector(next))
        displayLink?.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    public func stop() {
        displayLink?.invalidate()
    }
    
    public func calculateDiff(from: IPValue, to: IPValue) -> [CGFloat] {
        var diffArray = [CGFloat]()
        let vectorCount = from.vectors.count
        for index in 0..<vectorCount {
            let vectorDiff = to.vectors[index] - from.vectors[index]
            diffArray.append(vectorDiff)
        }
        return diffArray
    }
    
}

public protocol InterpolationFunction {
    func apply(progress: CGFloat) -> CGFloat
}