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
            list.isSpecialList = true
            for path in AppManager.default.appData.avaliblePath{
                list.musicList.append(contentsOf: AppManager.default.getMusicFromFolder(path: path))
            }
            return list
            
        }else if listName == "Favorite Music"{
            let list = ViewableMusicListManager()
            list.listName = "Favorite Music"
            list.isSpecialList = true
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
            list.folderPath = path
            
            list.musicList = AppManager.default.getMusicFromFolder(path: path)
            
            return list
            
        }
        
        
//        return nil
    }
    
    var listName : String = ""
    var folderPath : String? = nil
    var isSpecialList : Bool = false
    
    var needUpdateList : Bool = true
    
    var filterString : String = ""{
        didSet{
            self.update()
        }
    }
    
    private var originalMusicList : [Music] = []{
        didSet{
            self.update()
        }
    }
    
    
    private func update(){
        self.needUpdateList = true
        DispatchQueue.main.async {
            self.objectWillChange.send()
            
        }
    }
    
    private var tempMusicList : [Music] = []
    
    var musicList : [Music]{
        get{
            if self.filterString == ""{
                return self.originalMusicList
            }else{
                if self.needUpdateList{
                    self.tempMusicList =
                        self.originalMusicList.filter
                        {$0.simplifiedchinese.REContains(str: filterString.replacingOccurrences(of: " ", with: ""))}
                    
                }
                return self.tempMusicList

            }
        }
        set{
            self.originalMusicList = newValue
        }
    }
    

    
    
    func playThisList(){
        print("play : \(self.listName)")
        AppManager.default.appData.playingList = self.listName
        AppManager.default.musicListManager.setMusicList(newList: self.musicList)
    }
    
    @Published var needJumpTo : Int? = nil
    
    
    func jumpToMusic(name: String){
        
        guard let index = self.musicList.firstIndex(where: { $0.name == name }) else { return }
        self.needJumpTo = index
        
    }
    
    
    func jumpToCurrentMusic(){

        self.jumpToMusic(name: AppManager.default.musicListManager.getCurrentMusic().name)
        
        
    }
    
    
    
}
