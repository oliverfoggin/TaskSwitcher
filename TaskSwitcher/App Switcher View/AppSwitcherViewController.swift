//
//  AppSwitcherViewController.swift
//  TaskSwitcher
//
//  Created by Oliver James Foggin on 31/07/2015.
//  Copyright © 2015 Oliver James Foggin. All rights reserved.
//

import Cocoa

struct Point {
    var x: Int = 0
    var y: Int = 0

    func pointInDirection(direction: Direction) -> Point {
        var point = Point(x: self.x, y: self.y)
        
        switch direction {
        case .Left:
            point.x -= 1
        case .Right:
            point.x += 1
        case .Up:
            point.y += 1
        case .Down:
            point.y -= 1
        }
        
        return point
    }
}

enum Direction {
    case Up, Down, Left, Right
}

protocol KeyHandler {
    func keyTapped(direction: Direction)
}

protocol ApplicationLauncher {
    func setCurrentApplication(application: Application?)
}

class AppSwitcherViewController: NSViewController, KeyHandler {

    var launcher: ApplicationLauncher?
    
    let applications: [Application] = {
        return [
            Application(name: "Xcode-beta", xPos: 0, yPos: 1),
            Application(name: "Safari", xPos: 0, yPos: -1),
            Application(name: "Terminal", xPos: -1, yPos: 0),
            Application(name: "Sketch", xPos: 1, yPos: 0),
            Application(name: "SourceTree", xPos: 1, yPos: 1),
            Application(name: "TextEdit", xPos: -1, yPos: 1),
            Application(name: "TweetBot", xPos: -1, yPos: -1),
            Application(name: "Calendar", xPos: 1, yPos: -1),
        ]
    }()
    
    var views = [Application: AppView]()
    
    var currentPoint = Point()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        let dimensions = createViews(162, height: 100)
        
        self.view.frame = CGRect(x: 0, y: 0, width: dimensions.width, height: dimensions.height)
    }
    
    func createViews(width: CGFloat, height: CGFloat) -> (width: CGFloat, height: CGFloat) {
        
        let limits = viewLimits()
        
        let widthOffset: CGFloat = CGFloat(-limits.minX) * width
        let heightOffset: CGFloat = CGFloat(-limits.minY) * height
        
        var maxWidth: CGFloat = 0
        var maxHeight: CGFloat = 0
        
        for a in applications {
            let x = CGFloat(a.xPos) * width + widthOffset
            let y = CGFloat(a.yPos) * height + heightOffset
            
            let view = appViewWithApplication(a)
            view.frame = CGRect(x: x, y: y, width: width, height: height)
            
            maxWidth = max(maxWidth, x + width)
            maxHeight = max(maxHeight, y + height)
            
            self.view.addSubview(view)
        }
        
        return (maxWidth, maxHeight)
    }
    
    func viewLimits() -> (minX: Int, maxX: Int, minY: Int, maxY: Int) {
        return applications.reduce((minX: 0, maxX: 0, minY: 0, maxY: 0)) { (input: (minX: Int, maxX: Int, minY: Int, maxY: Int), application) -> (minX: Int, maxX: Int, minY: Int, maxY: Int) in
            
            return (
                minX: min(input.minX, application.xPos),
                maxX: max(input.maxX, application.xPos),
                minY: min(input.minY, application.yPos),
                maxY: max(input.maxY, application.yPos)
            )
        }
    }
    
    func appViewWithApplication(application: Application) -> AppView {
        let view = AppView(frame: CGRectZero)
        view.application = application
        
        views[application] = view
        
        return view
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        currentPoint = Point()
        views.flatMap{
            (application, view) in
            view.updateView()
        }
    }
    
    func keyTapped(direction: Direction) {
        moveInDirection(direction)
    }
    
    func moveInDirection(direction: Direction) {
        let point = currentPoint.pointInDirection(direction)
        
        if point.x == 0 && point.y == 0 {
            currentPoint = Point()
            
            for (_, v) in views {
                v.selected = false
            }
            
            if let l = launcher {
                l.setCurrentApplication(nil)
            }
            return;
        }
        
        if let application = applicationAtPoint(point) {
            currentPoint = point
            
            for (a, v) in views {
                v.selected = a == application
            }
            
            if let l = launcher {
                l.setCurrentApplication(application)
            }
        }
    }
    
    func applicationAtPoint(point: Point) -> Application? {
        return applications.filter{$0.xPos == point.x && $0.yPos == point.y}.first
    }
}
