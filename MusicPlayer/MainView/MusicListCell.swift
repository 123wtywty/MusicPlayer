//
//  MusicListCell.swift
//  MusicPlayer
//
//  Created by Gary Wu on 2020-04-30.
//  Copyright © 2020 Gary Wu. All rights reserved.
//

import SwiftUI
import NotificationCenter

struct MusicListCell: View {
    
    init(cellId : Int = -1) {
        self.cellId = cellId
    }
    
    @EnvironmentObject var data : MusicWrapper
    var music : Music { self.data.music ?? Music.placeHolder }
    
    var cellId = -1
    @State var onTap = false
    @State var onHover = false
    
    var body: some View {
        
        return
            VStack{
                ZStack{
                    
                    HStack{
                        Image(nsImage: self.music.cover)
                            .resizable()
                            .frame(width: 100, height: 57) // old: 65, 57 = 100 * 9 /16
                            .cornerRadius(7)
                        
                        GeometryReader{ g in
                            
                            HStack{
                                
                                Text(self.music.name)
                                    .frame(minWidth: 80, idealWidth: .none, maxWidth: .none, minHeight: 57, idealHeight: 57, maxHeight: 57)
                                    .foregroundColor(.black)
                                
                                Spacer()
                                if g.size.width > 150{
                                    
                                    VStack{
                                        
                                        Text("\(self.music.playCount)")
                                            .foregroundColor(.black)
                                        Button(action:{
                                            withAnimation{
                                                self.music.isFavorite.toggle()
                                            }
                                            
                                        }){
                                            Text(self.music.isFavorite ? "􀊵" : "􀊴")
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .colorScheme(.light)
                                    .animation(.default)
                                    
                                }
                                
                            }
                        }
                        
                        
                        Spacer()
                        
                    }
                    
                    // background
                    VStack{
                        AppManager.default.musicListManager.getCurrentMusic() == self.music ?
                            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.blue.opacity(0.15)]), startPoint: .top, endPoint: .bottom)
                                .opacity(0.5)
                                .cornerRadius(8)
                            :
                            
                            LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.01)]), startPoint: .top, endPoint: .bottom)
                                .opacity(0.5)
                                .cornerRadius(8)
                        
                        
                    }
                    
                    
                    // play next
                    HStack{
                        Spacer()
                        VStack{
                            if self.onHover && !(self.cellId >= 1){
                                Button(action:{
                                    //                                MusicList.shared.playList.append(self.music)
                                }){
                                    Text("play next")
                                }
                                .colorScheme(.light)
                                
                            }
                            else{
                                Text("").hidden()
                            }
                            Spacer()
                            
                        }
                    }
                    
                    
                }
                    
                .onHover(perform: { (isHover) in
                    self.onHover = isHover
                })
                    
                    
                    .onTapGesture {
                        if self.cellId >= 1{
                            self.onTap.toggle()
                        }else{
                            AppManager.default.viewingMusicListManager.playThisList()
                            
                            AppManager.default.musicPlayer.playMusic(music: self.music)
                        }
                        print("\(self.music.name) tap, cellId: \(self.cellId), tap: \(self.onTap)")
                }
                    
                    
                    
                
                
                Divider()
//                    .padding(.top, 2)
//                    .foregroundColor(Color.white.opacity(0.5))
                    .foregroundColor(Color.black)
                    .colorScheme(.light)
        }
            .padding(0)
            .cornerRadius(9)
            .frame(width: .none, height: .none)
    }
    
    
    
}
