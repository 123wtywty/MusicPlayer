//
//  AppManager.swift
//  MusicPlayer
//
//  Created by Gary Wu on 2020-04-29.
//  Copyright © 2020 Gary Wu. All rights reserved.
//

import Foundation
import AVFoundation
import Cocoa

class AppManager{
    
    static let `default` = AppManager()
    
    private init(){
        let mainPlayer = AVPlayer()
        
        self.musicPlayer = MusicPlayer(player: mainPlayer)
        self.musicManager = MusicManager()
        
        self.musicListManager = MusicListManager(musicList: [])
        self.viewingMusicListManager = ViewableMusicListManager()
        
        self.musicMaker = MusicMaker()
        self.appData = AppData()
        
    }
    
    
    var musicPlayer : MusicPlayer
    var musicManager : MusicManager
    var musicListManager : MusicListManager
    var viewingMusicListManager : ViewableMusicListManager
    var musicMaker : MusicMaker
    var appData : AppData
    
    private func savedataToUserDefaults(){
        var dataNeedSave : [String : Any] = [:]
        dataNeedSave["playingMusicName"] = AppManager.default.appData.playingMusicName
        dataNeedSave["selectingPath"] = AppManager.default.appData.selectingPath
        dataNeedSave["blockedPath"] = AppManager.default.appData.blockedPath
        
        if let data = try? JSONSerialization.data(withJSONObject: dataNeedSave, options: []){
            UserDefaults.standard.set(String(data: data, encoding: String.Encoding.utf8), forKey: "lastTimeData")
        }
        
    }
    
    func restart(){
        
        self.savedataToUserDefaults()

        
        let task = Process()
        task.currentDirectoryPath = "/Users/gary"
        task.launchPath = "/usr/bin/open"
        task.arguments = ["-n", "-b", "com.GW.MusicPlayer"]
        task.launch()
        task.waitUntilExit()
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            NSApplication.shared.terminate(nil)
//        }
    }
    
    func terminate(){
        
        self.savedataToUserDefaults()
        
        NSApplication.shared.terminate(nil)
    }
    
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
            let m = AppManager.default.musicMaker.make(name: String(musicRawName[..<i]), url: completeUrl, cover: nil)

            musicList.append(m)
            
            
        }
        if musicList.isEmpty { return [Music.placeHolder] }
        return musicList.sorted(by: AppManager.default.musicListManager.sortFunc)
    }

    
    
}
