//
//  AppView.swift
//  TaskSwitcher
//
//  Created by Oliver James Foggin on 27/07/2015.
//  Copyright © 2015 Oliver James Foggin. All rights reserved.
//

import Cocoa

class AppView: NSView {
    
    let iconView: NSImageView = {
        let view = NSImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.imageScaling = NSImageScaling.ScaleProportionallyUpOrDown
        return view
    }()
    
    let appNameLabel: NSTextField = {
        let label = NSTextField()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = NSFont.boldSystemFontOfSize(17)
        label.textColor = NSColor.whiteColor()
        label.editable = false
        label.selectable = false
        label.backgroundColor = NSColor.clearColor()
        label.drawsBackground = true
        label.bordered = false
        label.setContentCompressionResistancePriority(1000, forOrientation: NSLayoutConstraintOrientation.Vertical)
        return label
    }()
    
    let mainStackView: NSStackView = {
        let stack = NSStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.orientation = .Vertical
        stack.spacing = 5
        return stack
    }()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        addSubview(mainStackView)
        
        mainStackView.setViews([iconView, appNameLabel], inGravity: .Top)
        mainStackView.setCustomSpacing(0, afterView: appNameLabel)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        let views = ["stackView": mainStackView]
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[stackView]|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: views))
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[stackView]|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: views))
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
