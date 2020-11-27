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
    
    func getAllSingleMusicList() -> [BaseMusicList]{
        self.subBlock.flatMap{$0.subList}
    }
    
}


class MusicBlock: Identifiable{
    var id = UUID()
    
    var name: String
    var subList : [BaseMusicList] = []
    
    init(name: String) {
        self.name = name
    }
    
    func addSubList(list: BaseMusicList){
        self.subList.append(list)
    }
    
}

class BaseMusicList: Identifiable, Equatable{
    static func == (lhs: BaseMusicList, rhs: BaseMusicList) -> Bool {
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
