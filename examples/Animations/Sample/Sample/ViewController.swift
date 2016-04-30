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

    @IBOutlet weak var animationView: UIView!
    
    var colorChange: Interpolate?
    var radiusChange: Interpolate?
    var sizeChange: Interpolate?

    var animationViewCenter = CGPoint.zero
    
    @IBAction func didPan(sender: AnyObject) {
        let gestureRecognizer = sender as? UIPanGestureRecognizer
        if let translatedPoint = gestureRecognizer?.translationInView(self.view) {
            if gestureRecognizer?.state == .Began {
                animationViewCenter = animationView.center
            }
            animationView.center = CGPointMake(animationViewCenter.x, animationViewCenter.y + translatedPoint.y)
            let progress = animationView.center.y / self.view.frame.size.height
            colorChange?.animate(0.2, targetProgress: progress)
            radiusChange?.progress = progress
            var sizeProgress = animationView.center.y / self.view.center.y
            if sizeProgress > 1 {
                sizeProgress = 2 - sizeProgress
            }
            sizeChange?.progress = sizeProgress
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorChange = Interpolate(from: UIColor.redColor(), to: UIColor.blueColor(), apply: { [weak self] (result) in
            if let color = result as? UIColor {
                self?.animationView.backgroundColor = color
            }
        })
        radiusChange = Interpolate(from: 0.0, to: 20, apply: { [weak self] (result) in
            if let radius = result as? CGFloat {
                self?.animationView.layer.cornerRadius = radius
            }
        })
        sizeChange = Interpolate(from: CGSizeMake(40, 40), to: CGSizeMake(300, 300), apply: { [weak self] (result) in
            if let size = result as? CGSize {
                self?.animationView.frame.size = size
            }
        }, function: BasicInterpolation.EaseIn)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let progress = animationView.center.y / self.view.frame.size.height
        colorChange?.progress = progress
        radiusChange?.progress = progress
        sizeChange?.progress = 1.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

