//
//  ViewingMusicListManager.swift
//  MusicPlayer
//
//  Created by Gary Wu on 2020-04-30.
//  Copyright © 2020 Gary Wu. All rights reserved.
//

import Foundation


class ViewableMusicListManager: ObservableObject{
    
    var listName: String = ""
    var musicList : [Music] = []{
        didSet{
//            self.musicList.sort{ $0.name > $1.name }
            print("need update ui")
            DispatchQueue.main.async {
                self.objectWillChange.send()
                
            }
        }
    }

    
    
    func playThisList(){
        
        AppManager.default.appData.playingList = self.listName
        AppManager.default.musicListManager.setMusicList(newList: self.musicList)
    }
    
}
