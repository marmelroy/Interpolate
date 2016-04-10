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
        let moveIntrepolation = LinearInterpolation(from: 0.0, to: 2.0, duration: 0.3) { (value) in
                print(value)
        }
        moveIntrepolation.run()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

