//
//  MusicPlayer.swift
//  MusicPlayer
//
//  Created by Gary Wu on 2020-04-29.
//  Copyright © 2020 Gary Wu. All rights reserved.
//

import Foundation
import AVKit
import NotificationCenter
import Cocoa


fileprivate protocol IMusicPlayer {
    init(player : AVPlayer, playableMusicList : PlayableMusicListManager)
    
    var player: AVPlayer { get set }
    var musicPlayingStateDidChangeHandle : [String: () -> ()] { get set }
    
    func playMusic(name: String)
    func playMusic(music: Music)
    
    func playNextMusic()
    func playRandomMusic()
    
    
}


class MusicPlayer: NSObject, IMusicPlayer{
    
    
    var musicPlayingStateDidChangeHandle : [String: () -> ()] = [:]
    private var obPool : [String : Any] = [:]
    @objc dynamic var player: AVPlayer
    var playableMusicList : PlayableMusicListManager

    
    required init(player: AVPlayer, playableMusicList : PlayableMusicListManager) {
        self.player = player
        self.playableMusicList = playableMusicList
        super.init()
        
        self.player.volume = 0.4
        
        self.obPool["observe player.timeControlStatus"] = observe(\.player.timeControlStatus) { _,_  in
            for handle in self.musicPlayingStateDidChangeHandle.values{
                handle()
            }
        }
        
        
        
        self.obPool["timer"] = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { _ in

            if self.player.playToEnd{
                self.musicPlayToEnd()
            }
        }
        
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    private func play(music: Music){
        print(music.url.path)
        if !FileManager.default.fileExists(atPath: music.url.path) {
            self.playMusicAccordingToSetting()
            return
        }
        self.playableMusicList.setCurrentMusic(music: music)
        self.player.replaceCurrentItem(with: AVPlayerItem(asset: AVAsset(url: music.url)))
        self.player.play()
    }
    
    func playMusic(name: String) {
        let music = self.playableMusicList.getMusicByName(name: name)
        self.play(music: music)
    }
    
    func playMusic(music: Music) {
        let music = self.playableMusicList.getMusicByName(name: music.name)
        self.play(music: music)
    }
    
    func playNextMusic() {
        let music = self.playableMusicList.getNextMusic()
        self.play(music: music)
    }
    
    func playRandomMusic() {
        let music = self.playableMusicList.getRandomMusic()
        self.play(music: music)
    }
    
    func playMusicAccordingToSetting(){
        switch AppManager.default.appData.repeatShuffleStatus {
        case .shuffle:
            self.playRandomMusic()
        case .repeat:
            self.playNextMusic()
        case .repeat_1:
            self.playMusic(music: self.playableMusicList.getCurrentMusic())

        }
    }
    
    
    private func musicPlayToEnd(){
        print(#function)
        self.playableMusicList.currentMusicFinishPlay()
        
        if self.playableMusicList.getCurrentMusic().name == "placeHolder" { return }
        
        switch AppManager.default.appData.repeatShuffleStatus{
        case .shuffle:
            self.playRandomMusic()
        case .repeat:
            self.playNextMusic()
        case .repeat_1:
            self.playMusic(music: self.playableMusicList.getCurrentMusic())
        }
        
        AppManager.default.savedataToUserDefaults()
    }
    
    
}
