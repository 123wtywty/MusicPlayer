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
    
    func getAllSingleMusicList() -> [SingleMusicList]{
        self.subBlock.flatMap{$0.subList}
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

class SingleMusicList: Identifiable, Equatable{
    static func == (lhs: SingleMusicList, rhs: SingleMusicList) -> Bool {
        lhs.name == rhs.name
    }
    
    var id = UUID()
    
    var name: String = ""
    var getMusicList: ()->ViewableMusicListManager
    
    init(name: String, action: @escaping ()->ViewableMusicListManager) {
        self.name = name
        self.getMusicList = action
    }
    
    
}
