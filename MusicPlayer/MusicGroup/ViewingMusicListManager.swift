//
//  ViewableMusicListManager.swift
//  MusicPlayer
//
//  Created by Gary Wu on 2020-04-30.
//  Copyright © 2020 Gary Wu. All rights reserved.
//

import Foundation


class ViewableMusicListManager: ObservableObject{
    
    static func makeFrom(listName: String) -> ViewableMusicListManager{
        if listName == "All Music"{
            let list = ViewableMusicListManager()
            list.listName = "All Music"
            for path in AppManager.default.appData.avaliblePath{
                list.musicList.append(contentsOf: AppManager.default.getMusicFromFolder(path: path))
            }
            return list
            
        }else if listName == "Favorite Music"{
            let list = ViewableMusicListManager()
            list.listName = "Favorite Music"
            for path in AppManager.default.appData.avaliblePath{
                list.musicList.append(contentsOf: AppManager.default.getMusicFromFolder(path: path))
            }
            list.musicList = list.musicList.filter {music -> Bool in
                music.isFavorite
            }
            
            return list
        }else{
                        
            let list = ViewableMusicListManager()
            list.listName = "\(listName)"
            let path = AppManager.default.appData.selectingPath.first { str -> Bool in
                URL(fileURLWithPath: str).lastPathComponent == listName
            } ?? ""
            print("path: \(path)")
            list.musicList = AppManager.default.getMusicFromFolder(path: path)
            
            return list
            
        }
        
        
//        return nil
    }
    
    var listName : String = ""
    var needUpdate : Bool = true
    
    var filterString : String = ""{
        didSet{
            self.needUpdate = true
            DispatchQueue.main.async {
                self.objectWillChange.send()
                
            }
        }
    }
    
    var _musicList : [Music] = []{
        didSet{
            self.needUpdate = true
            DispatchQueue.main.async {
                self.objectWillChange.send()
                
            }
        }
    }
    private var tempMusicList : [Music] = []
    
    var musicList : [Music]{
        get{
            if self.filterString == ""{
                return self._musicList
            }else{
                if self.needUpdate{
                    self.tempMusicList = self._musicList.filter {$0.pinyin.contains(filterString)}
                }
                return self.tempMusicList

            }
        }
        set{
            self._musicList = newValue
        }
    }
    

    
    
    func playThisList(){
        print("play : \(self.listName)")
        AppManager.default.appData.playingList = self.listName
        AppManager.default.musicListManager.setMusicList(newList: self.musicList)
    }
    
    @Published var needJumpTo : Int? = nil
    func jumpToCurrentMusic(name: String? = nil){

//        if !(AppManager.default.appData.playingList == self.listName){ return }
        
        var musicName = ""
        if name != nil{
            musicName = name!
        }
        else{
            musicName = AppManager.default.musicListManager.getCurrentMusic().name
        }
        
//        print(musicName)
        
        guard let index = self.musicList.firstIndex(where: { $0.name == musicName }) else { return }
        self.needJumpTo = index
        
    }
    
}
