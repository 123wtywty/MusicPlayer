//
//  extension_AVPlayer.swift
//  MusicPlayer
//
//  Created by Gary Wu on 2020-04-30.
//  Copyright © 2020 Gary Wu. All rights reserved.
//

import Foundation
import AVKit

extension AVPlayer {
    var isPlaying: Bool {
//        return rate != 0 && error == nil
//        self.timeControlStatus == .playing
        self.timeControlStatus != .paused
    }
    
    @objc dynamic var playToEnd: Bool {
        guard let totalTime = self.currentItem?.duration else {
            return false
        }
        return self.currentTime().seconds >= (totalTime.seconds - 0.1)
    }
}

