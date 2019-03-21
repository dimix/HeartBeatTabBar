//
//  HeartBeatTabBar.swift
//  HeartBeat
//
//  Created by Dimitri Giani on 21/03/2019.
//  Copyright © 2019 Dimitri Giani. All rights reserved.
//

import UIKit

class HeartBeatTabBar: UITabBar
{
	private let backgroundLayer = CAGradientLayer()
	private let heartView = HeartBeatLineView()
	private var previousItemFrame: CGRect?
	private var lastSelectedItem: UITabBarItem?
	private var itemsCount: Int {
		return itemViews.count
	}
	private var barItemWidth: CGFloat {
		return frame.size.width / CGFloat(itemsCount)
	}
	private var itemViews: [UIView] {
		return subviews.filter { String(describing: type(of: $0)) == "UITabBarButton" }
	}
	override var items: [UITabBarItem]? {
		didSet {
			setupItems()
		}
	}
	
	override var selectedItem: UITabBarItem? {
		willSet {
			if let selectedItem = self.selectedItem, lastSelectedItem != newValue
			{
				lastSelectedItem = newValue
				
				previousItemFrame = frameOfItemIndex(indexOfItem(selectedItem))
				
				if let item = newValue
				{
					animateItemAtIndex(indexOfItem(item))
				}
			}
		}
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		super.init(coder: aDecoder)
		
		setupItems()
	}
	
	override func layoutSubviews()
	{
		super.layoutSubviews()
		
		heartView.frame = CGRect(origin: CGPoint(x: 0, y: frame.size.height-55), size: CGSize(width: frame.size.width, height: 50))
		backgroundLayer.frame = bounds
		
		if let item = selectedItem
		{
			animateItemAtIndex(indexOfItem(item))
		}
	}
	
	private func setupItems()
	{
		var offset: CGFloat = 6.0
		
		if #available(iOS 11.0, *), traitCollection.horizontalSizeClass == .regular {
			offset = 0.0
		}
		
		items?.forEach {
			$0.title = ""
			$0.imageInsets = UIEdgeInsets(top: offset, left: 0, bottom: -offset, right: 0);
			$0.image = $0.image?.withRenderingMode(.alwaysOriginal)
		}
		
		insertSubview(heartView, at: 0)
		heartView.translatesAutoresizingMaskIntoConstraints = false
		heartView.verticalRatio = 0.5
		backgroundLayer.colors = [UIColor(red: 0.98, green: 0.44, blue: 0.59, alpha: 1).cgColor, UIColor(red: 0.92, green: 0.25, blue: 0.43, alpha: 1).cgColor]
		
		tintColor = .white
		
		layer.insertSublayer(backgroundLayer, at: 0)
	}
	
	private func indexOfItem(_ item: UITabBarItem) -> Int
	{
		for index in 0..<itemsCount
		{
			if item == items?[index]
			{
				return index
			}
		}
		
		return 0
	}
	
	private func frameOfItemIndex(_ index: Int) -> CGRect
	{
		let view = itemViews[index]
		return view.frame
	}
	
	private func animateItemAtIndex(_ index: Int)
	{
		let frame = frameOfItemIndex(index)
		
		guard let oldFrame = previousItemFrame else {
			heartView.setDot(at: frame.origin.x + (frame.size.width*0.5))
			return
		}
		
		heartView.animate(from: oldFrame.origin.x + (oldFrame.size.width*0.5), to: frame.origin.x + (frame.size.width*0.5))
	}
}
