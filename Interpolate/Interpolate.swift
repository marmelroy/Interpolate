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
            // We make sure progress is between 0.0 and 1.0
            progress = max(0, min(progress, 1.0))
            internalProgress = self.internalAdjustedProgress(progress)
            let valueForProgress = internalProgress*(valuesCount - 1)
            let diffVectorIndex = max(Int(ceil(valueForProgress)) - 1, 0)
            let diffVector = diffVectors[diffVectorIndex]
            let originValue = values[diffVectorIndex]
            let adjustedProgress = valueForProgress - CGFloat(diffVectorIndex)
            for index in 0..<vectorCount {
                current.vectors[index] = originValue.vectors[index] + diffVector[index]*adjustedProgress
            }
            apply?(current.toInterpolatable())
        }
    }
    
    private var current: IPValue
    private let values: [IPValue]
    private var valuesCount: CGFloat { get { return CGFloat(values.count) } }
    private var vectorCount: Int { get { return current.vectors.count } }
    private var duration: CGFloat = 0.2
    private var diffVectors = [[CGFloat]]()
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
     
     - parameter values:   Array of interpolatable objects, in order.
     - parameter apply:    Apply closure.
     - parameter function: Interpolation function (Basic / Spring / Custom).
     
     - returns: an Interpolate object.
     */
    public init<T: Interpolatable>(values: [T], function: InterpolationFunction = BasicInterpolation.Linear, apply: (T -> ())) {
        assert(values.count >= 2, "You should provide at least two values")
        let vectorizedValues = values.map({$0.vectorize()})
        self.values = vectorizedValues
        self.current = IPValue(value: self.values[0])
        self.apply = { let _ = ($0 as? T).flatMap(apply) }
        self.function = function
        self.diffVectors = self.calculateDiff(vectorizedValues)
    }
    
    
    /**
     Initialises an Interpolate object.
     
     - parameter from:     Source interpolatable object.
     - parameter to:       Target interpolatable object.
     - parameter apply:    Apply closure.
     - parameter function: Interpolation function (Basic / Spring / Custom).
     
     - returns: an Interpolate object.
     */
    public convenience init<T: Interpolatable>(from: T, to: T, function: InterpolationFunction = BasicInterpolation.Linear, apply: (T -> ())) {
        let values = [from, to]
        self.init(values: values, function: function, apply: apply)
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
     - parameter completion:     Completion handler. Optional.
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
    private func calculateDiff(values: [IPValue]) -> [[CGFloat]] {
        var valuesDiffArray = [[CGFloat]]()
        for i in 0..<(values.count - 1) {
            var diffArray = [CGFloat]()
            let from = values[i]
            let to = values[i+1]
            for index in 0..<from.vectors.count {
                let vectorDiff = to.vectors[index] - from.vectors[index]
                diffArray.append(vectorDiff)
            }
            valuesDiffArray.append(diffArray)
        }
        return valuesDiffArray
    }

    /**
     Adjusted progress using interpolation function.
     
     - parameter progressValue: Actual progress value. CGFloat.
     
     - returns: Adjusted progress value. CGFloat.
     */
    private func internalAdjustedProgress(progressValue: CGFloat) -> CGFloat {
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