//
//  PlayableMusicList.swift
//  MusicPlayer
//
//  Created by Gary Wu on 2020-11-26.
//  Copyright © 2020 Gary Wu. All rights reserved.
//


import Foundation

fileprivate protocol IMusicListManager {
    var listName : String { get set }
    
    init(musicList: MusicList)
    
    func getCurrentMusic() -> Music
    func setCurrentMusic(music: Music)
    
    func getRandomMusic() -> Music
    func getNextMusic() -> Music
    func getMusicAfter(name: String) -> Music
    func getMusicByName(name: String) -> Music
    
    func getMusicList() -> [Music]
    
    func currentMusicFinishPlay()
}


class PlayableMusicListManager: IMusicListManager, ObservableObject{
    
    var Mlist : MusicList
    
    var listName: String = ""
    
    private var currentMusic : Music!{
        didSet{
            
            oldValue.wrapper.update()
            
            self.currentMusic.wrapper.update()
            AppManager.default.appData.playingMusic = self.currentMusic
            StatusBarView.shared.update_like_StatusItem()
        }
    }
    
    
    private var recorder = MusicPlayedRecorder()
        
    required init(musicList: MusicList) {
        if musicList.list.isEmpty{
            let tempL = MusicList()
            tempL.listName = "temp"
            tempL.list = [Music.placeHolder]
            self.Mlist = tempL
        }
        else{
            self.Mlist = musicList
        }
        self.currentMusic = Music.placeHolder
        
        self.recorder.addMusics(musicList: self.Mlist.list)
        
    }
    
    func getCurrentMusic() -> Music{
        self.currentMusic
    }
    
    func setCurrentMusic(music: Music){
        self.currentMusic = music
    }
    
    func getFirstMusic() -> Music{
        self.Mlist.list.first ?? Music.placeHolder
    }
    
    func getNextMusic() -> Music{
        var i = self.Mlist.list.firstIndex { music -> Bool in
            music == self.currentMusic
            } ?? -1
        i += 1
        
        if (i >= self.Mlist.list.count){
            i = 0
        }
        
        return self.Mlist.list[i]
    }
    
    func getRandomMusic() -> Music {
        if self.Mlist.list.count < 3 { return self.Mlist.list.randomElement()! }
        
        let min = self.recorder.musicPlayedDic.values.map({$0.currentPlayCount}).min() ?? 0.0
        let _ = self.recorder.musicPlayedDic.values.map({$0.currentPlayCount -= min})
        
        let chooseList = self.Mlist.list.flatMap { (item) -> [Music] in
            var times : Int = 0
            if !self.recorder.recentPlayed.contains(item.name){
                times = Int(Double(item.likeDegree) - item.currentPlayCount) + 2 // 2 is changable
                if times < 0 { times = 0 }
                
            }
            return Array(repeating: item, count: times)
        }
        
        guard let randomMusic = chooseList.randomElement() else {
            return self.Mlist.list.randomElement()!
        }
        
        return randomMusic
    }
    
    func getMusicAfter(name: String) -> Music {
        var i = self.Mlist.list.firstIndex { $0.name == name } ?? -1
        i += 1
        
        if !(i < self.Mlist.list.count){
            i = 0
        }
        
        return self.Mlist.list[i]
    }
    
    func getMusicByName(name: String) -> Music {
        let i = self.Mlist.list.firstIndex { $0.name == name } ?? 0
        return self.Mlist.list[i]
    }
    
    func getMusicList() -> [Music]{
        self.Mlist.list
    }
    
    private func useRecorder() -> Bool{
        AppManager.default.appData.repeatShuffleStatus == .shuffle
    }
    
    func currentMusicFinishPlay(){
        if self.useRecorder(){
            self.recorder.musicAddPlayTime(name: self.currentMusic.name, likeDegree:  self.currentMusic.likeDegree)
        }
        self.currentMusic.playCount += 1
    }
    
    
    
}
