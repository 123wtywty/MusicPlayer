//
//  ViewableMusicListManager.swift
//  MusicPlayer
//
//  Created by Gary Wu on 2020-04-30.
//  Copyright © 2020 Gary Wu. All rights reserved.
//

import Foundation


class ViewableMusicListManager: ObservableObject{
    
    static func makeSpecialList(listName: String) -> ViewableMusicListManager{
        if listName == "All Music"{
            let Vlist = ViewableMusicListManager()
            Vlist.Mlist.listName = "All Music"
            Vlist.Mlist.isSpecialList = true
            for path in AppManager.default.appData.avaliblePath{
                Vlist.Mlist.list += GetMusicFromFolder(path: path)
            }
            return Vlist
            
        }else if listName == "Favorite Music"{
            let Vlist = ViewableMusicListManager()
            Vlist.Mlist.listName = "Favorite Music"
            Vlist.Mlist.isSpecialList = true
            for path in AppManager.default.appData.avaliblePath{
                Vlist.Mlist.list += GetMusicFromFolder(path: path)
            }
            Vlist.Mlist.list = Vlist.Mlist.list.filter {music -> Bool in
                music.isFavorite
            }
            
            return Vlist
        }else{
            return ViewableMusicListManager()
        }

    }
    
    static func makeFromPath(path: String) -> ViewableMusicListManager{
        
        
        
        let Vlist = ViewableMusicListManager()
        Vlist.Mlist.listName = "\(URL(fileURLWithPath: path).lastPathComponent)"
 
        Vlist.Mlist.folderPath = path
        Vlist.Mlist.list = GetMusicFromFolder(path: path)
        
        return Vlist
    }
    
    var Mlist : MusicList = MusicList()

    
    var needUpdateList : Bool = true
    
    var filterString : String = ""{
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
                return self.Mlist.list
            }else{
                if self.needUpdateList{
                    self.tempMusicList =
                        self.Mlist.list.filter
                        {$0.simplifiedchinese.REContains(str: filterString.replacingOccurrences(of: " ", with: ""))}
                    
                }
                return self.tempMusicList

            }
        }
    }
    

    
    
    func playThisList(){
        print("play : \(self.Mlist.listName)")
        AppManager.default.appData.playingList = self.Mlist.listName

        AppManager.default.playingMusicListManager.playableMusicList = PlayableMusicListManager(musicList: self.Mlist)
    }
    @Published var needJumpTo : Int? = nil
    
    
    func jumpToMusic(name: String){
        
        guard let index = self.musicList.firstIndex(where: { $0.name == name }) else { return }
        self.needJumpTo = index
        
    }
    
    
    func jumpToCurrentMusic(){

        self.jumpToMusic(name: AppManager.default.playingMusicListManager.playableMusicList.getCurrentMusic().name)
        
        
    }
    
    
    
}
