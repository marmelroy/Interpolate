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

public struct IPValue {
    
    let vectors: [CGFloat]
    let type: InterpolatableType
    
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
        }
    }
    
}


