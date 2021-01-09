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
    
    var stayOnTop = false{
        didSet{
            AppManager.default.appData.stayOnTop = stayOnTop
            if stayOnTop{
                self.window?.titleVisibility = .visible
                self.window?.level = .floating
            }else{
                self.window?.titleVisibility = .hidden
                self.window?.level = .normal
            }
        }
    }
    
    private convenience init() {
        
        let window = NSWindow(contentViewController: NSHostingController(rootView: ContentView()))
        
        window.setContentSize(NSSize(width:640, height: 493))
        
        //        window.title = "MusicPlayer"
        
        window.title = AppManager.default.playingMusicListManager.playableMusicList.getCurrentMusic().displayeMusicName
        
        
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
        
        
        AppManager.default.playingMusicListManager.musicPlayer.musicPlayingStateDidChangeHandle["update window title"] = { [weak self] in
            self?.window?.title = AppManager.default.playingMusicListManager.playableMusicList.getCurrentMusic().displayeMusicName
        }
        
    }
    
    func windowDidChangeOcclusionState(_ notification: Notification) {
        self.autoCloseWindow()
    }
    
    override func showWindow(_ sender: Any?) {
        super.showWindow(sender)

        
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @objc private func zoomButtonAction(){
        if self.stayOnTop || AppManager.default.appData.playerFullWindow{
            
            self.stayOnTop = false
            AppManager.default.appData.playerFullWindow = false
            
            self.becomeNormalWindow()
            return
        }
        if !(self.window?.frame.equalTo(self.defaultSize!) ?? false){
            self.becomeNormalWindow()
        }
        else{
            self.becomeLargeWindow()
        }
    }
    
    @objc private func minButtonAction(){
        
        if AppManager.default.appData.playerFullWindow && self.stayOnTop{
            self.becomeSmallWindow()
            return
        }else if AppManager.default.appData.playerFullWindow{
            self.stayOnTop = true
            return
        }else{
            self.stayOnTop = true
            AppManager.default.appData.playerFullWindow = true
            self.becomeSmallWindow()
            return
        }
    }
    
    private func becomeNormalWindow(){
        self.window?.setFrame(self.defaultSize!, display: true, animate: true)
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
    
    
}

