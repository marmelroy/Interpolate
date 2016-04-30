//
//  ViewController.swift
//  Sample
//
//  Created by Roy Marmelstein on 10/04/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import UIKit
import Interpolate

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let squareView = UIView()
        squareView.backgroundColor = UIColor.greenColor()
        self.view.addSubview(squareView)
        squareView.frame.size = CGSizeMake(100, 100)
        squareView.center = self.view.center
        let positionChange = Interpolate(from: self.view.center, to: CGPointMake(50, 50), apply: { (result) in
            if let center = result as? CGPoint {
                squareView.center = center
            }
        }, function: SpringInterpolation(damping: 10.0, velocity: 0.0, mass: 1.0, stiffness: 100.0))
        positionChange.animate(1.0)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

