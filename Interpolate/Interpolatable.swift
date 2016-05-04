//
//  Interpolatable.swift
//  Interpolate
//
//  Created by Roy Marmelstein on 10/04/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation
import QuartzCore

/**
 *  Interpolatable protocol. Requires implementation of a vectorize function.
 */
public protocol Interpolatable {
    func vectorize() -> IPValue
}

/**
 Supported interpolatable types.

 - CGPoint:             CGPoint type.
 - CGRect:              CGRect type.
 - CGSize:              CGSize type.
 - Double:              Double type.
 - CGFloat:             CGFloat type.
 - Int:                 Int type.
 - NSNumber:            NSNumber type.
 - ColorRGB:            ColorRGB type.
 - ColorMonochrome:     ColorMonochrome type.
 - ColorHSB:            ColorHSB type.
 - CGAffineTransform:   CGAffineTransform type.
 - CATransform3D:       CATransform3D type
 */

public enum InterpolatableType {
    case CGPoint
    case CGRect
    case CGSize
    case Double
    case CGFloat
    case Int
    case NSNumber
    case ColorRGB
    case ColorMonochrome
    case ColorHSB
    case CGAffineTransform
    case CATransform3D
}

// MARK: Extensions

extension CGPoint: Interpolatable {
    /**
     Vectorize CGPoint.
     
     - returns: IPValue
     */
    public func vectorize() -> IPValue {
        return IPValue(vectors: [self.x, self.y], type: .CGPoint)
    }
}

extension CGRect: Interpolatable {
    /**
     Vectorize CGRect.
     
     - returns: IPValue
     */
    public func vectorize() -> IPValue {
        return IPValue(vectors: [self.origin.x, self.origin.y, self.size.width, self.size.height], type: .CGRect)
    }
}

extension CGSize: Interpolatable {
    /**
     Vectorize CGSize.
     
     - returns: IPValue
     */
    public func vectorize() -> IPValue {
        return IPValue(vectors: [self.width, self.height], type: .CGSize)
    }
}

extension NSNumber: Interpolatable {
    /**
     Vectorize NSNumber.
     
     - returns: IPValue
     */
    public func vectorize() -> IPValue {
        return IPValue(vectors: [CGFloat(self)], type: .NSNumber)
    }
}

extension Int: Interpolatable {
    /**
     Vectorize Int.
     
     - returns: IPValue
     */
    public func vectorize() -> IPValue {
        return IPValue(vectors: [CGFloat(self)], type: .Int)
    }
}

extension Double: Interpolatable {
    /**
     Vectorize Double.
     
     - returns: IPValue
     */
    public func vectorize() -> IPValue {
        return IPValue(vectors: [CGFloat(self)], type: .Double)
    }
}

extension CGFloat: Interpolatable {
    /**
     Vectorize CGFloat.
     
     - returns: IPValue
     */
    public func vectorize() -> IPValue {
        return IPValue(vectors: [self], type: .CGFloat)
    }
}

extension CGAffineTransform: Interpolatable {
    /**
     Vectorize CGAffineTransform.
     
     - returns: IPValue
     */
    public func vectorize() -> IPValue {
        return IPValue(vectors: [self.a, self.b, self.c, self.d, self.tx, self.ty], type: .CGFloat)
    }
}

extension CATransform3D: Interpolatable {
    /**
     Vectorize CATransform3D.
     
     - returns: IPValue
     */
    public func vectorize() -> IPValue {
        return IPValue(vectors: [self.m11, self.m12, self.m13, self.m14, self.m21, self.m22, self.m23, self.m24, self.m31, self.m32, self.m33, self.m34, self.m41, self.m42, self.m43, self.m44], type: .CGFloat)
    }
}

extension UIColor: Interpolatable {
    /**
     Vectorize UIColor.
     
     - returns: IPValue
     */
    public func vectorize() -> IPValue {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        
        if getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return IPValue(vectors: [red, green, blue, alpha], type: .ColorRGB)
        }
        
        var white: CGFloat = 0
        
        if getWhite(&white, alpha: &alpha) {
            return IPValue(vectors: [white, alpha], type: .ColorMonochrome)
        }
        
        var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0
        
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        return IPValue(vectors: [hue, saturation, brightness, alpha], type: .ColorHSB)
    }
}

public class IPValue {
    
    var vectors: [CGFloat]
    let type: InterpolatableType
    
    init (vectors: [CGFloat], type: InterpolatableType) {
        self.vectors = vectors
        self.type = type
    }
    
    func toInterpolatable() -> Interpolatable {
        switch type {
            case .CGPoint:
                return CGPoint(x: vectors[0], y: vectors[1])
            case .CGRect:
                return CGRect(x: vectors[0], y: vectors[1], width: vectors[2], height: vectors[3])
            case .CGSize:
                return CGSize(width: vectors[0], height: vectors[1])
            case .Double:
                return vectors[0]
            case .CGFloat:
                return vectors[0]
            case .Int:
                return vectors[0]
            case .NSNumber:
                return vectors[0]
            case .ColorRGB:
                return UIColor(red: vectors[0], green: vectors[1], blue: vectors[2], alpha: vectors[3])
            case .ColorMonochrome:
                return UIColor(white: vectors[0], alpha: vectors[1])
            case .ColorHSB:
                return UIColor(hue: vectors[0], saturation: vectors[1], brightness: vectors[2], alpha: vectors[3])
            case .CGAffineTransform:
                return CGAffineTransform(a: vectors[0], b: vectors[1], c: vectors[2], d: vectors[3], tx: vectors[4], ty: vectors[5])
            case .CATransform3D:
                return CATransform3D(m11: vectors[0], m12: vectors[1], m13: vectors[2], m14: vectors[3], m21: vectors[4], m22: vectors[5], m23: vectors[6], m24: vectors[7], m31: vectors[8], m32: vectors[9], m33: vectors[10], m34: vectors[11], m41: vectors[12], m42: vectors[13], m43: vectors[14], m44: vectors[15])
        }
    }
    
}


