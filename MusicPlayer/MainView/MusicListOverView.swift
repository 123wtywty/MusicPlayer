//
//  MusicListOverView.swift
//  MusicPlayer
//
//  Created by Gary Wu on 2020-04-30.
//  Copyright © 2020 Gary Wu. All rights reserved.
//

import Foundation
import SwiftUI

struct MusicListOverView: View {
    
    @ObservedObject var paths = AppManager.default.appData
    @State var showMusicList = false
    
    var body: some View{
        
        HStack{
            
            if !self.showMusicList{
                VStack{
                    
                    
                    
                    List{
                        Section(header: Text("defaultList")){
                            VStack{
                                Text("All Music")
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                            }.modifier(RowModifier(selected: "All Music" == AppManager.default.appData.playingList))
                                
                            .onTapGesture {
                                let list = ViewableMusicListManager()
                                list.listName = "All Music"
                                for path in AppManager.default.appData.avaliblePath{
                                    print(path)
                                    list.musicList.append(contentsOf: AppManager.default.getMusicFromFolder(path: path))
                                }
                                
                                list.musicList.sort(by: AppManager.default.musicListManager.sortFunc)
                                AppManager.default.viewingMusicListManager = list
                                self.showMusicList = true
                                
                            }
                            
                            VStack{
                                Text("Favorite Music")
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                            }.modifier(RowModifier(selected: "Favorite Music" == AppManager.default.appData.playingList))
                            .onTapGesture {
                                let list = ViewableMusicListManager()
                                list.listName = "Favorite Music"
                                for path in AppManager.default.appData.avaliblePath{
                                    list.musicList.append(contentsOf: AppManager.default.getMusicFromFolder(path: path))
                                }
                                list.musicList = list.musicList.filter {music -> Bool in
                                    music.isFavorite
                                }
                                
                                list.musicList.sort(by: AppManager.default.musicListManager.sortFunc)
                                AppManager.default.viewingMusicListManager = list
                                self.showMusicList = true
                            }
                            
                            
                        }
                        
                        Section(header: Text("folder")) {
                            ForEach(AppManager.default.appData.avaliblePath, id: \.self){ path in
                                
                                
                                VStack{
                                    Text("\(URL(fileURLWithPath: path).lastPathComponent)")
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                }.modifier(RowModifier(selected: "\(URL(fileURLWithPath: path).lastPathComponent)" == AppManager.default.appData.playingList))
                                    
                                    .onTapGesture {
                                        let list = ViewableMusicListManager()
                                        list.listName = "\(URL(fileURLWithPath: path).lastPathComponent)"
                                        list.musicList = AppManager.default.getMusicFromFolder(path: path)
                                        list.musicList.sort(by: AppManager.default.musicListManager.sortFunc)
                                        AppManager.default.viewingMusicListManager = list
                                        
                                        self.showMusicList = true
                                        
                                }
                                
                                
                                
                            }
                        }
                        
                    }
                    .animation(.default)
                    
                }
            }
            else{
                VStack{
                    
                    
                    HStack{
                        Text("􀆉 back")
                            .padding([.leading, .top])
                            .onTapGesture {
                                withAnimation{
                                    self.showMusicList = false
                                }
                                
                        }
                        Spacer()
                        Text(AppManager.default.viewingMusicListManager.listName)
                            .font(.subheadline)
                            .background(AppManager.default.viewingMusicListManager.listName == AppManager.default.appData.playingList ?
                                Color.blue.opacity(0.15).cornerRadius(5)
                                : Color.white.cornerRadius(5))
                            .padding([.top, .trailing])
                        Spacer()
                    }
                    HStack{
                        Spacer()
                        Button(action:{
                            AppManager.default.viewingMusicListManager.playThisList()
                        }){
                            Text("play this list")
                        }
                    }
                    
                    ZStack(alignment: .bottomTrailing){
                        MusicListView()
                        ScrollToRowButton()
                        
                    }
                }
                .animation(.default)
            }
            
            
        }
    }
}


fileprivate struct RowModifier: ViewModifier {
    var selected : Bool
    func body(content: Content) -> some View{
        
        HStack{
            content
                .padding()
                
                .background(self.selected ? Color.blue.opacity(0.15) : Color.white)
                .cornerRadius(3)
            
        }
        
    }
    
    
}



fileprivate struct ScrollToRowButton: View{
    @State var isOnHover = false
    
    var body: some View{
        Text("􀐩")
            .frame(width: 40, height: 40)
            .padding()
            .font(.system(size: 30))
            .foregroundColor(.blue)
            .opacity(self.isOnHover ? 0.7 : 0.1)
            .animation(.easeInOut(duration: 0.5))
            .onHover { (isHover) in
                self.isOnHover = isHover
                
        }
        .onTapGesture {
            AppManager.default.viewingMusicListManager.jumpToCurrentMusic()
        }
    }
}
