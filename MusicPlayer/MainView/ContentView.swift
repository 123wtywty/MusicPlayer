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

            HStack{
                
                    
            VStack{
                
                VStack(alignment: .center, spacing: 20){
//                    Text("\(g.size.width), \(g.size.height)")
                    PlayerUIView()
                        .frame(width: 400, height: 225, alignment: .center) // 225 = 400 * 9 /16
                        .cornerRadius(8)
                        .padding()
                    
                    Text(self.data.playingMusicName)
                        .frame(width: 400, height: .none)
                        .padding()
                    
                    VStack(alignment: .center, spacing: 20){
                        HStack(spacing: 20){
                            
                            self.PlayButton()
                            
                            self.PauseButton()
                            
                            
                            
                        }
                        HStack(spacing: 20){
                            self.ChangeRepeatShuffleStatusButton()
                            
                            self.NextButton()
                            
                            self.QuitButton()
                        }
                        HStack(spacing: 20){
                            self.DownloaderOpenButton()
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
                    .frame(width: (defaultWidth - 430) + (g.size.width - defaultWidth), height: .none)
                    
                
                
                
                
            }
            .frame(width: (defaultWidth - 430) + (g.size.width - defaultWidth),
                   height: g.size.height)
                
                .animation(nil)
        }
        .animation(nil)
        
        }
    }
}
