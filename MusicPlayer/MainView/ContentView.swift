//
//  ContentView.swift
//  MusicPlayer
//
//  Created by Gary Wu on 2020-04-28.
//  Copyright © 2020 Gary Wu. All rights reserved.
//

import SwiftUI

let defaultWidth = CGFloat(640)
let defaultHeight = CGFloat(530)

struct ContentView: View {
    
    @ObservedObject var data = AppManager.default.appData
    
    var body: some View {
        
        return GeometryReader{ g in
            
            if g.size.width <= 401 && g.size.height <= 226{ // small window
                PlayerUIView()
                    .frame(width: 400, height: 225, alignment: .center) // 225 = 400 * 9 /16
                    .cornerRadius(8)
            }else{
                HStack{
                    
                    
                    VStack{
                        
                        VStack(alignment: .center, spacing: 20){
                            PlayerUIView()
                                .frame(width: 400, height: 225, alignment: .center) // 225 = 400 * 9 /16
                                .cornerRadius(8)
                                .padding()
                            
                            
                            Text(self.data.playingMusic.displayeMusicName)
                                .frame(width: 400, height: .none)
                                .padding()
                            
                            VStack(alignment: .center, spacing: 20){
                                HStack(spacing: 20){
                                    
                                    self.PlayButton()
                                    
                                    self.PauseButton()
                                    
                                    self.NextButton()
                                    
                                    
                                }
                                HStack(spacing: 20){
                                    self.ChangeRepeatShuffleStatusButton()
                                    
                                    self.restartButton()
                                    
                                    self.QuitButton()
                                    
                                }
                                HStack(spacing: 20){
                                    self.AddPathButton()
                                    
                                }
                                
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
                            .animation(.default)
                            .cornerRadius(8)
                            
                            .frame(width: g.size.width > 430 ? g.size.width - 430 : 0
                                   , height: .none)
                        
                        
                        
                        
                        
                    }
                    
                    .frame(width: g.size.width > 430 ? g.size.width - 430 : 0
                           , height: .none)
                    
                    .animation(nil)
                }
                .animation(nil)
            }
            
            
        }
    }
}
