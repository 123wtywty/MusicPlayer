//
//  MusicPlayer.swift
//  MusicPlayer
//
//  Created by Gary Wu on 2020-04-29.
//  Copyright © 2020 Gary Wu. All rights reserved.
//

import Foundation
import AVFoundation

fileprivate protocol IMusicPlayer {
    init(player: AVPlayer)
    var player: AVPlayer { get set }

    func playSong(name: String)
    func playSong(music: Music)
    
    func playNextSong()
    
    func playRandomSong()
    
    
}


class MusicPlayer{
    init(player: AVPlayer){
        
    }
}
