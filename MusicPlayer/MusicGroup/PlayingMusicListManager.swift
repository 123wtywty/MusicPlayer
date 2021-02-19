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
    private var playableMusicList : PlayableMusicListManager
    
    private var _musicPlayer : MusicPlayer
    
    var musicPlayer : MusicPlayer{
        _musicPlayer
    }
    
    init(playableMusicList : PlayableMusicListManager) {
        self.playableMusicList = playableMusicList
        self._musicPlayer = MusicPlayer(player: AVPlayer(), playableMusicList: self.playableMusicList)
    }
    
    func changeMusicListTo(musicList: PlayableMusicListManager){
        self.playableMusicList.Mlist.list.map({$0.isInPlayingList = false})
        
        for m in musicList.Mlist.list{
            m.isInPlayingList = true
            m.currentPlayCount = 0.0
        }
        self.playableMusicList = musicList
        
        self.musicPlayer.changeMusicList(musicList: musicList)
    }
}
