//
//  Music.swift
//  MusicPlayer
//
//  Created by Gary Wu on 2020-04-29.
//  Copyright © 2020 Gary Wu. All rights reserved.
//

import Foundation
import Cocoa

protocol IMusic {
    init(name: String, url: URL)
    var name : String { get }
    var displayeMusicName: String { get }
    var pinyin : String { get }
    var url : URL { get }
    var playCount : Int { get set}
    var likeDegree : Int { get set }
    var type : MusicType { get }

    var wrapper : MusicWrapper { get }

}


fileprivate let loadingImage = NSImage(named: NSImage.Name("loading"))!


class Music: IMusic, Equatable, Hashable{
    static func == (lhs: Music, rhs: Music) -> Bool {
        lhs.name == rhs.name && lhs.url == rhs.url
    }
    
    static public let placeHolder = Music(name: "placeHolder", url: Bundle.main.url(forResource: "placeHolder", withExtension: "mp4")!)
    
    var finishInit = false
    required init(name: String, url: URL) {
        self.name = name
        
        self.pinyin = name.transformToPinyinWithoutBlank().lowercased()
                
        let sChinese = name.simplifiedchinese
        self.simplifiedchinese = sChinese
        
        let i = sChinese.lastIndex(of: "-") ?? sChinese.lastIndex(of: ".") ?? sChinese.endIndex
        self.displayeMusicName = String(sChinese[..<i])
        
        self.url = url
        
        self.playCount = 0
        self.likeDegree = 0
        
        self.wrapper = MusicWrapper(id: self.name + self.url.path)
        self.wrapper.music = self
        
        self.finishInit = true
    }
    
    deinit {
        print("music : \(self.name) deinit")
    }
    
    
    var name: String
    var displayeMusicName: String
    var pinyin : String
    var simplifiedchinese : String
    var url: URL
    
    var playCount: Int{
        didSet{
            if !self.finishInit { return }
            self.save()
            self.wrapper.update()
        }
    }
    
    var likeDegree: Int
        {
        didSet{
            if !self.finishInit { return }
            print("likeDegree change, \(self.name)")
            self.wrapper.update()
            StatusBarView.shared.update_like_StatusItem()
            self.save()
        }
    }
    
    var likeDegreeSymbol: String{
        Configuration.likeDegreeSymbol(self.likeDegree, sf: false)
    }
    var likeDegreeSymbol_SF: String{
        Configuration.likeDegreeSymbol(self.likeDegree, sf: true)
    }
    
    func likeDegreeAddOne(){
        self.likeDegree += 1
        if self.likeDegree == 3 {self.likeDegree = 0}
    }
    
    var isInPlayingList : Bool = false
    var currentPlayCount : Double = 0.0
    var realCurrentPlayCount : Int = 0
    
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
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.name)
        hasher.combine(self.url)
    }
    
    func save(){
        if !self.finishInit { return }
        
        MusicDataManager.shared.addMusicData(data: MusicDataStruct(name: self.name, likeDegree: self.likeDegree, playCount: Double(self.playCount)))
    }
    
    func update(data: MusicDataStruct?){
        guard let d = data else {
            return
        }
        
        self.finishInit = false
        
        if self.likeDegree != d.likeDegree{
            self.likeDegree = d.likeDegree
        }
        if self.playCount != Int(d.playCount){
            self.playCount = Int(d.playCount)
        }
        self.finishInit = true
        
    }
    
}
