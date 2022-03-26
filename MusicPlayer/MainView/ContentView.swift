//
//  ContentView.swift
//  MusicPlayer
//
//  Created by Gary Wu on 2020-04-28.
//  Copyright © 2020 Gary Wu. All rights reserved.
//

import SwiftUI
import AVKit

let defaultWidth = CGFloat(640)
let defaultHeight = CGFloat(530)

struct ContentView: View {
    
    @ObservedObject var data = AppManager.default.appData
    
    @State var textStyle = 0

    
    var body: some View {
        
        return GeometryReader{ g in
            
            if self.data.playerFullWindow{ // small window
                VideoPlayer(player: AppManager.default.playingMusicListManager.musicPlayer.player)
                    .frame(width: g.size.width, height: g.size.height, alignment: .center)
                    .cornerRadius(8)
            }else{
                HStack{
                    
                    
                    VStack{
                        
                        VStack(alignment: .center, spacing: 20){
                            VideoPlayer(player: AppManager.default.playingMusicListManager.musicPlayer.player)
                                .frame(width: 400, height: 225, alignment: .center) // 225 = 400 * 9 /16
                                .cornerRadius(8)
                                .padding()
                            if self.textStyle == 0{
                                Text(self.data.playingMusic.displayeMusicName)
                                    .frame(width: 400, height: 20)
                                    .padding()
                                
                            }else if self.textStyle == 1{
                                
                                TextField("", text: .constant(self.data.playingMusic.displayeMusicName))
                                    .frame(width: 400, height: 20)
                                    .padding()
                            }
                            
                            HStack{
                                Spacer()
                                
                                VStack(alignment: .center, spacing: 20){
                                HStack(spacing: 20){
                                    
                                    self.PlayPauseButton()
                                    
                                    self.NextButton()
                                    
                                    self.ChangeRepeatShuffleStatusButton()
                                    
                                }
                                HStack(spacing: 20){
                                    self.changeTextStyle()

                                    self.playerFullWindow()

                                    self.AddPathButton()
                                    
                                }
                                HStack(spacing: 20){
                                    self.StayOnTopButton()

                                    self.restartButton()
                                    
                                    self.QuitButton()
                                    
                                }
                                
                            }
                                
                                Spacer()

                                SubView1(music: self.data.playingMusic)
                                    .environmentObject(self.data.playingMusic.wrapper)
                                
                                Spacer()

                            }
                            
                        }.frame(width: 400, height: .none)
                        .padding()
                        
                        Spacer()
                        
                        if g.size.height > 500{
                            PathsView()
                        }
                        
                    }
                    
                    
                    .frame(width: 430, height: g.size.height)
                    
                    
                    
                    
                    
                    
                    VStack{
                        
                        MusicListOverView()
//                            .animation(Animation.default, value: nil)
                            .cornerRadius(8)
                            .frame(width: g.size.width > 430 ? g.size.width - 430 : 0
                                   , height: .none)
                        

                    }
                    .frame(width: g.size.width > 430 ? g.size.width - 430 : 0
                           , height: .none)
                    
//                    .animation(nil, value: nil)
                }
//                .animation(nil)
            }
            
            
        }
        
    }
}


struct SubView1: View {
    var music: Music

    @EnvironmentObject var warpper : MusicWrapper
    var body: some View{
        VStack(alignment: .center, spacing: 20){
            Text("\(Int(music.realCurrentPlayCount))")
                .foregroundColor(.black)
            
//            Text("\(Int(music.currentPlayCount))")
//                .foregroundColor(.black)
            
            Button(action:{
                withAnimation{
                    music.likeDegreeAddOne()
//                                            self.needUpdate.toggle()
                }
                
            }){
                Text(music.likeDegreeSymbol)
                    .foregroundColor(.gray)
            }

        }
    }
    
}
