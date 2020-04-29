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
    func make(name: String, url: URL, cover : NSImage?) -> Music
    func make(name: String, urlString: String, cover : NSImage?) -> Music
    
}

class MusicMaker: IMusicMaker{
    
    var cachedMusic = Dictionary< String , Music >()
    
    func musicExist(name: String) -> Bool {
        self.cachedMusic[name] != nil
    }
    
    
    func make(name: String, url: URL, cover: NSImage?) -> Music {
        if let m = self.cachedMusic[name]{
            return m
        }
        else{
            self.cachedMusic[name] = Music(name: name, url: url, cover: cover)
            return self.cachedMusic[name]!
        }
    }
    
    func make(name: String, urlString: String, cover: NSImage?) -> Music {
        self.make(name: name, url: URL(fileURLWithPath: urlString), cover: cover)
    }
    
    
    
    
}
