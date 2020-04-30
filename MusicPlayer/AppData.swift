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
    
    @Published var repeatShuffleStatus : Repeat_Shuffle_Status = .shuffle
    
    @Published var selectingPath : [String] = []
    @Published var blockedPath : [String] = []
    
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
