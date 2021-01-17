//
//  BasicInterpolation.swift
//  Interpolate
//
//  Created by Roy Marmelstein on 10/04/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import UIKit

/**
 Basic interpolation function.
 */
public enum BasicInterpolation: InterpolationFunction {
    /// Linear interpolation.
    case linear
    /// Ease in interpolation.
    case easeIn
    /// Ease out interpolation.
    case easeOut
    /// Ease in out interpolation.
    case easeInOut
    
    /**
     Apply interpolation function
     
     - parameter progress: Input progress value
     
     - returns: Adjusted progress value with interpolation function. 
     */
    public func apply(_ progress: CGFloat) -> CGFloat {
        switch self {
        case .linear:
            return progress
        case .easeIn:
            return progress*progress*progress
        case .easeOut:
            return (progress - 1)*(progress - 1)*(progress - 1) + 1.0
        case .easeInOut:
            if progress < 0.5 {
                return 4.0*progress*progress*progress
            } else {
                let adjustment = (2*progress - 2)
                return 0.5 * adjustment * adjustment * adjustment + 1.0
            }
        }
    }
}
