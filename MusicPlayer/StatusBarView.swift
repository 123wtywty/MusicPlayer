//
//  StatusBarView.swift
//  MusicPlayer
//
//  Created by Gary Wu on 2020-04-30.
//  Copyright © 2020 Gary Wu. All rights reserved.
//

import Foundation
import Cocoa
import SwiftUI
import NotificationCenter


// set up status bar icons
class StatusBarView{
    
    static let shared = StatusBarView()
    
    var icon_StatusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    var like_StatusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    var play_pause_StatusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    
    func makeView(){
        let musicIcon = NSImage(named: NSImage.Name("i2"))!
        musicIcon.size = NSSize(width: 16, height: 16)
        
        
        self.play_pause_StatusItem.button!.action = #selector(playPause)
        self.play_pause_StatusItem.button?.title = "􀊕"
        
        
        self.like_StatusItem.button!.action = #selector(toggleIsFavorite)
        self.like_StatusItem.button!.title = AppManager.default.playingMusicListManager.playableMusicList.getCurrentMusic().isFavorite ? "􀊵" : "􀊴"
        
        
        AppManager.default.playingMusicListManager.musicPlayer.musicPlayingStateDidChangeHandle["play_pause_StatusItem.button"] = { [weak self] in
            self?.play_pause_StatusItem.button?.title = !AppManager.default.playingMusicListManager.musicPlayer.player.isPlaying ? "􀊕" : "􀊗"
        }
        
        icon_StatusItem.button!.image = musicIcon
        icon_StatusItem.button!.action = #selector(openMainWindow)

        
        play_pause_StatusItem.button?.target = self
        icon_StatusItem.button?.target = self
        like_StatusItem.button?.target = self
        
        
    }
    
    public func update_like_StatusItem(){

        DispatchQueue.main.async {
            self.like_StatusItem.button!.title = AppManager.default.playingMusicListManager.playableMusicList.getCurrentMusic().isFavorite ? "􀊵" : "􀊴"
            
        }
    }
    
    @objc private func playPause(){
        print(#function)
        
        if AppManager.default.playingMusicListManager.musicPlayer.player.isPlaying{
            AppManager.default.playingMusicListManager.musicPlayer.player.pause()
        }else{
            AppManager.default.playingMusicListManager.musicPlayer.player.play()
        }
    }
    
    @objc func openMainWindow(){
        
        if MainWindowViewWindowController.shared.window?.isVisible ?? false{
            MainWindowViewWindowController.shared.close()
        }
        else{
            MainWindowViewWindowController.shared.showWindow(nil)
        }
    }
    
    @objc private func toggleIsFavorite(){
        print(#function)
        AppManager.default.playingMusicListManager.playableMusicList.getCurrentMusic().isFavorite.toggle()
        print("\(AppManager.default.playingMusicListManager.playableMusicList.getCurrentMusic().isFavorite)")
    }
    
    
}
