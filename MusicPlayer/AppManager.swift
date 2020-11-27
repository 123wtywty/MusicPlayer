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

        self.musicManager = MusicManager()
        
        self.playingMusicListManager = PlayingMusicListManager(playableMusicList: PlayableMusicListManager(musicList: MusicList()))
        
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
            ViewableMusicListManager.makeSpecialList(listName: "All Music")
        }
        let Favorite_Music = SingleMusicList(name: "Favorite Music") { () -> ViewableMusicListManager in
            ViewableMusicListManager.makeSpecialList(listName: "Favorite Music")
        }
        defaultList.addSubList(list: All_Music)
        defaultList.addSubList(list: Favorite_Music)
        self.musicListOverViewData.addSubBlock(block: defaultList)
        
        let folder = MusicBlock(name: "folder")
        
        for path in self.appData.avaliblePath{
            let tempList = SingleMusicList(name: "\(URL(fileURLWithPath: path).lastPathComponent)") { () -> ViewableMusicListManager in
                ViewableMusicListManager.makeFromPath(path: path)
            }
            folder.addSubList(list: tempList)
        }
        
        self.musicListOverViewData.addSubBlock(block: folder)
    }
    
    
    var musicManager : MusicManager
    let playingMusicListManager : PlayingMusicListManager
    var viewingMusicListManager : ViewableMusicListManager
    var musicMaker : MusicMaker
    var appData : AppData
    var musicListOverViewData : MusicListOverViewData
    
    func savedataToUserDefaults(){
        var dataNeedSave : [String : Any] = [:]
        dataNeedSave["selectingPath"] = self.appData.selectingPath
        dataNeedSave["blockedPath"] = self.appData.blockedPath
        
        dataNeedSave["playingMusicName"] = self.playingMusicListManager.playableMusicList.getCurrentMusic().name
        dataNeedSave["playingListName"] = self.playingMusicListManager.playableMusicList.Mlist.listName
        
        dataNeedSave["folderPath"] = self.playingMusicListManager.playableMusicList.Mlist.folderPath ?? ""
        dataNeedSave["isSpecialList"] = self.playingMusicListManager.playableMusicList.Mlist.isSpecialList
        
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
