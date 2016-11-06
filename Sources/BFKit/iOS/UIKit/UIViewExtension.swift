//
//  UIViewExtension.swift
//  BFKit
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015 - 2016 Fabrizio Brancati. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation
import UIKit
import QuartzCore

// MARK: - UIView extension

/// This extesion adds some useful functions to UIView.
public extension UIView {
    // MARK: - Variables
    
    /// Direction of flip animation.
    ///
    /// - top: Flip animation from top.
    /// - left: Flip animation from left.
    /// - right: Flip animation from right.
    /// - bottom: Flip animation from bottom.
    public enum UIViewAnimationFlipDirection: Int {
        case top
        case left
        case right
        case bottom
    }
    
    /// Direction of the translation.
    ///
    /// - leftToRight: Translation from left to right.
    /// - rightToLeft: Translation from right to left.
    public enum UIViewAnimationTranslationDirection: Int {
        case leftToRight
        case rightToLeft
    }
    
    /// Direction of the linear gradient
    ///
    /// - vertical: Linear gradient vertical
    /// - horizontal: Linear gradient horizontal
    /// - diagonalLeftToRightAndTopToDown: Linear gradient from left to right and top to down
    /// - diagonalLeftToRightAndDownToTop: Linear gradient from left to right and down to top
    /// - diagonalRightToLeftAndTopToDown: Linear gradient from right to left and top to down
    /// - diagonalRightToLeftAndDownToTop: Linear gradient from right to left and down to top
    public enum UIViewLinearGradientDirection {
        case vertical
        case horizontal
        case diagonalLeftToRightAndTopToDown
        case diagonalLeftToRightAndDownToTop
        case diagonalRightToLeftAndTopToDown
        case diagonalRightToLeftAndDownToTop
        case custom(startPoint: CGPoint, endPoint: CGPoint)
    }
    
    // MARK: - Functions
    
    /// Creates a border around the UIView.
    ///
    /// - Parameters:
    ///   - color: Border color.
    ///   - radius: Border radius.
    ///   - width: Border width.
    public func border(color: UIColor, radius: CGFloat, width: CGFloat) {
        self.layer.borderWidth = width
        self.layer.cornerRadius = radius
        self.layer.shouldRasterize = false
        self.layer.rasterizationScale = 2
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        
        let cgColor: CGColor = color.cgColor
        self.layer.borderColor = cgColor
    }
    
    /// Removes border around the UIView.
    public func removeBorder(maskToBounds: Bool = true) {
        self.layer.borderWidth = 0
        self.layer.cornerRadius = 0
        self.layer.borderColor = nil
        self.layer.masksToBounds = maskToBounds
    }
    
    /// Set the corner radius of UIView only at the given corner.
    ///
    /// - Parameters:
    ///   - corners: Corners to apply radius.
    ///   - radius: Radius value.
    public func cornerRadius(corners: UIRectCorner, radius: CGFloat) {
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.frame
        rectShape.position = self.center
        rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius)).cgPath
        self.layer.mask = rectShape
    }
    
    /// Create a shadow on the UIView.
    ///
    /// - Parameters:
    ///   - offset: Shadow offset.
    ///   - opacity: Shadow opacity.
    ///   - radius: Shadow radius.
    ///   - color: Shadow color. Default is black.
    public func shadow(offset: CGSize, opacity: Float, radius: CGFloat, cornerRadius: CGFloat = 0, color: UIColor = UIColor.black) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        if cornerRadius != 0 {
            self.layer.cornerRadius = cornerRadius
            self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
        }
        self.layer.masksToBounds = false
    }
    
    /// Removes shadow around the UIView.
    public func removeShadow(maskToBounds: Bool = true) {
        self.layer.shadowColor = nil
        self.layer.shadowOpacity = 0.0
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 0
        self.layer.cornerRadius = 0
        self.layer.shadowPath = nil
        self.layer.masksToBounds = maskToBounds
    }
    
    /// Create a linear gradient.
    ///
    /// - Parameters:
    ///   - colors: Array of UIColor instances.
    ///   - direction: Direction of the gradient.
    public func gradient(colors: [UIColor], direction: UIViewLinearGradientDirection) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        
        let mutableColors: NSMutableArray = NSMutableArray(array: colors)
        for i in 0 ..< colors.count {
            let currentColor: UIColor = colors[i]
            mutableColors.replaceObject(at: i, with: currentColor.cgColor)
        }
        gradient.colors = mutableColors as AnyObject as! [UIColor]
        
        switch direction {
        case .vertical:
            gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        case .horizontal:
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        case .diagonalLeftToRightAndTopToDown:
            gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        case .diagonalLeftToRightAndDownToTop:
            gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        case .diagonalRightToLeftAndTopToDown:
            gradient.startPoint = CGPoint(x: 1.0, y: 0.0)
            gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        case .diagonalRightToLeftAndDownToTop:
            gradient.startPoint = CGPoint(x: 1.0, y: 1.0)
            gradient.endPoint = CGPoint(x: 0.0, y: 0.0)
        case .custom(let startPoint, let endPoint):
            gradient.startPoint = startPoint
            gradient.endPoint = endPoint
        }
        self.layer.insertSublayer(gradient, at:0)
    }
    
    /// Create a shake effect on the UIView.
    ///
    /// - Parameters:
    ///   - count: Shakes count.
    ///   - duration: Shake duration.
    ///   - translation: Shake translation.
    func shake(count: Float = 2, duration: TimeInterval = 0.5, translation: Float = -5) {
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.repeatCount = count
        animation.duration = (duration) / TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.byValue = translation
        
        self.layer.add(animation, forKey: "shake")
    }
    
    /// Create a pulse effect on th UIView.
    ///
    /// - Parameter duration: Seconds of animation.
    public func pulse(count: Float, duration: TimeInterval = 1) {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.autoreverses = true
        animation.repeatCount = count
        
        self.layer.add(animation, forKey: "pulse")
    }
    
    /// Create a heartbeat effect on the UIView.
    ///
    /// - Parameters:
    ///   - count: Seconds of animation.
    ///   - maxSize: Maximum size of the object to animate.
    ///   - durationPerBeat: Duration per beat.
    public func heartbeat(count: Float = 1, maxSize: CGFloat = 1.4, durationPerBeat: CGFloat = 0.5) {
        let animation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform")
        
        let scale1: CATransform3D = CATransform3DMakeScale(0.8, 0.8, 1)
        let scale2: CATransform3D = CATransform3DMakeScale(maxSize, maxSize, 1)
        let scale3: CATransform3D = CATransform3DMakeScale(maxSize - 0.3, maxSize - 0.3, 1)
        let scale4: CATransform3D = CATransform3DMakeScale(1.0, 1.0, 1)
        
        let frameValues = [NSValue(caTransform3D: scale1), NSValue(caTransform3D: scale2), NSValue(caTransform3D: scale3), NSValue(caTransform3D: scale4)]
        
        animation.values = frameValues
        
        let frameTimes = [NSNumber(value: 0.05), NSNumber(value: 0.2), NSNumber(value: 0.6), NSNumber(value: 1.0)]
        animation.keyTimes = frameTimes
        
        animation.fillMode = kCAFillModeForwards
        animation.duration = TimeInterval(durationPerBeat)
        animation.repeatCount = count / Float(durationPerBeat)
        
        self.layer.add(animation, forKey: "heartbeat")
    }
    
    /// Adds a motion effect to the view.
    public func applyMotionEffects() {
        let horizontalEffect: UIInterpolatingMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontalEffect.minimumRelativeValue = -10.0
        horizontalEffect.maximumRelativeValue = 10.0
        let verticalEffect: UIInterpolatingMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        verticalEffect.minimumRelativeValue = -10.0
        verticalEffect.maximumRelativeValue = 10.0
        let motionEffectGroup: UIMotionEffectGroup = UIMotionEffectGroup()
        motionEffectGroup.motionEffects = [horizontalEffect, verticalEffect]
        
        self.addMotionEffect(motionEffectGroup)
    }
    
    /// Flip the view.
    ///
    /// - Parameters:
    ///   - duration: Seconds of animation.
    ///   - direction: Direction of the flip animation.
    public func flip(duration: TimeInterval, direction: UIViewAnimationFlipDirection) {
        var subtype: String = ""
        
        switch direction {
        case .top:
            subtype = "fromTop"
        case .left:
            subtype = "fromLeft"
        case .bottom:
            subtype = "fromBottom"
        case .right:
            subtype = "fromRight"
        }
        
        let transition: CATransition = CATransition()
        transition.startProgress = 0
        transition.endProgress = 1.0
        transition.type = "flip"
        transition.subtype = subtype
        transition.duration = duration
        transition.repeatCount = 1
        transition.autoreverses = true
        
        self.layer.add(transition, forKey:"flip")
    }
    
    /// Translate the UIView around the topView.
    ///
    /// - Parameters:
    ///   - topView: Top view to translate to.
    ///   - duration: Duration of the translation.
    ///   - direction: Direction of the translation.
    ///   - repeatAnimation: If the animation must be repeat or no.
    ///   - startFromEdge: If the animation must start from the edge.
    public func translateAround(topView: UIView, duration: CGFloat, direction: UIViewAnimationTranslationDirection, repeatAnimation: Bool = true, startFromEdge: Bool = true) {
        var startPosition: CGFloat = self.center.x, endPosition: CGFloat
        switch direction {
        case .leftToRight:
            startPosition = self.frame.size.width / 2
            endPosition = -(self.frame.size.width / 2) + topView.frame.size.width
        case .rightToLeft:
            startPosition = -(self.frame.size.width / 2) + topView.frame.size.width
            endPosition = self.frame.size.width / 2
        }
        
        if startFromEdge {
            self.center = CGPoint(x: startPosition, y: self.center.y)
        }
        
        UIView.animate(withDuration: TimeInterval(duration / 2), delay: 1, options: UIViewAnimationOptions(), animations: { () -> Void in
            self.center = CGPoint(x: endPosition, y: self.center.y)
        }) { (finished: Bool) -> Void in
            if finished {
                UIView.animate(withDuration: TimeInterval(duration / 2), delay: 1, options: UIViewAnimationOptions(), animations: { () -> Void in
                    self.center = CGPoint(x: startPosition, y: self.center.y)
                }) { (finished: Bool) -> Void in
                    if finished {
                        if repeatAnimation {
                            self.translateAround(topView: topView, duration: duration, direction: direction, repeatAnimation: repeatAnimation, startFromEdge: startFromEdge)
                        }
                    }
                }
            }
        }
    }
    
    /// Take a screenshot of the current view
    ///
    /// - Parameter save: Save the screenshot in user pictures. Default is false.
    /// - Returns: Returns screenshot as UIImage
    public func screenshot(save: Bool = false) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let imageData: Data = UIImagePNGRepresentation(image)!
        image = UIImage(data: imageData)!
        
        if save {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        
        return image
    }
    
    /// Removes all subviews from current view
    public func removeAllSubviews() {
        self.subviews.forEach { (subview) -> () in
            subview.removeFromSuperview()
        }
    }
    
    /// Create an UIView with the given frame and background color.
    ///
    /// - Parameters:
    ///   - frame: UIView frame.
    ///   - backgroundColor: UIView background color.
    public convenience init(frame: CGRect, backgroundColor: UIColor) {
        self.init(frame: frame)
        self.backgroundColor = backgroundColor
    }
}


// MARK: - UIView inspectable extension

/// Extends UIView with inspectable variables.
extension UIView {
    // MARK: - Variables
    
    /// Inspectable border size.
    @IBInspectable public var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    /// Inspectable border color.
    @IBInspectable public var borderColor: UIColor {
        get {
            guard let borderColor = self.layer.borderColor else {
                return UIColor(red: 0, green: 0, blue: 0, alpha: 0)
            }
            return UIColor(cgColor: borderColor)
        }
        set {
            self.layer.borderColor = newValue.cgColor
        }
    }
    
    
    /// Inspectable mask to bounds.
    ///
    /// Set it to true if you want to enable corner radius.
    ///
    /// Set it to false if you want to enable shadow.
    @IBInspectable public var maskToBounds: Bool {
        get {
            return self.layer.masksToBounds
        }
        set {
            self.layer.masksToBounds = newValue
        }
    }
    
    /// Inspectable corners size.
    ///
    /// Remeber to set maskToBounds to true.
    @IBInspectable public var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
    
    /// Inspectable shadow color.
    ///
    /// Remeber to set maskToBounds to false.
    @IBInspectable public var shadowColor: UIColor {
        get {
            guard let shadowColor = self.layer.shadowColor else {
                return UIColor(red: 0, green: 0, blue: 0, alpha: 0)
            }
            return UIColor(cgColor: shadowColor)
        }
        set {
            self.layer.shadowColor = newValue.cgColor
        }
    }
    
    /// Inspectable shadow opacity.
    ///
    /// Remeber to set maskToBounds to false.
    @IBInspectable public var shadowOpacity: Float {
        get {
            return self.layer.shadowOpacity
        }
        set {
            self.layer.shadowOpacity = newValue
        }
    }
    
    /// Inspectable shadow offset X.
    ///
    /// Remeber to set maskToBounds to false.
    @IBInspectable public var shadowOffsetX: CGFloat {
        get {
            return self.layer.shadowOffset.width
        }
        set {
            self.layer.shadowOffset = CGSize(width: self.shadowOffsetX, height: self.layer.shadowOffset.height)
        }
    }
    
    /// Inspectable shadow offset Y.
    ///
    /// Remeber to set maskToBounds to false.
    @IBInspectable public var shadowOffsetY: CGFloat {
        get {
            return self.layer.shadowOffset.height
        }
        set {
            self.layer.shadowOffset = CGSize(width: self.layer.shadowOffset.width, height: self.shadowOffsetY)
        }
    }
    
    /// Inspectable shadow radius.
    ///
    /// Remeber to set maskToBounds to false.
    @IBInspectable public var shadowRadius: CGFloat {
        get {
            return self.layer.shadowRadius
        }
        set {
            self.layer.shadowRadius = newValue
        }
    }
}
