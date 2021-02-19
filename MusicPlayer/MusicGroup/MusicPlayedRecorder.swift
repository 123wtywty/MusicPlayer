//
//  MusicPlayedRecorder.swift
//  MusicPlayer
//
//  Created by Gary Wu on 2020-04-29.
//  Copyright © 2020 Gary Wu. All rights reserved.
//

import Foundation

class MusicPlayedRecorder {

    var musicPlayedDic : [String : Music] = [:]
    
    var recentPlayed = ["",""]
        
    func addMusic(music: Music){
        if !self.musicExist(name: music.name){
            music.currentPlayCount = 0.0
            self.musicPlayedDic[music.name] = music
        }
    }
    
    func addMusics(musicList : [Music]){
        for i in musicList{
            self.addMusic(music: i)
        }
    }
    
    
    func musicExist(name: String) -> Bool{
        return self.musicPlayedDic[name] != nil
    }
    
    func musicAddPlayTime(name: String, likeDegree : Int){
        let amount = 1 - Double(likeDegree) * 0.1
              
        self.recentPlayed.removeFirst()
        self.recentPlayed.append(name)
        
        self.musicPlayedDic[name]?.currentPlayCount += amount
        self.musicPlayedDic[name]?.realCurrentPlayCount += 1
    }
    
  
    
    func setPlayedTimeFor(name: String, to: Double){
        self.musicPlayedDic[name]?.currentPlayCount = to
    }
}


