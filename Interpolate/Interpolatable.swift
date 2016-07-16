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
    /**
     Vectorizes the type and returns and IPValue
     */
    func vectorize() -> IPValue
}

/**
 Supported interpolatable types.
 */

public enum InterpolatableType {
    /// CATransform3D type.
    case CATransform3D
    /// CGAffineTransform type.
    case CGAffineTransform
    /// CGFloat type.
    case CGFloat
    /// CGPoint type.
    case CGPoint
    /// CGRect type.
    case CGRect
    /// CGSize type.
    case CGSize
    /// ColorHSB type.
    case ColorHSB
    /// ColorMonochrome type.
    case ColorMonochrome
    /// ColorRGB type.
    case ColorRGB
    /// Double type.
    case Double
    /// Int type.
    case Int
    /// NSNumber type.
    case NSNumber
    /// UIEdgeInsets type.
    case UIEdgeInsets
}

// MARK: Extensions

/// CATransform3D Interpolatable extension.
extension CATransform3D: Interpolatable {
    /**
     Vectorize CATransform3D.
     
     - returns: IPValue
     */
    public func vectorize() -> IPValue {
        return IPValue(type: .CATransform3D, vectors: [m11, m12, m13, m14, m21, m22, m23, m24, m31, m32, m33, m34, m41, m42, m43, m44])
    }
}

/// CGAffineTransform Interpolatable extension.
extension CGAffineTransform: Interpolatable {
    /**
     Vectorize CGAffineTransform.
     
     - returns: IPValue
     */
    public func vectorize() -> IPValue {
        return IPValue(type: .CGAffineTransform, vectors: [a, b, c, d, tx, ty])
    }
}

/// CGFloat Interpolatable extension.
extension CGFloat: Interpolatable {
    /**
     Vectorize CGFloat.
     
     - returns: IPValue
     */
    public func vectorize() -> IPValue {
        return IPValue(type: .CGFloat, vectors: [self])
    }
}

/// CGPoint Interpolatable extension.
extension CGPoint: Interpolatable {
    /**
     Vectorize CGPoint.
     
     - returns: IPValue
     */
    public func vectorize() -> IPValue {
        return IPValue(type: .CGPoint, vectors: [x, y])
    }
}

/// CGRect Interpolatable extension.
extension CGRect: Interpolatable {
    /**
     Vectorize CGRect.
     
     - returns: IPValue
     */
    public func vectorize() -> IPValue {
        return IPValue(type: .CGRect, vectors: [origin.x, origin.y, size.width, size.height])
    }
}

/// CGSize Interpolatable extension.
extension CGSize: Interpolatable {
    /**
     Vectorize CGSize.
     
     - returns: IPValue
     */
    public func vectorize() -> IPValue {
        return IPValue(type: .CGSize, vectors: [width, height])
    }
}

/// Double Interpolatable extension.
extension Double: Interpolatable {
    /**
     Vectorize Double.
     
     - returns: IPValue
     */
    public func vectorize() -> IPValue {
        return IPValue(type: .Double, vectors: [CGFloat(self)])
    }
}

/// Int Interpolatable extension.
extension Int: Interpolatable {
    /**
     Vectorize Int.
     
     - returns: IPValue
     */
    public func vectorize() -> IPValue {
        return IPValue(type: .Int, vectors: [CGFloat(self)])
    }
}

/// NSNumber Interpolatable extension.
extension NSNumber: Interpolatable {
    /**
     Vectorize NSNumber.
     
     - returns: IPValue
     */
    public func vectorize() -> IPValue {
        return IPValue(type: .NSNumber, vectors: [CGFloat(self)])
    }
}

/// UIColor Interpolatable extension.
extension UIColor: Interpolatable {
    /**
     Vectorize UIColor.
     
     - returns: IPValue
     */
    public func vectorize() -> IPValue {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        
        if getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return IPValue(type: .ColorRGB, vectors: [red, green, blue, alpha])
        }
        
        var white: CGFloat = 0
        
        if getWhite(&white, alpha: &alpha) {
            return IPValue(type: .ColorMonochrome, vectors: [white, alpha])
        }
        
        var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0
        
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        return IPValue(type: .ColorHSB, vectors: [hue, saturation, brightness, alpha])
    }
}

/// UIEdgeInsets Interpolatable extension.
extension UIEdgeInsets: Interpolatable {
    /**
     Vectorize UIEdgeInsets.
     
     - returns: IPValue
     */
    public func vectorize() -> IPValue {
        return IPValue(type: .UIEdgeInsets, vectors: [top, left, bottom, right])
    }
}

/// IPValue class. Contains a vectorized version of an Interpolatable type.
public class IPValue {
    
    let type: InterpolatableType
    var vectors: [CGFloat]
    
    init(value: IPValue) {
        self.vectors = value.vectors
        self.type = value.type
    }
    
    init (type: InterpolatableType, vectors: [CGFloat]) {
        self.vectors = vectors
        self.type = type
    }
    
    func toInterpolatable() -> Interpolatable {
        switch type {
            case .CATransform3D:
                return CATransform3D(m11: vectors[0], m12: vectors[1], m13: vectors[2], m14: vectors[3], m21: vectors[4], m22: vectors[5], m23: vectors[6], m24: vectors[7], m31: vectors[8], m32: vectors[9], m33: vectors[10], m34: vectors[11], m41: vectors[12], m42: vectors[13], m43: vectors[14], m44: vectors[15])
            case .CGAffineTransform:
                return CGAffineTransform(a: vectors[0], b: vectors[1], c: vectors[2], d: vectors[3], tx: vectors[4], ty: vectors[5])
            case .CGFloat:
                return vectors[0]
            case .CGPoint:
                return CGPoint(x: vectors[0], y: vectors[1])
            case .CGRect:
                return CGRect(x: vectors[0], y: vectors[1], width: vectors[2], height: vectors[3])
            case .CGSize:
                return CGSize(width: vectors[0], height: vectors[1])
            case .ColorRGB:
                return UIColor(red: vectors[0], green: vectors[1], blue: vectors[2], alpha: vectors[3])
            case .ColorMonochrome:
                return UIColor(white: vectors[0], alpha: vectors[1])
            case .ColorHSB:
                return UIColor(hue: vectors[0], saturation: vectors[1], brightness: vectors[2], alpha: vectors[3])
            case .Double:
                return vectors[0]
            case .Int:
                return vectors[0]
            case .NSNumber:
                return vectors[0]
            case .UIEdgeInsets:
                return UIEdgeInsetsMake(vectors[0], vectors[1], vectors[2], vectors[3])
        }
    }
    
}


