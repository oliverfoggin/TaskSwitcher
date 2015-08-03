//
//  GridView.swift
//  TaskSwitcher
//
//  Created by Oliver Foggin on 03/08/2015.
//  Copyright © 2015 Oliver James Foggin. All rights reserved.
//

import Cocoa

class CellView: NSView {
    
    let selectedColor: NSColor = {
        return NSColor(red: 7/255, green: 66/255, blue: 14/255, alpha: 0.9)
    }()
    
    let unselectedColor: NSColor = {
        return NSColor(white: 0.0, alpha: 0.9)
    }()
    
    let highlightLayer: CALayer = {
        let layer = CALayer()
        layer.cornerRadius = 6
        return layer
    }()
    
    let iconView: NSImageView = {
        let view = NSImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.imageScaling = .ScaleProportionallyUpOrDown
        view.addConstraint(NSLayoutConstraint(item: view,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: view,
            attribute: .Height,
            multiplier: 1.0,
            constant: 0))
        return view
    }()
    
    let appNameLabel: NSTextField = {
        let label = NSTextField()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFontOfSize(17)
        label.textColor = .whiteColor()
        label.editable = false
        label.selectable = false
        label.backgroundColor = .clearColor()
        label.drawsBackground = true
        label.bordered = false
        label.setContentCompressionResistancePriority(1000, forOrientation: .Vertical)
        label.setContentHuggingPriority(1000, forOrientation: .Vertical)
        return label
    }()
    
    let mainStackView: NSStackView = {
        let stack = NSStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.orientation = .Vertical
        stack.edgeInsets = NSEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        stack.spacing = 5
        if #available(OSX 10.11, *) {
            stack.distribution = .Fill
        }
        return stack
    }()
    
    
    let labelStackView: NSStackView = {
        let stack = NSStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.orientation = .Horizontal
        stack.alignment = .CenterY
        stack.spacing = 4
        if #available(OSX 10.11, *) {
            stack.distribution = .GravityAreas
        }
        return stack
    }()
    
    var selected: Bool = false {
        didSet {
            if selected {
                highlightLayer.backgroundColor = selectedColor.CGColor
            } else {
                highlightLayer.backgroundColor = unselectedColor.CGColor
            }
        }
    }
    
    func setupConstraints() {
        let views = ["stackView": mainStackView]
        
        self.addConstraint(NSLayoutConstraint(item: labelStackView,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: appNameLabel,
            attribute: .Height,
            multiplier: 1.0,
            constant: 0.0))
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[stackView]|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: views))
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[stackView]|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: views))
    }
    
    override func layout() {
        super.layout()
        highlightLayer.frame = CGRectInset(bounds, 5, 5)
    }
}
