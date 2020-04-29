//
//  MusicListManager.swift
//  MusicPlayer
//
//  Created by Gary Wu on 2020-04-29.
//  Copyright © 2020 Gary Wu. All rights reserved.
//

import Foundation

fileprivate protocol IMusicListManager {
    var sortFunc : (Music, Music) -> Bool { get set }
    
    init(musicList: [Music])
    
    func getCurrentMusic() -> Music
    func setCurrentMusic(music: Music)
    
    func getRandomMusic() -> Music
    func getNextMusic() -> Music
    func getMusicAfter(name: String) -> Music
    func getMusicByName(name: String) -> Music
    
    func getMusicList() -> [Music]
    func setMusicList()
    
    func addMusic(music: Music)
    func removeMusic(music: Music)
    
    func currentMusicFinishPlay()
}


class MusicListManager: IMusicListManager, ObservableObject{
    
    private var musicList : [Music]{
        didSet{
            
        }
    }
    private var currentMusic : Music
    
    
    private var recorder = MusicPlayedRecorder()
    
    var sortFunc : (Music, Music) -> Bool = { $0.name > $1.name }
    
    required init(musicList: [Music]) {
        if musicList.isEmpty{
            self.musicList = [Music.placeHolder]
        }
        else{
            self.musicList = musicList
        }
        
        for i in self.musicList{
            self.recorder.addMusic(name: i.name)
        }
    }
    
    func getCurrentMusic() -> Music{
        self.currentMusic
    }
    
    func setCurrentMusic(music: Music){
        self.currentMusic = music
    }
    
    func getNextMusic() -> Music{
        var i = self.musicList.firstIndex { music -> Bool in
            music == self.currentMusic
        } ?? -1
        i += 1
        
        if !(i < self.musicList.count){
            i = 0
        }
        
        return self.musicList[i]
    }
    
    func getRandomMusic() -> Music {
        <#code#>
    }
    
    func getMusicAfter(name: String) -> Music {
        <#code#>
    }
    
    func getMusicByName(name: String) -> Music {
        <#code#>
    }
    
    func getMusicList() -> [Music]{
        
    }
    
    func setMusicList(){
        
    }
    
    func addMusic(music: Music){
        self.recorder.addMusic(name: music.name)
        self.musicList.append(music)
    }
    
    func removeMusic(music: Music){
        
    }
    
    func currentMusicFinishPlay(){
        self.recorder.musicAddPlayTime(name: self.currentMusic.name, isFavorite: self.currentMusic.isFavorite)
    }
    
    
    
}
