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
import MediaPlayer


fileprivate protocol IMusicPlayer {
    init(player : AVPlayer, playableMusicList : PlayableMusicListManager)
    
    var player: AVPlayer { get set }
    var currentMusicInfo : CurrentMusicInfo { get }
    var musicPlayingStateDidChangeHandle : [String: () -> ()] { get set }

    func playMusic(name: String)
    func playMusic(music: Music)

    func playFirstMusic()
    func playNextMusic()
    func playRandomMusic()


}


class MusicPlayer: NSObject, IMusicPlayer{


    var musicPlayingStateDidChangeHandle : [String: () -> ()] = [:]
    private var obPool : [String : Any] = [:]
    @objc dynamic var player: AVPlayer
    var currentMusicInfo : CurrentMusicInfo
    private var playableMusicList : PlayableMusicListManager


    required init(player: AVPlayer, playableMusicList : PlayableMusicListManager) {
        self.player = player
        self.playableMusicList = playableMusicList
        self.currentMusicInfo = CurrentMusicInfo(Title: "", AlbumTitle: "", Artist: "", Artwork: nil)
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

//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
    func changeMusicList(musicList: PlayableMusicListManager){
        self.playableMusicList = musicList
    }

    private func play(music: Music){
        print(music.url.path)
        if !FileManager.default.fileExists(atPath: music.url.path) {
            self.playMusicAccordingToSetting()
            return
        }
        self.playableMusicList.setCurrentMusic(music: music)
        self.player.replaceCurrentItem(with: AVPlayerItem(asset: AVAsset(url: music.url)))
        self.updateCurrentMusicInfo()
        if AppManager.default.appData.playerPlayMusicWhenReady{ self.player.play() }

    }

    func playMusic(name: String) {
        let music = self.playableMusicList.getMusicByName(name: name)
        self.play(music: music)
    }

    func playMusic(music: Music) {
        let music = self.playableMusicList.getMusicByName(name: music.name)
        self.play(music: music)

        AppManager.default.savedataToUserDefaults()
    }

    func playFirstMusic() {
        self.play(music: self.playableMusicList.getFirstMusic())
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

        self.playMusicAccordingToSetting()


    }
    
    func currentMusicIsMp3() -> Bool{
        return self.playableMusicList.getCurrentMusic().type == .mp3
    }
    
    func updateCurrentMusicInfo(){
        var info = CurrentMusicInfo(Title: "", AlbumTitle: "", Artist: "")
        guard let metadataList = self.player.currentItem?.asset.metadata else {return}
        for item in metadataList {
            switch item.commonKey {
            case .commonKeyTitle?:
                info.Title = item.stringValue ?? ""
            case .commonKeyAlbumName?:
                info.AlbumTitle = item.stringValue ?? ""
            case .commonKeyArtist?:
                info.Artist = item.stringValue ?? ""
            case .commonKeyArtwork?:
                if let data = item.dataValue,
                    let image = NSImage(data: data) {
                    info.Artwork = image
                }
            case .none: break
            default: break
            }
        }
        self.currentMusicInfo = info
    }


}
