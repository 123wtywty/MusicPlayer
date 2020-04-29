//
//  MusicPlayedRecorder.swift
//  MusicPlayer
//
//  Created by Gary Wu on 2020-04-29.
//  Copyright © 2020 Gary Wu. All rights reserved.
//

import Foundation

class MusicPlayedRecorder {
    private var totalPlayedTime = 0.0{
        didSet{
            self.check()
        }
    }

    private var musicPlayedDic : [String : Double] = [:]
    
    var recentPlayed = ["",""]
    
    private func check(){
        if let min = self.musicPlayedDic.values.min(), min > 0{
            for keys in self.musicPlayedDic.keys{
                self.musicPlayedDic[keys] = musicPlayedDic[keys]! - min
                self.totalPlayedTime -= min
                
            }
        }
    }
    
    func getTotalPlayedTime() -> Double{
        return self.totalPlayedTime
    }
    
    func timesPlayedForMusic(name: String) -> Double{
        return self.musicPlayedDic[name] ?? -1
    }
    
    func maxPlayTime() -> Double{
        if musicPlayedDic.count == 0{
            return 1
        }else{
            return (totalPlayedTime / Double(musicPlayedDic.count)) + 1
        }
    }
    
    
    func addMusic(name: String){
        if !self.musicExist(name: name){
            self.musicPlayedDic[name] = totalPlayedTime / Double(musicPlayedDic.count + 1)
            self.check()
        }
    }
    
    func removeMusic(name: String){
        if self.musicExist(name: name){
            self.totalPlayedTime -= self.musicPlayedDic[name]!
            self.musicPlayedDic.remove(at: self.musicPlayedDic.index(forKey: name)!)
            self.check()
        }
    }
    
    
    func musicExist(name: String) -> Bool{
        return self.musicPlayedDic[name] != nil
    }
    
    func musicAddPlayTime(name: String, isFavorite : Bool){
        let amount = isFavorite ? 0.7 : 1
        self.totalPlayedTime += amount
        
        if self.musicExist(name: name){
            self.musicPlayedDic[name]! += amount
        }else{
            self.addMusic(name: name)
            self.musicPlayedDic[name]! += amount
        }
    }
    
    func musicReduceOnePlayTime(name: String, amount : Double){
        if self.musicExist(name: name) && self.musicPlayedDic[name]! > 0{
            self.musicPlayedDic[name]! -= amount
            self.totalPlayedTime -= amount
            
        }
    }
    
    
    func averagePlayedTime() -> Double{
        self.totalPlayedTime / Double(self.musicPlayedDic.count)
    }
    
    
    func setPlayedTimeFor(name: String, to: Double){
        self.musicPlayedDic[name] = to
    }
}


