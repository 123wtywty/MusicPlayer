//
//  MusicListOverViewData.swift
//  MusicPlayer
//
//  Created by Gary Wu on 2020-06-14.
//  Copyright © 2020 Gary Wu. All rights reserved.
//

import Foundation


class MusicListOverViewData{
    
    var name = "root"
    
    var subBlock : [MusicBlock] = []
    
    init() {
        
    }
    
    func addSubBlock(block: MusicBlock){
        self.subBlock.append(block)
    }
    
    
}


class MusicBlock: Identifiable{
    var id = UUID()
    
    var name: String
    var subList : [SingleMusicList] = []
    
    init(name: String) {
        self.name = name
    }
    
    func addSubList(list: SingleMusicList){
        self.subList.append(list)
    }
    
}

class SingleMusicList: Identifiable{
    var id = UUID()
    
    var name: String = ""
    var getMusicList: ()->ViewableMusicListManager
    
    init(name: String, action: @escaping ()->ViewableMusicListManager) {
        self.name = name
        self.getMusicList = action
    }
    
    
}
