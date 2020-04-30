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
    var listName : String { get set }
    
    init(musicList: [Music])
    
    func getCurrentMusic() -> Music
    func setCurrentMusic(music: Music)
    
    func getRandomMusic() -> Music
    func getNextMusic() -> Music
    func getMusicAfter(name: String) -> Music
    func getMusicByName(name: String) -> Music
    
    func getMusicList() -> [Music]
    func setMusicList(newList: [Music])
    
    func addMusic(music: Music)
    func removeMusic(music: Music)
    
    func currentMusicFinishPlay()
}


class MusicListManager: IMusicListManager, ObservableObject{
    
    private var musicList : [Music]{
        didSet{
            print("need update ui")
            DispatchQueue.main.async {
                self.objectWillChange.send()
                
            }
        }
    }
    
    var listName: String = ""
    
    private var currentMusic : Music{
        willSet{
            self.currentMusic.wrapper.update()
        }
        
        didSet{
            self.currentMusic.wrapper.update()
        }
    }
    
    
    private var recorder = MusicPlayedRecorder()
    
    var sortFunc : (Music, Music) -> Bool = { $0.name > $1.name }
    
    required init(musicList: [Music]) {
        if musicList.isEmpty{
            self.musicList = [Music.placeHolder]
        }
        else{
            self.musicList = musicList
        }
        
        
        self.currentMusic = Music.placeHolder
        self.currentMusic = self.getRandomMusic()
        
        
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
        if self.musicList.count < 3 { return self.musicList.randomElement()! }
        
        let chooseList = self.musicList.flatMap { (item) -> [Music] in
            var times = 0.0
            if !self.recorder.recentPlayed.contains(item.name){
                times = self.recorder.maxPlayTime() - self.recorder.timesPlayedForMusic(name: item.name)
                if times < 0{
                    times = 0
                }
                
            }
            return Array(repeating: item, count: Int(times * 2 + 0.5))
        }
        
        guard let randomMusic = chooseList.randomElement() else {
            return self.musicList.randomElement()!
        }
        
        return randomMusic
    }
    
    func getMusicAfter(name: String) -> Music {
        var i = self.musicList.firstIndex { $0.name == name } ?? -1
        i += 1
        
        if !(i < self.musicList.count){
            i = 0
        }
        
        return self.musicList[i]
    }
    
    func getMusicByName(name: String) -> Music {
        let i = self.musicList.firstIndex { $0.name == name } ?? 0
        return self.musicList[i]
    }
    
    func getMusicList() -> [Music]{
        self.musicList
    }
    
    func setMusicList(newList: [Music]){
        
        let removedMusics = Set(self.musicList).subtracting(newList)
        for i in removedMusics{
            self.recorder.removeMusic(name: i.name)
        }
        
        let newMusics = Set(newList).subtracting(self.musicList)
        for i in newMusics{
            self.recorder.addMusic(name: i.name)
        }
        
        self.musicList = newList
        
        if !self.musicList.contains(self.currentMusic){
            AppManager.default.musicPlayer.playRandomMusic()
        }
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
