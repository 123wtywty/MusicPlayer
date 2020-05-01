//
//  ViewableMusicListManager.swift
//  MusicPlayer
//
//  Created by Gary Wu on 2020-04-30.
//  Copyright © 2020 Gary Wu. All rights reserved.
//

import Foundation


class ViewableMusicListManager: ObservableObject{
    
    var listName: String = ""
    var needUpdate : Bool = true
    var musicList : [Music] = []{
        didSet{
            self.needUpdate = true
            DispatchQueue.main.async {
                self.objectWillChange.send()
                
            }
        }
    }

    
    
    func playThisList(){
        
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
