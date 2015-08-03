//
//  CloseView.swift
//  TaskSwitcher
//
//  Created by Oliver Foggin on 03/08/2015.
//  Copyright © 2015 Oliver James Foggin. All rights reserved.
//

import Cocoa

class CloseView: CellView {
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        wantsLayer = true
        layer?.insertSublayer(highlightLayer, atIndex: 0)
        
        labelStackView.setViews([appNameLabel], inGravity: .Center)
        
        if #available(OSX 10.11, *) {
            mainStackView.addArrangedSubview(iconView)
            mainStackView.addArrangedSubview(labelStackView)
        } else {
            mainStackView.setViews([iconView, labelStackView], inGravity: .Center)
        }
        
        addSubview(mainStackView)
        
        setupConstraints()
        
        iconView.image = NSImage(named: "Cross")
        appNameLabel.stringValue = "Close"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
