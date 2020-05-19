//  Based on:
//
//  RBBSpringAnimation.h
//  RBBAnimation
//
//  Created by Robert Böhnke on 10/14/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//
//
//  RBBSpringAnimation.swift
//
//  Swift intepretation of the Objective-C original by Marin Todorov
//  Copyright (c) 2015 Underplot ltd. All rights reserved.
//
//
//  SpringInterpolation.swift
//  Interpolate
//
//  Created by Roy Marmelstein on 30/04/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//
import UIKit

/// Spring interpolation
open class SpringInterpolation: InterpolationFunction {
    
    /// Damping
    open var damping: CGFloat = 10.0
    /// Mass
    open var mass: CGFloat = 1.0
    /// Stiffness
    open var stiffness: CGFloat = 100.0
    /// Velocity
    open var velocity: CGFloat = 0.0
    
    /**
     Initialise Spring interpolation
     
     - returns: a SpringInterpolation object
     */
    public init() {}
    
    /**
     Initialise Spring interpolation with options.
     
     - parameter damping:   Damping.
     - parameter velocity:  Velocity.
     - parameter mass:      Mass.
     - parameter stiffness: Stiffness.
     
     - returns: a SpringInterpolation object
     */
    public init(damping: CGFloat, velocity: CGFloat, mass: CGFloat, stiffness: CGFloat) {
        self.damping = damping
        self.velocity = velocity
        self.mass = mass
        self.stiffness = stiffness
    }
    
    /**
     Apply interpolation function
     
     - parameter progress: Input progress value
     
     - returns: Adjusted progress value with interpolation function.
     */
    open func apply(_ progress: CGFloat) -> CGFloat {
    
        if damping <= 0.0 || stiffness <= 0.0 || mass <= 0.0 {
            fatalError("Incorrect animation values")
        }
    
        let beta = damping / (2 * mass)
        let omega0 = sqrt(stiffness / mass)
        let omega1 = sqrt((omega0 * omega0) - (beta * beta))
        let omega2 = sqrt((beta * beta) - (omega0 * omega0))
    
        let x0: CGFloat = -1
    
        let oscillation: (CGFloat) -> CGFloat
    
        if beta < omega0 {
            // Underdamped
            oscillation = {t in
                let envelope: CGFloat = exp(-beta * t)
    
                let part2: CGFloat = x0 * cos(omega1 * t)
                let part3: CGFloat = ((beta * x0 + self.velocity) / omega1) * sin(omega1 * t)
                return -x0 + envelope * (part2 + part3)
            }
        } else if beta == omega0 {
            // Critically damped
            oscillation = {t in
                let envelope: CGFloat = exp(-beta * t)
                return -x0 + envelope * (x0 + (beta * x0 + self.velocity) * t)
            }
        } else {
            // Overdamped
            oscillation = {t in
                let envelope: CGFloat = exp(-beta * t)
                let part2: CGFloat = x0 * cosh(omega2 * t)
                let part3: CGFloat = ((beta * x0 + self.velocity) / omega2) * sinh(omega2 * t)
                return -x0 + envelope * (part2 + part3)
            }
        }
        
        return oscillation(progress)
    }
}
