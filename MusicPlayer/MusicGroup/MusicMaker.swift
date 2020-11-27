//
//  MusicMaker.swift
//  MusicPlayer
//
//  Created by Gary Wu on 2020-04-29.
//  Copyright © 2020 Gary Wu. All rights reserved.
//

import Foundation
import Cocoa

fileprivate protocol IMusicMaker {
    
    func musicExist(name : String) -> Bool
    func make(name: String, url: URL) -> Music
    func make(name: String, urlString: String) -> Music
    
}

class MusicMaker: IMusicMaker{
    
    var cachedMusic = Dictionary< String , Music >()
    
    func musicExist(name: String) -> Bool {
        self.cachedMusic[name] != nil
    }
    
    
    func make(name: String, url: URL) -> Music {
        if let m = self.cachedMusic[name]{
            m.update(data: MusicDataManager.shared.getDataFor(musicName: name))
            return m
        }
        else{
            let m = Music(name: name, url: url)
            m.update(data: MusicDataManager.shared.getDataFor(musicName: name))
            self.cachedMusic[name] = m
            return self.cachedMusic[name]!
        }
    }
    
    func make(name: String, urlString: String) -> Music {
        self.make(name: name, url: URL(fileURLWithPath: urlString))
    }
    
    
    
    
}
