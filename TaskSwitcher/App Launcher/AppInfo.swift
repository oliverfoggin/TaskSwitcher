//
//  File.swift
//  TaskSwitcher
//
//  Created by Oliver James Foggin on 31/07/2015.
//  Copyright © 2015 Oliver James Foggin. All rights reserved.
//

import Foundation

struct Application {
    let name: String
    let xPos: Int
    let yPos: Int
    
    func launch() {
        NSWorkspace.sharedWorkspace().launchApplication(self.name)
    }
    
    func filePath() -> String? {
        return NSWorkspace.sharedWorkspace().fullPathForApplication(self.name)
    }
    
    func icon() -> NSImage {
        guard let path = filePath() else {return NSImage(named: "AppIcon")!}
        
        return NSWorkspace.sharedWorkspace().iconForFile(path)
    }
    
    func isRunning() -> Bool {
        return NSWorkspace.sharedWorkspace().runningApplications.filter{
            guard let name = $0.localizedName else {return false}
            
            return name == self.name
        }.count == 1
        
    }
}

extension Application: Hashable, Equatable {
    var hashValue: Int {
        get {
            return self.name.hashValue
        }
    }
}

func ==(lhs: Application, rhs: Application) -> Bool {
    return lhs.name == rhs.name
}