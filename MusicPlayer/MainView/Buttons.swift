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
    
    func PlayButton()  -> some View {
        
        Button(action:{
            AppManager.default.playingMusicListManager.musicPlayer.player.play()
        }){
            Text("Play")
            
        }
        
    }
    
    func PauseButton()  -> some View {
        
        Button(action:{
            AppManager.default.playingMusicListManager.musicPlayer.player.pause()
        }){
            Text("pause")
        }
        
    }
    
    func PlayPauseButton() -> some View {
        Button(action:{
            if (self.data.isPlaying){
                AppManager.default.playingMusicListManager.musicPlayer.player.pause()
            }
            else{
                AppManager.default.playingMusicListManager.musicPlayer.player.play()
            }
        }){
            Text("\(self.data.isPlaying ? "􀊅" : "􀊃")")
                .frame(width: 20.0)
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
            AppManager.default.playingMusicListManager.musicPlayer.playMusicAccordingToSetting()
        }){
//            Text("Next")
            Text("􀊋")
            
        }
        
    }
    
    
    
    func QuitButton()  -> some View {
        
        Button( action: {
            AppManager.default.terminate()
        }
        ){
            Text("Quit")
        }
        
    }
    
    func restartButton()  -> some View {
        
        Button( action: {
            AppManager.default.restart()
        }
        ){
            Text("Restart")
        }
        
    }
    
    
    func AddPathButton()  -> some View {
        Button(action:{
            let panel = OpenPanelCustomize()
            panel.openPanelCompletionHandler { path in
                
                AppManager.default.appData.selectingPath.append(path)
            }
            panel.start()
            
        }){
            Text("add path")
        }
        
    }
    
    func changeTextStyle() -> some View{
        Button(action:{
            if self.textStyle == 0{
                self.textStyle = 1
            }else{
                self.textStyle = 0
            }
        }){
            Text(self.textStyle == 0 ? "􀉁" : "not 􀉁")

            
        }
    }
    
    
    func playerFullWindow() -> some View{
        Button(action:{
//            AppManager.default.appData.playerFullWindow = true
            self.data.playerFullWindow = true
        }){
//            Text("Full")
            Text("􀅊")
        }
    }
    
    func StayOnTopButton() -> some View{
        Button(action:{
            MainWindowViewWindowController.shared.stayOnTop.toggle()
        }){
            Text("\(self.data.stayOnTop ? "􀱄" : "􀰿")")
//            Text("stayOnTop")
        }
        
        
    }
    
    
}
