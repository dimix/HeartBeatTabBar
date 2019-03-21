//
//  HeartBeatLineView.swift
//  HeartBeat
//
//  Created by Dimitri Giani on 21/03/2019.
//  Copyright © 2019 Dimitri Giani. All rights reserved.
//

import UIKit

public class HeartBeatLineView: UIView, CAAnimationDelegate
{
	private let gradientLayer = CAGradientLayer()
	private var shapeLayer: CAShapeLayer?
	private var animationDuration: TimeInterval = 0
	private var isRightDirection = true
	private var finalDestination: CGFloat = 0
	
	public var duration: CGFloat = 0.5
	public var verticalRatio: CGFloat = 1
	public var lineWidth: CGFloat = 6
	
	private func heartBeatPath(from: CGFloat, to: CGFloat) -> UIBezierPath
	{
		let minWidth: CGFloat = 81
		let baseY = frame.size.height*0.5
		var y = baseY
		var x: CGFloat = from
		let totalSpace = to - from
		
		if totalSpace < minWidth
		{
			return UIBezierPath()
		}
		
		x = from + (totalSpace - minWidth) * 0.5
		
		let path = UIBezierPath()
		
		path.move(to: CGPoint(x: from, y: y))
		path.addLine(to: CGPoint(x: x, y: y))
		
		x += 10
		
		path.addLine(to: CGPoint(x: x, y: y))
		
		x += 5
		y = baseY - (5*verticalRatio)
		
		path.addLine(to: CGPoint(x: x, y: y))
		
		x += 8
		y = baseY + (15*verticalRatio)
		
		path.addLine(to: CGPoint(x: x, y: y))
		
		x += 5
		y = baseY
		
		path.addLine(to: CGPoint(x: x, y: y))
		
		x += 5
		y = baseY
		
		path.addLine(to: CGPoint(x: x, y: y))
		
		x += 5
		y = baseY - (30*verticalRatio)
		
		path.addLine(to: CGPoint(x: x, y: y))
		
		x += 8
		y = baseY + (25*verticalRatio)
		
		path.addLine(to: CGPoint(x: x, y: y))
		
		x += 8
		y = baseY - (10*verticalRatio)
		
		path.addLine(to: CGPoint(x: x, y: y))
		
		x += 8
		y = baseY + (3*verticalRatio)
		
		path.addLine(to: CGPoint(x: x, y: y))
		
		x += 4
		y = baseY
		
		path.addLine(to: CGPoint(x: x, y: y))
		
		x += 15
		y = baseY
		
		path.addLine(to: CGPoint(x: x, y: y))
		
		path.addLine(to: CGPoint(x: to, y: y))
		
		return path
	}
	
	public func setDot(at destination: CGFloat)
	{
		if shapeLayer == nil
		{
			shapeLayer = CAShapeLayer()
		}
		
		shapeLayer?.removeAllAnimations()
		
		let point = CGPoint(x: destination-(lineWidth*0.5), y: (frame.size.height-lineWidth)*0.5)
		shapeLayer?.path = UIBezierPath(ovalIn: CGRect(origin: point, size: CGSize(width: lineWidth, height: lineWidth))).cgPath
		shapeLayer?.fillColor = UIColor.white.cgColor
		shapeLayer?.strokeColor = nil
		gradientLayer.removeFromSuperlayer()
		layer.addSublayer(shapeLayer!)
	}
	
	public func animate(from: CGFloat, to: CGFloat)
	{
		let viewWidth = frame.size.width
		
		shapeLayer?.removeFromSuperlayer()
		shapeLayer?.removeAllAnimations()
		gradientLayer.removeFromSuperlayer()
		
		shapeLayer = CAShapeLayer()
		gradientLayer.mask = shapeLayer
		gradientLayer.frame = bounds
		
		isRightDirection = (to - from) > 0
		
		if isRightDirection
		{
			gradientLayer.colors = [UIColor.white.withAlphaComponent(0).cgColor, UIColor.white.cgColor]
			
			gradientLayer.startPoint = CGPoint(x: from/viewWidth, y: 0)
			gradientLayer.endPoint = CGPoint(x: to/viewWidth, y: 0)
		}
		else
		{
			gradientLayer.colors = [UIColor.white.cgColor, UIColor.white.withAlphaComponent(0).cgColor]
			
			gradientLayer.startPoint = CGPoint(x: to/viewWidth, y: 0)
			gradientLayer.endPoint = CGPoint(x: from/viewWidth, y: 0)
		}
		
		let totalSpace = abs(to - from)
		let path = heartBeatPath(from: isRightDirection ? from : to, to: isRightDirection ? to : from).cgPath
		
		finalDestination = to
		animationDuration = TimeInterval((duration / totalSpace) * totalSpace)
		
		shapeLayer?.fillColor = nil
		shapeLayer?.strokeColor = UIColor.white.cgColor
		shapeLayer?.lineWidth = lineWidth
		shapeLayer?.path = path
		shapeLayer?.lineCap = .round
		shapeLayer?.lineJoin = .round
		
		layer.addSublayer(gradientLayer)
		
		let startAnimation = CABasicAnimation(keyPath: "strokeStart")
		startAnimation.fromValue = isRightDirection ? 0 : 0.85
		startAnimation.toValue = isRightDirection ? 0.85 : 0
		startAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
		
		let endAnimation = CABasicAnimation(keyPath: "strokeEnd")
		endAnimation.fromValue = isRightDirection ? 0.08 : 1
		endAnimation.toValue = isRightDirection ? 1 : 0.08
		endAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
		
		let animation = CAAnimationGroup()
		animation.animations = [startAnimation, endAnimation]
		animation.duration = animationDuration
		animation.delegate = self
		animation.isRemovedOnCompletion = true
		shapeLayer?.add(animation, forKey: "AnimationStart")
		
		//	Prevent drawings
		shapeLayer?.strokeEnd = 0
		
		//	Disable interactions
		isUserInteractionEnabled = false
	}
	
	public func animationDidStop(_ anim: CAAnimation, finished flag: Bool)
	{
		setDot(at: finalDestination)
		isUserInteractionEnabled = true
	}
}
