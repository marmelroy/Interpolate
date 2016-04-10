//
//  Interpolatable.swift
//  Interpolate
//
//  Created by Roy Marmelstein on 10/04/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation

public protocol Interpolatable {
    func vectorize() -> IPValue
}

public enum InterpolatableType {
    case CGPoint
    case CGRect
    case Double
    case CGFloat
    case Int
    case NSNumber
    case ColorRGB
    case ColorMonochrome
    case ColorHSB
}

extension CGPoint: Interpolatable {
    public func vectorize() -> IPValue {
        return IPValue(vectors: [self.x, self.y], type: .CGPoint)
    }
}

extension CGRect: Interpolatable {
    public func vectorize() -> IPValue {
        return IPValue(vectors: [self.origin.x, self.origin.y, self.size.width, self.size.height], type: .CGRect)
    }
}

extension NSNumber: Interpolatable {
    public func vectorize() -> IPValue {
        return IPValue(vectors: [CGFloat(self)], type: .NSNumber)
    }
}

extension Int: Interpolatable {
    public func vectorize() -> IPValue {
        return IPValue(vectors: [CGFloat(self)], type: .Int)
    }
}

extension Double: Interpolatable {
    public func vectorize() -> IPValue {
        return IPValue(vectors: [CGFloat(self)], type: .Double)
    }
}

extension CGFloat: Interpolatable {
    public func vectorize() -> IPValue {
        return IPValue(vectors: [self], type: .CGFloat)
    }
}

extension UIColor: Interpolatable {
    public func vectorize() -> IPValue {
        var red: CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0, white: CGFloat = 0.0, hue: CGFloat = 0.0, saturation: CGFloat = 0.0, brightness: CGFloat = 0.0, alpha: CGFloat = 0.0
        let rgbConversion = self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        if rgbConversion {
            return IPValue(vectors: [red, green, blue, alpha], type: .ColorRGB)
        }
        let monochromeConversion = self.getWhite(&white, alpha: &alpha)
        if monochromeConversion {
            return IPValue(vectors: [white, alpha], type: .ColorMonochrome)
        }
        self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
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
                return CGPointMake(vectors[0], vectors[1])
            case .CGRect:
                return CGRectMake(vectors[0], vectors[1], vectors[2], vectors[3])
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
        }
    }
    
}


