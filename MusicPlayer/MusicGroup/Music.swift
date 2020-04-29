//
//  Music.swift
//  MusicPlayer
//
//  Created by Gary Wu on 2020-04-29.
//  Copyright © 2020 Gary Wu. All rights reserved.
//

import Foundation
import Cocoa

fileprivate protocol IMusic {
    init(name: String, url: URL, cover: NSImage?)
    var name : String { get }
    var url : URL { get }
    var playCount : Int { get set}
    var isFavorite : Bool { get set }
    var cover : NSImage? { get set }
    var type : MusicType { get }

    var wrapper : MusicWrapper { get }

}

class Music: IMusic, Equatable{
    static func == (lhs: Music, rhs: Music) -> Bool {
        lhs.name == rhs.name && lhs.url == rhs.url
    }
    
    static public let placeHolder = Music(name: "placeHolder", url: Bundle.main.url(forResource: "placeHolder", withExtension: "mp4")!, cover: nil)
    
    required init(name: String, url: URL, cover: NSImage?) {
        self.name = name
        self.url = url
        self.cover = cover
        
        self.playCount = 0
        self.isFavorite = false
        
        self.wrapper = MusicWrapper(id: self.name + self.url.path)
        self.wrapper.music = self
        
    }
    
    deinit {
        print("music : \(self.name) deinit")
    }
    
    
    var name: String
    
    var url: URL
    
    var playCount: Int
    
    var isFavorite: Bool
    
    var cover: NSImage?
    
    var type: MusicType{
        get{
            let URLPathExtension = self.url.pathExtension
            switch URLPathExtension {
            case "mp4":
                return .mp4
            case "mp3":
                return .mp3
            case "m4a":
                return .m4a
            default:
                return .other
            }
            
            
        }
    }
    
    var wrapper: MusicWrapper
    
    
}
