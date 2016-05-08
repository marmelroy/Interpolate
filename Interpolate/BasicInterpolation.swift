//
//  BasicInterpolation.swift
//  Interpolate
//
//  Created by Roy Marmelstein on 10/04/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation

/**
 Basic interpolation function.
 */
public enum BasicInterpolation: InterpolationFunction {
    /// Linear interpolation.
    case Linear
    /// Ease in interpolation.
    case EaseIn
    /// Ease out interpolation.
    case EaseOut
    /// Ease in out interpolation.
    case EaseInOut
    
    /**
     Apply interpolation function
     
     - parameter progress: Input progress value
     
     - returns: Adjusted progress value with interpolation function. 
     */
    public func apply(progress: CGFloat) -> CGFloat {
        switch self {
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
}