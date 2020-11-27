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
        
        self.musicListOverViewData = MusicListOverViewData()
        self.setUpMusicListOverViewData()
    }
    
    func setUpMusicListOverViewData(){
        self.musicListOverViewData = MusicListOverViewData()
        
        let defaultList = MusicBlock(name: "defaultList")
        let All_Music = SingleMusicList(name: "All Music") { () -> ViewableMusicListManager in
            let list = ViewableMusicListManager()
            list.listName = "All Music"
            for path in AppManager.default.appData.avaliblePath{
                print(path)
                list.musicList.append(contentsOf: AppManager.default.getMusicFromFolder(path: path))
            }
            
            list.musicList.sort(by: AppManager.default.musicListManager.sortFunc)
            
            return list
        }
        let Favorite_Music = SingleMusicList(name: "Favorite Music") { () -> ViewableMusicListManager in
            let list = ViewableMusicListManager()
            list.listName = "Favorite Music"
            for path in AppManager.default.appData.avaliblePath{
                list.musicList.append(contentsOf: AppManager.default.getMusicFromFolder(path: path))
            }
            list.musicList = list.musicList.filter {music -> Bool in
                music.isFavorite
            }
            
            list.musicList.sort(by: AppManager.default.musicListManager.sortFunc)
            return list
        }
        defaultList.addSubList(list: All_Music)
        defaultList.addSubList(list: Favorite_Music)
        self.musicListOverViewData.addSubBlock(block: defaultList)
        
        let folder = MusicBlock(name: "folder")
        
        for path in self.appData.avaliblePath{
            let tempList = SingleMusicList(name: "\(URL(fileURLWithPath: path).lastPathComponent)") { () -> ViewableMusicListManager in
                let list = ViewableMusicListManager()
                list.listName = "\(URL(fileURLWithPath: path).lastPathComponent)"
                list.musicList = AppManager.default.getMusicFromFolder(path: path)
                return list
            }
            folder.addSubList(list: tempList)
        }
        
        self.musicListOverViewData.addSubBlock(block: folder)
    }
    
    
    var musicPlayer : MusicPlayer
    var musicManager : MusicManager
    var musicListManager : MusicListManager
    var viewingMusicListManager : ViewableMusicListManager
    var musicMaker : MusicMaker
    var appData : AppData
    var musicListOverViewData : MusicListOverViewData
    
    func savedataToUserDefaults(){
        var dataNeedSave : [String : Any] = [:]
        dataNeedSave["selectingPath"] = self.appData.selectingPath
        dataNeedSave["blockedPath"] = self.appData.blockedPath
        
        dataNeedSave["playingMusicName"] = self.appData.playingMusic.name
        dataNeedSave["playingList"] = self.appData.playingList
        
        dataNeedSave["repeatShuffleStatus"] = self.appData.repeatShuffleStatus.rawValue
        
        if let data = try? JSONSerialization.data(withJSONObject: dataNeedSave, options: []){
            UserDefaults.standard.set(String(data: data, encoding: String.Encoding.utf8), forKey: "lastTimeData")
        }
        
    }
    
    func restart(){
        
//        self.savedataToUserDefaults()

        
        let task = Process()
        task.currentDirectoryPath = NSHomeDirectory()
        
        task.launchPath = "/usr/bin/open"
        task.arguments = ["-n", "-b", "com.GW.MusicPlayer"]
        task.launch()
        task.waitUntilExit()
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
        self.terminate()
//        }
    }
    
    func terminate(){
        
        self.savedataToUserDefaults()
        
        NSApplication.shared.terminate(nil)
    }
    
    func getMusicFromFolder(path: String) -> [Music] {
        let fileManager = FileManager.default
        var musicListString : [String] = []
        
        if !fileManager.fileExists(atPath: path) {
            print("path not exists: \(path)")
            return [Music.placeHolder]
            
        }
        
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
            
            let completeUrl = URL(fileURLWithPath: completePath)            
            let m = AppManager.default.musicMaker.make(name: String(musicRawName), url: completeUrl)

            musicList.append(m)
            
            
        }
        if musicList.isEmpty { return [Music.placeHolder] }
        return musicList.sorted(by: AppManager.default.musicListManager.sortFunc)
    }

    
    
}
