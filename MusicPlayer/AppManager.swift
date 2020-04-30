//
//  AppManager.swift
//  MusicPlayer
//
//  Created by Gary Wu on 2020-04-29.
//  Copyright © 2020 Gary Wu. All rights reserved.
//

import Foundation
import AVFoundation


class AppManager{
    
    static let `default` = AppManager()
    
    private init(){
        let mainPlayer = AVPlayer()
        
        self.musicPlayer = MusicPlayer(player: mainPlayer)
        self.musicManager = MusicManager()
        self.musicListManager = MusicListManager(musicList: [])
        self.musicMaker = MusicMaker()
        self.appData = AppData()
        
    }
    
    
    var musicPlayer : MusicPlayer
    var musicManager : MusicManager
    var musicListManager : MusicListManager
    var musicMaker : MusicMaker
    var appData : AppData
    
    
    
    func getMusicFromFolder(path: String) -> [Music] {
        let fileManager = FileManager.default
        var musicListString : [String] = []
        
        if !fileManager.fileExists(atPath: path) { return [Music.placeHolder] }
        
        do {
            musicListString = try fileManager.contentsOfDirectory(atPath: "\(path)")
            
            musicListString = musicListString.filter { (musicName) -> Bool in
                let URLPathExtension = URL(fileURLWithPath: path + "/" + musicName).pathExtension
                if MusicType.MusicTypeList.contains(URLPathExtension){
                    return true
                }
                else{
                    return false
                }
            }
            
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
        
        var musicList : [Music] = []
        for musicRawName in musicListString {
            
            let completePath = "\(path)/\(musicRawName)"
            let i = musicRawName.lastIndex(of: "-") ?? musicRawName.lastIndex(of: ".") ?? musicRawName.endIndex
            
            let completeUrl = URL(fileURLWithPath: completePath)
            //            let completeUrl = URL(string: completePath)
            
            let m = AppManager.default.musicMaker.make(name: String(musicRawName[..<i]), url: completeUrl, cover: nil)
            
            //            print(completePath)
            //            print(completeUrl)
            musicList.append(m)
            
            
        }
        if musicList.isEmpty { return [Music.placeHolder] }
        return musicList
    }

    
    
}
