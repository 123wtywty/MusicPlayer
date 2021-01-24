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

        let Vlist = ViewableMusicListManager()
        Vlist.Mlist = MusicList.makeSpecialList(listName: listName)
        return Vlist

    }
    
    static func makeFromPath(path: String) -> ViewableMusicListManager{
        
        let Vlist = ViewableMusicListManager()
        Vlist.Mlist = MusicList.makeFromPath(path: path)
        return Vlist
    }
    
    var Mlist : MusicList = MusicList()

    
    private var needUpdateList : Bool = true
    
    var filterString : String = ""{
        didSet{
            self.needUpdateList = true
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
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
        AppManager.default.appData.playingList = self.Mlist

        AppManager.default.playingMusicListManager.changeMusicListTo(musicList: PlayableMusicListManager(musicList: self.Mlist))
        
        if !currentMusicExistInThisList(){
            AppManager.default.playingMusicListManager.musicPlayer.playMusicAccordingToSetting()
        }
    }
    
    @Published var needJumpTo : String? = nil
    
    func musicExistInThisList(name: String) -> Bool{
        self.musicList.contains(where: { $0.name == name })
    }
    
    func jumpToMusic(name: String){
        
        if self.musicExistInThisList(name: name){
            self.needJumpTo = name
            
        }else{
            self.needJumpTo = nil
        }
        
    }
    
    func currentMusicExistInThisList() -> Bool{
        self.musicExistInThisList(name: AppManager.default.appData.playingMusic.name)
        
    }
    
    
    func jumpToCurrentMusic(){

        self.jumpToMusic(name: AppManager.default.appData.playingMusic.name)
        
        
    }
    
    
    
}
