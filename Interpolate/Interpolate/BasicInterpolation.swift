//
//  BasicInterpolation.swift
//  Interpolate
//
//  Created by Roy Marmelstein on 10/04/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation


public enum BasicInterpolation: InterpolationFunction {
    
    case Linear
    case EaseIn
    case EaseOut
    case EaseInOut
    
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