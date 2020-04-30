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
    init(player: AVPlayer)
    
    var player: AVPlayer { get set }
    var musicPlayingStateDidChangeHandle : [String: () -> ()] { get set }

    func playMusic(name: String)
    func playMusic(music: Music)
    
    func playNextMusic()
    func playRandomMusic()
    
    
}


class MusicPlayer: NSObject, IMusicPlayer{
    
    var musicPlayingStateDidChangeHandle : [String: () -> ()] = [:]
    private var obPool : [NSKeyValueObservation] = []
    @objc dynamic var player: AVPlayer
    
    required init(player: AVPlayer) {
        self.player = player
        super.init()
        
        self.player.volume = 0.4
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self, queue: .main) { _ in self.musicPlayToEnd() }
        
        self.obPool.append(
            observe(\.player.timeControlStatus) { _,_  in
                for handle in self.musicPlayingStateDidChangeHandle.values{
                    handle()
                }
            }
        )
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    private func play(music: Music){
        AppManager.default.musicListManager.setCurrentMusic(music: music)
        self.player.replaceCurrentItem(with: AVPlayerItem(asset: AVAsset(url: music.url)))
    }
    
    func playMusic(name: String) {
        let music = AppManager.default.musicListManager.getMusicByName(name: name)
        self.play(music: music)
    }
    
    func playMusic(music: Music) {
        let music = AppManager.default.musicListManager.getMusicByName(name: music.name)
        self.play(music: music)
    }
    
    func playNextMusic() {
        let music = AppManager.default.musicListManager.getNextMusic()
        self.play(music: music)
    }
    
    func playRandomMusic() {
        let music = AppManager.default.musicListManager.getRandomMusic()
        self.play(music: music)
    }
    
    
    private func musicPlayToEnd(){
        AppManager.default.musicListManager.currentMusicFinishPlay()
        
        switch AppManager.default.appData.repeatShuffleStatus{
        case .shuffle:
            self.playRandomMusic()
        case .repeat:
            self.playNextMusic()
        case .repeat_1:
            self.playMusic(music: AppManager.default.musicListManager.getCurrentMusic())
        }
    }
    

}
