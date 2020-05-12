//
//  MusicDataManager.swift
//  MusicPlayer
//
//  Created by Gary Wu on 2020-05-12.
//  Copyright © 2020 Gary Wu. All rights reserved.
//

import Foundation


class MusicDataManager{
    static let shared = MusicDataManager()
    
    public var musicDataDidChangedHandle : [String : ()->()] = [:]
    
    private func runHandles(){
        for handle in musicDataDidChangedHandle.values{
            handle()
        }
    }
    
    private let musicDataBaseManager = MusicDataBaseManager()
    
    
    func getAllMusicData() -> [MusicDataStruct]{
//        print(musicDataBaseManager.readData())
        return musicDataBaseManager.readData()
    }
    
    func getDataFor(musicName: String) -> MusicDataStruct?{
        
        self.getAllMusicData().first { $0.name == musicName }
    }
    
    func addMusicData(data: MusicDataStruct){
        musicDataBaseManager.addData(data: data)
        
        self.runHandles()
    }
    
    func updateMusicData(musicName: String, newV: MusicDataStruct){
        musicDataBaseManager.removeData(musicName: musicName)
        musicDataBaseManager.addData(data: newV)
        
        self.runHandles()
    }
    
    
    
}
