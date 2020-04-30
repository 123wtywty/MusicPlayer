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
                            }.onTapGesture {
                                let list = ViewableMusicListManager()
                                list.listName = "All Music"
                                for path in AppManager.default.appData.avaliblePath{
                                    list.musicList.append(contentsOf: AppManager.default.getMusicFromFolder(path: path))
                                }
                                
                                list.musicList.sort{ $0.name > $1.name }
                                AppManager.default.viewingMusicListManager = list
                                self.showMusicList = true
                                
                            }
                            
                            VStack{
                                Text("Favorite Music")
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                            }.onTapGesture {
                                let list = ViewableMusicListManager()
                                list.listName = "Favorite Music"
                                for path in AppManager.default.appData.avaliblePath{
                                    list.musicList.append(contentsOf: AppManager.default.getMusicFromFolder(path: path))
                                }
                                list.musicList = list.musicList.filter {music -> Bool in
                                    music.isFavorite
                                }
                                
                                list.musicList.sort{ $0.name > $1.name }
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
                                }
                                    
                                .onTapGesture {
                                    let list = ViewableMusicListManager()
                                    list.listName = "\(URL(fileURLWithPath: path).lastPathComponent)"
                                    list.musicList = AppManager.default.getMusicFromFolder(path: path)
                                    list.musicList.sort{ $0.name > $1.name }
                                    AppManager.default.viewingMusicListManager = list
                                    
                                    self.showMusicList = true
                                    
                                }
                                
                                
                                
                            }
                        }
                        
                    }
                    
                }
            }
            else{
                VStack{
                    
                    
                    HStack{
                        Text("􀆉 back")
                            .padding([.leading, .top])
                            .onTapGesture {
                                self.showMusicList = false
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
                    
                    
                    MusicListView()
                }
            }
            
            
        }
    }
}
