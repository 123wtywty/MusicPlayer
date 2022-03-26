////
////  PlayerNSView.swift
////  MusicPlayer
////
////  Created by Gary Wu on 2020-04-30.
////  Copyright © 2020 Gary Wu. All rights reserved.
////
//
//import Foundation
//import AVKit
//
//class PlayerNSView: NSViewController {
//    static var firstInit_viewDidLoad = false
//    static var firstInit_loadView = false
//
//    var continuePlay : Bool = false
//    let player = AppManager.default.playingMusicListManager.musicPlayer.player
//    var playerView = AVPlayerView()
//
//    var doNotCountMusicPlayedTime = false
//
//    override func loadView() {
//        print(#function)
//        playerView.player = player
//
//
//        if !PlayerNSView.firstInit_loadView{
//            PlayerNSView.firstInit_loadView = true
//
//            playerView.allowsPictureInPicturePlayback = true
//            playerView.pictureInPictureDelegate = self
//            player.allowsExternalPlayback = false
////            playerView.showsFullScreenToggleButton = true
//            playerView.showsFullScreenToggleButton = true
//        }
//        self.view = playerView
//
//    }
//
//
//}
//
//
//extension PlayerNSView: AVPlayerViewPictureInPictureDelegate{
//
//    func playerViewWillStartPicture(inPicture playerView: AVPlayerView) {
//        print(#function)
//
//
//    }
//
//    func playerViewDidStopPicture(inPicture playerView: AVPlayerView) {
//        print(#function)
//
//    }
//}
//
