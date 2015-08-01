//
//  AppDelegate.swift
//  TaskSwitcher
//
//  Created by Oliver James Foggin on 27/07/2015.
//  Copyright © 2015 Oliver James Foggin. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var menu: NSMenu!
    
    var statusItem: NSStatusItem = {
        let item = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
        item.highlightMode = true
        if let button = item.button {
            button.image = NSImage(named: "icon")
        }
        return item
    }()
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        registerHotKeys()
        
        statusItem.menu = menu
    }

    func doSomething(thing first: String, times: Int = 1) {
        
    }
    
    func registerHotKeys() {
        guard let tsa = TaskSwitcherApplication.sharedApplication() as? TaskSwitcherApplication else {return}
        
        let hotKeyCenter = SGHotKeyCenter.sharedCenter()
        
        let leftKeyCombo = SGKeyCombo(keyCode: 123, modifiers: optionKey|controlKey|cmdKey)
        let leftKey = SGHotKey(identifier: "LeftKey", keyCombo: leftKeyCombo, target: tsa, action: "tapped:")
        hotKeyCenter.registerHotKey(leftKey)
        
        let rightKeyCombo = SGKeyCombo(keyCode: 124, modifiers: optionKey|controlKey|cmdKey)
        let rightKey = SGHotKey(identifier: "RightKey", keyCombo: rightKeyCombo, target: tsa, action: "tapped:")
        hotKeyCenter.registerHotKey(rightKey)
        
        let upKeyCombo = SGKeyCombo(keyCode: 126, modifiers: optionKey|controlKey|cmdKey)
        let upKey = SGHotKey(identifier: "UpKey", keyCombo: upKeyCombo, target: tsa, action: "tapped:")
        hotKeyCenter.registerHotKey(upKey)
        
        let downKeyCombo = SGKeyCombo(keyCode: 125, modifiers: optionKey|controlKey|cmdKey)
        let downKey = SGHotKey(identifier: "DownKey", keyCombo: downKeyCombo, target: tsa, action: "tapped:")
        hotKeyCenter.registerHotKey(downKey)
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
}

