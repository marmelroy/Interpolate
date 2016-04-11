//
//  BasicInterpolation.swift
//  Interpolate
//
//  Created by Roy Marmelstein on 10/04/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation

public enum BasicInterpolationEasing {
    case Linear
    case EaseIn
    case EaseOut
    case EaseInOut
}

public class BasicInterpolation: Interpolation {
    
    public var current: IPValue
    public var diffVectors = [CGFloat]()
    public var progress: CGFloat = 0.0 {
        didSet {
            progress = max(0, min(progress, 1.0))
            let easingProgress = self.easingAdjustedProgress(progress, easing: .Linear) - self.easingAdjustedProgress(oldValue, easing: .Linear)
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
    
    func easingAdjustedProgress(progress: CGFloat, easing: BasicInterpolationEasing) -> CGFloat {
        switch easing {
            case .Linear:
                return progress
            case .EaseIn:
                return progress*progress*progress
            case .EaseOut:
                return (progress - 1)*(progress - 1)*(progress - 1) + 1.0
            case .EaseInOut:
                if progress < 0.5 {
                    return 4.0*progress*progress*progress
                } else {
                    let adjustment = (2*progress - 2)
                    return 0.5 * adjustment * adjustment * adjustment + 1.0
                }
        }
    }
    
    @objc public func next() {
        progress += 1/(self.duration*60)
        if progress >= 1.0 {
            progress = 1.0
            stop()
        }
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