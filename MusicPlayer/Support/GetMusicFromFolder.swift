//
//  GetMusicFromFolder.swift
//  MusicPlayer
//
//  Created by Gary Wu on 2020-04-29.
//  Copyright © 2020 Gary Wu. All rights reserved.
//

import Foundation

func GetMusicFromFolder(path: String) -> [Music] {
    let fileManager = FileManager.default
    var musicListString : [String] = []
    
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
        print("\(error)")
    }
    
    var musicList : [Music] = []
    for musicRawName in musicListString {
        
        let completePath = "\(path)/\(musicRawName)"

        
        let completeUrl = URL(fileURLWithPath: completePath)
        //            let completeUrl = URL(string: completePath)
        
        let m = AppManager.default.musicMaker.make(name: musicRawName, url: completeUrl)
        
        musicList.append(m)
        
        
    }
    
    return musicList
}




