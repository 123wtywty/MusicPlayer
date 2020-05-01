//
//  Buttons.swift
//  MusicPlayer
//
//  Created by Gary Wu on 2020-04-30.
//  Copyright © 2020 Gary Wu. All rights reserved.
//

import Foundation
import SwiftUI

extension ContentView{
    func DownloaderOpenButton()  -> some View {
        Button(action: {
            //            DownloadMainWindow.shared.showWindow(nil)
            NSApp.activate(ignoringOtherApps: true)
        }){
            Text("open DownLoader")
        }
    }
    
    func PlayButton()  -> some View {
        
        Button(action:{
            AppManager.default.musicPlayer.player.play()
        }){
            Text("Play")
            
        }
        
    }
    
    func PauseButton()  -> some View {
        
        Button(action:{
            AppManager.default.musicPlayer.player.pause()
        }){
            Text("pause")
        }
        
    }
    
    fileprivate func repeatShuffleStatusText() -> Text{
        switch AppManager.default.appData.repeatShuffleStatus {
        case .shuffle:
            return Text("􀊝")
        case .repeat:
            return Text("􀊞")
        case .repeat_1:
            return Text("􀊟")
        }
    }
    
    
    func ChangeRepeatShuffleStatusButton()  -> some View {
        
        Button(action: {
            switch AppManager.default.appData.repeatShuffleStatus {
            case .shuffle:
                AppManager.default.appData.repeatShuffleStatus = .repeat
            case .repeat:
                AppManager.default.appData.repeatShuffleStatus = .repeat_1
            case .repeat_1:
                AppManager.default.appData.repeatShuffleStatus = .shuffle
            }
        }){
            self.repeatShuffleStatusText()
        }
        
    }
    
    
    func NextButton()  -> some View {
        
        Button(action: {
            AppManager.default.musicPlayer.playMusicAccordingToSetting()
        }){
            Text("Next")
            
        }

    }
    
    
    
    func QuitButton()  -> some View {
        
        Button( action: {
            NSApplication.shared.terminate(nil)
        }
        ){
            Text("Quit")
        }
        
    }
}
