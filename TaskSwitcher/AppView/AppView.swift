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
        label.font = NSFont.boldSystemFontOfSize(17)
        label.textColor = NSColor.whiteColor()
        label.editable = false
        label.selectable = false
        label.backgroundColor = NSColor.clearColor()
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
        } else {
            // Fallback on earlier versions
        }
        return stack
    }()
    
    let appRunningImageView: NSImageView = {
        let view = NSImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = NSImage(named: "Dot")
        view.addConstraint(NSLayoutConstraint(item: view,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: nil,
            attribute: .NotAnAttribute,
            multiplier: 1.0,
            constant: 10))
        view.addConstraint(NSLayoutConstraint(item: view,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: view,
            attribute: .Height,
            multiplier: 1.0,
            constant: 0))
        return view
    }()
    
    let labelStackView: NSStackView = {
        let stack = NSStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.orientation = .Horizontal
        return stack
    }()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        labelStackView.setViews([appRunningImageView, appNameLabel], inGravity: .Center)
        mainStackView.setViews([iconView, labelStackView], inGravity: .Center)
        addSubview(mainStackView)
        
        appRunningImageView.hidden = true
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    func updateView() {
        if let a = application {
            self.iconView.image = a.icon()
            self.appNameLabel.stringValue = a.name
            appRunningImageView.hidden = !a.isRunning()
        }
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
            updateView()
        }
    }
}
