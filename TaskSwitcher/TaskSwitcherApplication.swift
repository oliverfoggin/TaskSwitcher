//
//  TaskSwitcherApplication.swift
//  TaskSwitcher
//
//  Created by Oliver James Foggin on 31/07/2015.
//  Copyright © 2015 Oliver James Foggin. All rights reserved.
//

import Cocoa

enum KeyEvent {
    case Up, Down, Left, Right, Launch
}

protocol KeyListener {
    func keyEventTriggered(keyEvent: KeyEvent)
}

class TaskSwitcherApplication: NSApplication {
    
    var appSwitcherViewController: AppSwitcherViewController = AppSwitcherViewController()
    
    lazy var keyListeners: [KeyListener] = {
        return [self, self.appSwitcherViewController]
    }()
    
    lazy var window: NSWindow = {
        let storyboard = NSStoryboard(name: "AppSwitcherStoryboard", bundle: NSBundle.mainBundle())
        
        guard let controller = storyboard.instantiateInitialController() as? NSWindowController,
            window = controller.window,
            vC = window.contentViewController as? AppSwitcherViewController else { return NSWindow() }
        
        window.backgroundColor = NSColor.clearColor()
        
        self.appSwitcherViewController = vC
        
        return window
    }()
    
    override func sendEvent(event: NSEvent) {
        if event.type == NSEventType.FlagsChanged {
            
            let optionKeyDown = event.modifierFlags.rawValue & NSEventModifierFlags.AlternateKeyMask.rawValue != 0
            let commandKeyDown = event.modifierFlags.rawValue & NSEventModifierFlags.CommandKeyMask.rawValue != 0
            let controlKeyDown = event.modifierFlags.rawValue & NSEventModifierFlags.ControlKeyMask.rawValue != 0
            
            if !optionKeyDown && !commandKeyDown && !controlKeyDown {
                // launch app
                triggerKeyListeners(.Launch)
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
        
        var keyEvent: KeyEvent?
        
        switch key.identifier {
        case "LeftKey":
            keyEvent = .Left
        case "RightKey":
            keyEvent = .Right
        case "UpKey":
            keyEvent = .Up
        case "DownKey":
            keyEvent = .Down
        default:
            print("Not handled here")
        }
        
        if let event = keyEvent {
            triggerKeyListeners(event)
        }
    }
    
    func triggerKeyListeners(keyEvent: KeyEvent) {
        for listener in keyListeners {
            listener.keyEventTriggered(keyEvent)
        }
    }
}

extension TaskSwitcherApplication: KeyListener {
    func keyEventTriggered(keyEvent: KeyEvent) {
        if keyEvent == .Launch {
            if let a = appSwitcherViewController.applicationManager.selectedApplication {
                launchApplication(a)
            }
            appSwitcherViewController.applicationManager.selectedApplication = nil
            appSwitcherViewController.resetViews()
            window.orderOut(nil)
        }
    }
    
    func launchApplication(application: Application) {
        application.launch()
    }
}
