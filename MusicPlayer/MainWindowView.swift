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
    private var defaultSize : NSRect?
    private var stayOnTop = false
    
    private convenience init() {
        
        let window = NSWindow(contentViewController: NSHostingController(rootView: ContentView()))
        
        window.setContentSize(NSSize(width:640, height: 493))
        
        window.title = "MusicMac"
        window.minSize = NSSize(width: 640, height: 480)
        window.contentMinSize = NSSize(width: 640, height: 480)
        

        let zoomButton = window.standardWindowButton(.zoomButton)
        let minButton = window.standardWindowButton(.miniaturizeButton)

        
        self.init(window: window)
        self.window?.delegate = self
        
        let x = (NSScreen.main?.visibleFrame.origin.x ?? CGFloat(0.0)) + (NSScreen.main?.visibleFrame.size.width)! - window.frame.width - 10
        let y = (NSScreen.main?.visibleFrame.origin.y)! + (NSScreen.main?.visibleFrame.height)! - window.frame.height
        self.window?.setFrameOrigin(NSPoint(x: x, y: y))
                
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden

        
        zoomButton?.target = self
        zoomButton?.action = #selector(zoomButtonAction)
        
        minButton?.target = self
        minButton?.action = #selector(minButtonAction)

        
        self.defaultSize = window.frame
        
    }
    
    func windowDidChangeOcclusionState(_ notification: Notification) {
        self.autoCloseWindow()
    }
    
    override func showWindow(_ sender: Any?) {
        super.showWindow(sender)
        if self.stayOnTop{
            print("stayontop")
            self.window?.level = .floating
        }
        
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @objc private func zoomButtonAction(){
        self.stayOnTop = false
        self.window?.level = .normal
        
        if !(self.window?.frame.equalTo(self.defaultSize!) ?? false){
            self.window?.setFrame(self.defaultSize!, display: true, animate: true)
        }
        else{
            self.becomeLargeWindow()
        }
    }
    
    @objc private func minButtonAction(){
        self.stayOnTop = true
        self.window?.level = .floating
        
        self.becomeSmallWindow()
    }
    
    
    
    private func becomeLargeWindow(){
        guard let frame = self.window?.frame else {
            return
        }
        print("resize")
        print("\(frame.origin), \(frame.size)")
        var sizeWant = NSRect(x: 0, y: 0, width: 800, height: 800)
        sizeWant.origin.x = frame.origin.x + frame.size.width - sizeWant.width
        sizeWant.origin.y = frame.origin.y + frame.size.height - sizeWant.height
        
        self.window?.setFrame(sizeWant, display: false, animate: false)
    }
    

    private func becomeSmallWindow(){
        guard let frame = self.window?.frame else {
            return
        }
        var sizeWant = NSRect(x: 0, y: 0, width: 401, height: 254)
        sizeWant.origin.x = frame.origin.x + frame.size.width - sizeWant.width
        sizeWant.origin.y = frame.origin.y + frame.size.height - sizeWant.height
        self.window?.setFrame(sizeWant, display: true, animate: true)
        

    }
    


    
    func windowWillClose(_ notification: Notification) {
        self.window?.level = .normal
    }

}

