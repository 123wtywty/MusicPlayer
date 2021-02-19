//
//  MusicList.swift
//  MusicPlayer
//
//  Created by Gary Wu on 2020-11-26.
//  Copyright © 2020 Gary Wu. All rights reserved.
//

import Foundation


class MusicList{
    private static var defaultSortFunc : (Music, Music) -> Bool = { $0.name < $1.name }

    
    static func makeSpecialList(listName: String) -> MusicList{
        if listName == "All Music"{
            let Mlist = MusicList()
            Mlist.listName = "All Music"
            Mlist.isSpecialList = true
            for path in AppManager.default.appData.avaliblePath{
                Mlist.list += GetMusicFromFolder(path: path)
            }
            Mlist.list.sort(by: MusicList.defaultSortFunc)
            return Mlist
            
        }else if listName == "Favorite Music"{
            let Mlist = MusicList()
            Mlist.listName = "Favorite Music"
            Mlist.isSpecialList = true
            for path in AppManager.default.appData.avaliblePath{
                Mlist.list += GetMusicFromFolder(path: path)
            }
            Mlist.list = Mlist.list.filter {music -> Bool in
                music.likeDegree > 0
            }
            Mlist.list.sort(by: MusicList.defaultSortFunc)
            return Mlist
        }else{
            return MusicList()
        }

    }
    
    static func makeFromPath(path: String) -> MusicList{
        
        let Mlist = MusicList()
        Mlist.listName = "\(URL(fileURLWithPath: path).lastPathComponent)"
 
        Mlist.folderPath = path
        Mlist.list = GetMusicFromFolder(path: path)
        Mlist.list.sort(by: MusicList.defaultSortFunc)
        return Mlist
    }
    
    
    
    
    var listName : String = ""
    var folderPath : String? = nil
    var isSpecialList : Bool = false
    var list : [Music] = []
    
    private var _count : Int = -1
    private func getCount(){
        self._count = self.list.count
    }
    var count : Int{
        get{
            if self._count == -1{
                self.getCount()
            }
            return self._count
        }
    }
    
}
