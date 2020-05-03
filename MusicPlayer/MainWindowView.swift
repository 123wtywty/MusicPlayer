//
//  MainWindowView.swift
//  MusicPlayer
//
//  Created by Gary Wu on 2020-04-30.
//  Copyright © 2020 Gary Wu. All rights reserved.
//

import Foundation
import Cocoa
import SwiftUI

class MainWindowViewWindowController: NSWindowController, NSWindowDelegate, AutoCloseWindow {
    
    static var shared = MainWindowViewWindowController()
    var defaultSize : NSRect?
    
    private convenience init() {
        
        let window = NSWindow(contentViewController: NSHostingController(rootView: ContentView()))
        
        
        window.setContentSize(NSSize(width:640, height: 493))
        
        window.title = "MusicMac"
        window.minSize = NSSize(width: 640, height: 480)
        window.contentMinSize = NSSize(width: 640, height: 480)
        
        
//        window.styleMask.remove(.resizable)
        window.styleMask.remove(.miniaturizable)
        let zoomButton = window.standardWindowButton(.zoomButton)
        

        
        self.init(window: window)
        self.window?.delegate = self
        
        let x = (NSScreen.main?.visibleFrame.origin.x ?? CGFloat(0.0)) + (NSScreen.main?.visibleFrame.size.width)! - window.frame.width - 10
        let y = (NSScreen.main?.visibleFrame.origin.y)! + (NSScreen.main?.visibleFrame.height)! - window.frame.height
        self.window?.setFrameOrigin(NSPoint(x: x, y: y))
        
//        window.level = .floating
        
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden
//        window.standardWindowButton(.zoomButton)?.isHidden = true
        window.standardWindowButton(.miniaturizeButton)?.isHidden = true

        
        
        zoomButton?.target = self
        zoomButton?.action = #selector(ZoomButtonAction)
        
        
//        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
//            print("timer : \(self.window?.frame.origin), \(self.window?.frame.size)")
//        }
        
        self.defaultSize = window.frame
        
    }
    
    func windowDidChangeOcclusionState(_ notification: Notification) {
        self.autoCloseWindow()
    }
    
    override func showWindow(_ sender: Any?) {
        super.showWindow(sender)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @objc private func ZoomButtonAction(){
        print(#function)

        guard let frame = self.window?.frame else {
            return
        }
        
        if !(self.window?.frame.equalTo(self.defaultSize!) ?? false){

            self.window?.setFrame(self.defaultSize!, display: true, animate: true)

            
        }
        else{
            print("resize")
            print("\(frame.origin), \(frame.size)")
            var sizeWant = NSRect(x: 0, y: 0, width: 800, height: 800)
            sizeWant.origin.x = frame.origin.x + frame.size.width - sizeWant.width
            sizeWant.origin.y = frame.origin.y + frame.size.height - sizeWant.height
//            frame.origin.y += frame.size.height
//            frame.origin.y -= sizeWant.height
            
//            frame.size = CGSize(width: sizeWant.width, height: sizeWant.height)
            
            self.window?.setFrame(sizeWant, display: false, animate: false)
        }
    }

}

