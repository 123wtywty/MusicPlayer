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
        
        self.playingMusicListManager = PlayingMusicListManager(playableMusicList: PlayableMusicListManager(musicList: MusicList()))
        
        self.viewingMusicListManager = ViewableMusicListManager()
        
        self.musicMaker = MusicMaker()
        self.appData = AppData()
        self.appData.setUp(musicPlayer: self.playingMusicListManager.musicPlayer)
        
        self.musicListOverViewData = MusicListOverViewData()
        self.setUpMusicListOverViewData()
    }
    
    func setUpMusicListOverViewData(){
        self.musicListOverViewData = MusicListOverViewData()
        
        let defaultList = MusicBlock(name: "defaultList")
        let All_Music = BaseMusicList(name: "All Music") { () -> ViewableMusicListManager in
            ViewableMusicListManager.makeSpecialList(listName: "All Music")
        }
        let Favorite_Music = BaseMusicList(name: "Favorite Music") { () -> ViewableMusicListManager in
            ViewableMusicListManager.makeSpecialList(listName: "Favorite Music")
        }
        defaultList.addSubList(list: All_Music)
        defaultList.addSubList(list: Favorite_Music)
        self.musicListOverViewData.addSubBlock(block: defaultList)
        
        let folder = MusicBlock(name: "folder")
        
        for path in self.appData.avaliblePath{
            let tempList = BaseMusicList(name: "\(URL(fileURLWithPath: path).lastPathComponent)") { () -> ViewableMusicListManager in
                ViewableMusicListManager.makeFromPath(path: path)
            }
            folder.addSubList(list: tempList)
        }
        
        self.musicListOverViewData.addSubBlock(block: folder)
    }
    
    let playingMusicListManager : PlayingMusicListManager
    var viewingMusicListManager : ViewableMusicListManager
    var musicMaker : MusicMaker
    var appData : AppData
    var musicListOverViewData : MusicListOverViewData
    
    func savedataToUserDefaults(){
        
//        UserDefaults.standard.removeObject(forKey: "lastTimeData")
//        return

        var dataNeedSave : [String : Any] = [:]
        dataNeedSave["selectingPath"] = self.appData.selectingPath
        dataNeedSave["blockedPath"] = self.appData.blockedPath
        
        dataNeedSave["playingMusicName"] = self.appData.playingMusic.name
        dataNeedSave["playingListName"] = self.appData.playingList.listName
        
        dataNeedSave["folderPath"] = self.appData.playingList.folderPath ?? ""
        dataNeedSave["isSpecialList"] = self.appData.playingList.isSpecialList
        
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

    
    
}
