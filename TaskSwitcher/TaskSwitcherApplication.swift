//
//  TaskSwitcherApplication.swift
//  TaskSwitcher
//
//  Created by Oliver James Foggin on 31/07/2015.
//  Copyright © 2015 Oliver James Foggin. All rights reserved.
//

import Cocoa

class TaskSwitcherApplication: NSApplication {
    
    var selectedApplication: Application?
    var appSwitcherViewController: AppSwitcherViewController = AppSwitcherViewController()
    
    lazy var window: NSWindow = {
        let storyboard = NSStoryboard(name: "AppSwitcherStoryboard", bundle: NSBundle.mainBundle())
        
        guard let controller = storyboard.instantiateInitialController() as? NSWindowController,
            window = controller.window,
            vC = window.contentViewController as? AppSwitcherViewController else { return NSWindow() }
        
        window.backgroundColor = NSColor.clearColor()
        
        self.appSwitcherViewController = vC
        vC.launcher = self
        
        return window
    }()
    
    override func sendEvent(event: NSEvent) {
        if event.type == NSEventType.FlagsChanged {
            
            let optionKeyDown = event.modifierFlags.rawValue & NSEventModifierFlags.AlternateKeyMask.rawValue != 0
            let commandKeyDown = event.modifierFlags.rawValue & NSEventModifierFlags.CommandKeyMask.rawValue != 0
            let controlKeyDown = event.modifierFlags.rawValue & NSEventModifierFlags.ControlKeyMask.rawValue != 0
            
            if !optionKeyDown && !commandKeyDown && !controlKeyDown {
                // launch app
                launchApplication(selectedApplication)
                selectedApplication = nil
                window.orderOut(nil)
            }
        }
        super.sendEvent(event)
    }
    
    func showAppBrowserWindow() {
        window.center()
        window.makeKeyAndOrderFront(nil)
    }
    
    func tapped(key: SGHotKey) {
        activateIgnoringOtherApps(true)
        showAppBrowserWindow()
        
        switch key.identifier {
        case "LeftKey":
            appSwitcherViewController.keyTapped(Direction.Left)
        case "RightKey":
            appSwitcherViewController.keyTapped(Direction.Right)
        case "UpKey":
            appSwitcherViewController.keyTapped(Direction.Up)
        case "DownKey":
            appSwitcherViewController.keyTapped(Direction.Down)
        default:
            assert(false, "Unknown key")
        }
    }
}

extension TaskSwitcherApplication: ApplicationLauncher {
    func setCurrentApplication(application: Application?) {
        selectedApplication = application
    }
    
    func launchApplication(application: Application?) {
        guard let a = application else {return}
        
        a.launch()
    }
}