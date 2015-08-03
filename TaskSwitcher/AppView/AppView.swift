//
//  AppView.swift
//  TaskSwitcher
//
//  Created by Oliver James Foggin on 27/07/2015.
//  Copyright © 2015 Oliver James Foggin. All rights reserved.
//

import Cocoa

class AppView: GridView {
    
    let appRunningImageView: NSImageView = {
        let view = NSImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = NSImage(named: "Dot")
        return view
    }()
    
    var application:Application? {
        didSet {
            updateView()
        }
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        wantsLayer = true
        layer?.insertSublayer(highlightLayer, atIndex: 0)
        
        labelStackView.setViews([appRunningImageView, appNameLabel], inGravity: .Center)
        
        if #available(OSX 10.11, *) {
            mainStackView.addArrangedSubview(iconView)
            mainStackView.addArrangedSubview(labelStackView)
        } else {
            mainStackView.setViews([iconView, labelStackView], inGravity: .Center)
        }
        
        addSubview(mainStackView)
        
        appRunningImageView.hidden = true
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateView() {
        if let a = application {
            self.iconView.image = a.icon
            self.appNameLabel.stringValue = a.name
            appRunningImageView.hidden = !a.isRunning
        }
    }
}
