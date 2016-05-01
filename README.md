![Interpolate - Swift interpolation for gesture-driven animations](https://cloud.githubusercontent.com/assets/889949/14937965/8b70c90a-0f16-11e6-972a-0ffa39df3e3d.png)

[![Build Status](https://travis-ci.org/marmelroy/Interpolate.svg?branch=master)](https://travis-ci.org/marmelroy/PeekPop) [![Version](http://img.shields.io/cocoapods/v/Interpolate.svg)](http://cocoapods.org/?q=PeekPop)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

# Interpolate
Interpolate is a Swift interpolation framework for creating interactive gesture-driven animations.

<p align="center"><img src="http://i.giphy.com/l4HobBq7BD6xKKGBi.gif" width="242" height="425"/></p>

## Usage

The main idea at the centre of Interpolate is - all animation is interpolation between values over time.    

To use Interpolate:

Import Interpolate at the top of your Swift file.

```swift
import Interpolate
```

To create an interpolation. Initialise an Interpolate object with a from value, a to value and an application closure. 

```swift
let colorChange = Interpolate(from: UIColor.whiteColor(), to: UIColor.redColor(), apply: { [weak self] (result) in
            if let color = result as? UIColor {
                self?.view.backgroundColor = color
            } })
```



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
