//
//  AppData.swift
//  MusicPlayer
//
//  Created by Gary Wu on 2020-04-29.
//  Copyright © 2020 Gary Wu. All rights reserved.
//

import Foundation
import SwiftUI

class AppData: ObservableObject{
    
    @Published var playingList : String = ""
    @Published var playingMusic : Music = Music.placeHolder
    
    @Published var repeatShuffleStatus : Repeat_Shuffle_Status = .shuffle
    
    @Published var playerFullWindow : Bool = false
    
    var selectingPath : [String] = []{
        didSet{
            AppManager.default.setUpMusicListOverViewData()
            self.objectWillChange.send()
            
        }
    }
    
    var blockedPath : [String] = []{
        didSet{
            AppManager.default.setUpMusicListOverViewData()
            self.objectWillChange.send()
            
        }
    }
    
    var avaliblePath : [String]{
        get{
            var path : [String] = []
            for i in self.selectingPath{
                if !self.blockedPath.contains(i){
                    path.append(i)
                }
            }
            
            return path
        }
    }
    

    
}
