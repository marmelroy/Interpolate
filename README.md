![Interpolate - Swift interpolation for gesture-driven animations](https://cloud.githubusercontent.com/assets/889949/14937965/8b70c90a-0f16-11e6-972a-0ffa39df3e3d.png)

[![Build Status](https://travis-ci.org/marmelroy/Interpolate.svg?branch=master)](https://travis-ci.org/marmelroy/PeekPop) [![Version](http://img.shields.io/cocoapods/v/Interpolate.svg)](http://cocoapods.org/?q=PeekPop)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

# Interpolate
Interpolate is a powerful Swift interpolation framework for creating interactive gesture-driven animations.

<p align="center"><img src="http://i.giphy.com/26FxolLz3AR1oz61y.gif" width="242" height="425"/></p>

## Usage

The :key: idea  of Interpolate is -
**all animation is the interpolation of values over time.**    

To use Interpolate:

Import Interpolate at the top of your Swift file.

```swift
import Interpolate
```

Create an Interpolate object with a from value, a to value and an apply closure that applies the interpolation's result to the target object.

```swift
let colorChange = Interpolate(from: UIColor.whiteColor(),
  to: UIColor.redColor(),
  apply: { [weak self] (result) in
      if let color = result as? UIColor {
        self?.view.backgroundColor = color
      }
})
```

Next, you will need to define a way to translate your chosen gesture's progress to a percentage value (i.e. a CGFloat between 0.0 and 1.0).

For a gesture recognizer or delegate that reports every step of its progress (e.g. UIPanGestureRecognizer or a ScrollViewDidScroll) you can just apply the percentage directly to the Interpolate object:
```swift
@IBAction func handlePan(recognizer: UIPanGestureRecognizer) {
    let translation = recognizer.translationInView(self.view)
    let translatedCenterY = view.center.y + translation.y
    let progress = translatedCenterY / self.view.bounds.size.height
    colorChange.progress = progress
}
```

For other types of gesture recognizers that only report a beginning and an end (e.g. a UILongPressGestureRecognizer), you can animate directly to a target progress value with a given duration. For example:
```swift
@IBAction func handleLongPress(recognizer: UILongPressGestureRecognizer) {
    switch recognizer.state {
        case .Began:
            colorChange.animate(1.0, targetProgress: 1.0)
        case .Cancelled, .Ended, .Failed:
            colorChange.animate(0.3, targetProgress: 0.0)
        default: break
    }
}
```

To stop an animation:
```swift
colorChange.stopAnimation()
```

When you are done with the interpolation altogether:
```swift
colorChange.invalidate()
```

Voila!

## What can I interpolate?

Interpolate currently supports the interpolation of:
- CGPoint
- CGRect
- CGSize
- Double
- CGFloat
- Int
- NSNumber
- UIColor
- CGAffineTransform
- CATransform3D

More types will be added over time.

## Advanced usage

Interpolate is not just for dull linear interpolations.

For smoother animations, consider using any of the following functions: **EaseIn, EaseOut, EaseInOut and Spring.**

```swift
// Spring interpolation
let shadowPosition = Interpolate(from: -shadowView.frame.size.width,
  to: (self.view.bounds.size.width - shadowView.frame.size.width)/2,
  function: SpringInterpolation(damping: 30.0, velocity: 0.0, mass: 1.0, stiffness: 100.0),
  apply: { [weak self] (result) in
    if let originX = result as? CGFloat {
        self?.shadowView.frame.origin.x = originX
    }
})

// Ease out interpolation
let groundPosition = Interpolate(from: CGPointMake(0, self.view.bounds.size.height),
  to: CGPointMake(0, self.view.bounds.size.height - 150),
  function: BasicInterpolation.EaseOut,
  apply: { [weak self] (result) in
      if let origin = result as? CGPoint {
          self?.groundView.frame.origin = origin
      }
})
```

In fact, you can easily create and use your own interpolation function - all you need is an object that conforms to the InterpolationFunction protocol.

### Setting up with [CocoaPods](http://cocoapods.org/?q=Interpolate)
```ruby
source 'https://github.com/CocoaPods/Specs.git'
pod 'Interpolate', '~> 0.1'
```

### Setting up with Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate Interpolate into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "marmelroy/Interpolate"
```

### Inspiration
- [https://github.com/icanzilb/EasyAnimation](https://github.com/icanzilb/EasyAnimation)
- [https://github.com/robb/RBBAnimation](https://github.com/robb/RBBAnimation)
- [https://github.com/facebook/pop](https://github.com/facebook/pop)
