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
                                var allMusic : [Music] = []
                                for path in AppManager.default.appData.avaliblePath{
                                    allMusic.append(contentsOf: AppManager.default.getMusicFromFolder(path: path))
                                }
                                
                                allMusic.sort{ $0.name > $1.name }
                                AppManager.default.viewingMusicListManager.musicList = allMusic
                                self.showMusicList = true
                                
                            }
                            
                            VStack{
                                Text("Favorite Music")
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                            }.onTapGesture {
                                var allMusic : [Music] = []
                                for path in AppManager.default.appData.avaliblePath{
                                    allMusic.append(contentsOf: AppManager.default.getMusicFromFolder(path: path))
                                }
                                allMusic = allMusic.filter {music -> Bool in
                                    music.isFavorite
                                }
                                
                                allMusic.sort{ $0.name > $1.name }
                                AppManager.default.viewingMusicListManager.musicList = allMusic
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
                                    var allMusic : [Music] = AppManager.default.getMusicFromFolder(path: path)
                                    allMusic.sort{ $0.name > $1.name }
                                    AppManager.default.viewingMusicListManager.musicList = allMusic
                                    
                                    self.showMusicList = true
                                    
                                }
                                
                                
                                
                            }
                        }
                        
                    }
                    
                }
            }
            else{
                VStack{
                    
                    
                    
                    MusicListView()
                }
            }
            
            
        }
    }
}
