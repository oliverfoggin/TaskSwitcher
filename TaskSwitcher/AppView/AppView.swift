//
//  AppView.swift
//  TaskSwitcher
//
//  Created by Oliver James Foggin on 27/07/2015.
//  Copyright © 2015 Oliver James Foggin. All rights reserved.
//

import Cocoa

class AppView: NSView {
    
    let iconView: NSImageView
    let appNameLabel: NSTextField
    
    override init(frame frameRect: NSRect) {
        iconView = NSImageView()
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.imageScaling = NSImageScaling.ScaleProportionallyUpOrDown
        
        appNameLabel = NSTextField()
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        appNameLabel.font = NSFont.boldSystemFontOfSize(17)
        appNameLabel.textColor = NSColor.whiteColor()
        appNameLabel.editable = false
        appNameLabel.selectable = false
        appNameLabel.backgroundColor = NSColor.clearColor()
        appNameLabel.drawsBackground = true
        appNameLabel.bordered = false
        appNameLabel.setContentCompressionResistancePriority(1000, forOrientation: NSLayoutConstraintOrientation.Vertical)
        
        super.init(frame: frameRect)
        
        addSubview(iconView)
        addSubview(appNameLabel)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        let views = ["iconView": iconView, "appNameLabel": appNameLabel]
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-5-[iconView]-[appNameLabel]-5-|",
            options: NSLayoutFormatOptions.AlignAllCenterX,
            metrics: nil,
            views: views))
        
        self.addConstraint(NSLayoutConstraint(item: iconView,
            attribute: NSLayoutAttribute.CenterX,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.CenterX,
            multiplier: 1.0,
            constant: 0.0))
        
        self.addConstraint(NSLayoutConstraint(item: iconView,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: iconView,
            attribute: NSLayoutAttribute.Height,
            multiplier: 1.0,
            constant: 0.0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var selected: Bool = false {
        didSet {
            if selected {
                appNameLabel.textColor = NSColor.redColor()
            } else {
                appNameLabel.textColor = NSColor.whiteColor()
            }
        }
    }
    
    var application:Application? {
        didSet {
            if let a = application {
                self.iconView.image = a.icon()
                self.appNameLabel.stringValue = a.name
            }
        }
    }
}
