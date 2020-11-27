//
//  MusicListManager.swift
//  MusicPlayer
//
//  Created by Gary Wu on 2020-11-26.
//  Copyright © 2020 Gary Wu. All rights reserved.
//

import Foundation
import AVKit

class PlayingMusicListManager{
    var playableMusicList : PlayableMusicListManager{
        didSet{
            self.musicPlayer.playableMusicList = self.playableMusicList
        }
    }
    var musicPlayer : MusicPlayer
    
    init(playableMusicList : PlayableMusicListManager) {
        self.playableMusicList = playableMusicList
        self.musicPlayer = MusicPlayer(player: AVPlayer(), playableMusicList: self.playableMusicList)
    }
}
