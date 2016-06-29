//
//  Interpolate.swift
//  Interpolate
//
//  Created by Roy Marmelstein on 10/04/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation

/// Interpolate class. Responsible for conducting interpolations.
public class Interpolate {
    
    //MARK: Properties and variables
    
    /// Progress variable. Takes a value between 0.0 and 1,0. CGFloat. Setting it triggers the apply closure.
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
            apply?(current.toInterpolatable())
        }
    }
    
    private var current: IPValue
    private let from: IPValue
    private let to: IPValue
    private var duration: CGFloat = 0.2
    private var diffVectors = [CGFloat]()
    private let function: InterpolationFunction
    private var internalProgress: CGFloat = 0.0
    private var targetProgress: CGFloat = 0.0
    private var apply: (Interpolatable -> ())?
    private var displayLink: CADisplayLink?
    
    // Animation completion handler, called when animate function stops.
    private var animationCompletion:(()->())?
    
    //MARK: Lifecycle
    
    /**
     Initialises an Interpolate object.
     
     - parameter from:     Source interpolatable object.
     - parameter to:       Target interpolatable object.
     - parameter apply:    Apply closure.
     - parameter function: Interpolation function (Basic / Spring / Custom).
     
     - returns: an Interpolate object.
     */
    public init<T: Interpolatable>(from: T, to: T, function: InterpolationFunction = BasicInterpolation.Linear, apply: (T -> ())) {
        let fromVector = from.vectorize()
        let toVector = to.vectorize()
        self.current = fromVector
        self.from = fromVector
        self.to = toVector
        self.apply = { let _ = ($0 as? T).flatMap(apply) }
        self.function = function
        self.diffVectors = calculateDiff(fromVector, to: toVector)
    }
    
    /**
     Invalidates the apply function
     */
    public func invalidate() {
        apply = nil
    }

    //MARK: Animation
    
    /**
     Animates to a targetProgress with a given duration.
     
     - parameter targetProgress: Target progress value. Optional. If left empty assumes 1.0.
     - parameter duration:       Duration in seconds. CGFloat.
     */
    public func animate(targetProgress: CGFloat = 1.0, duration: CGFloat, completion:(()->())? = nil) {
        self.targetProgress = targetProgress
        self.duration = duration
        self.animationCompletion = completion
        displayLink?.invalidate()
        displayLink = CADisplayLink(target: self, selector: #selector(next))
        displayLink?.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    /**
     Stops animation.
     */
    public func stopAnimation() {
        displayLink?.invalidate()
        animationCompletion?()
    }
    
    //MARK: Internal
    
    /**
     Calculates diff between two IPValues.
     
     - parameter from: Source IPValue.
     - parameter to:   Target IPValue.
     
     - returns: Array of diffs. CGFloat
     */
    private func calculateDiff(from: IPValue, to: IPValue) -> [CGFloat] {
        var diffArray = [CGFloat]()
        let vectorCount = from.vectors.count
        for index in 0..<vectorCount {
            let vectorDiff = to.vectors[index] - from.vectors[index]
            diffArray.append(vectorDiff)
        }
        return diffArray
    }

    /**
     Adjusted progress using interpolation function.
     
     - parameter progressValue: Actual progress value. CGFloat.
     
     - returns: Adjusted progress value. CGFloat.
     */
    private func adjustedProgress(progressValue: CGFloat) -> CGFloat {
        return function.apply(progressValue)
    }
    
    /**
     Next function used by animation(). Increments progress based on the duration.
     */
    @objc private func next() {
        let direction: CGFloat = (targetProgress > progress) ? 1.0 : -1.0
        progress += 1/(self.duration*60)*direction
        if (direction > 0 && progress >= targetProgress) || (direction < 0 && progress <= targetProgress) {
            progress = targetProgress
            stopAnimation()
        }
    }
    
}

/**
 *  Interpolation function. Must implement an application function.
 */
public protocol InterpolationFunction {
    /**
     Applies interpolation function to a given progress value.
     
     - parameter progress: Actual progress value. CGFloat
     
     - returns: Adjusted progress value. CGFloat.
     */
    func apply(progress: CGFloat) -> CGFloat
}