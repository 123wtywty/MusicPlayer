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
    @State private var showMusicList = false
    
    var body: some View{
        
        GeometryReader{ geo in
            
            
            if !self.showMusicList{
                VStack{
                    
                    List{
                        ForEach(AppManager.default.musicListOverViewData.subBlock){ block in
                            Section(header: Text(block.name)){
                                ForEach(block.subList){ list in
                                    VStack{
                                        Text(list.name)
                                            .font(.subheadline)
                                            .foregroundColor(.black)
                                    }.modifier(RowModifier(selected: list.name == AppManager.default.appData.playingList))
                                        .onTapGesture {
                                            
                                            AppManager.default.viewingMusicListManager = list.getMusicList()
                                            
                                            self.showMusicList = true
                                    }
                                }
                            }
                        }
                        
                    }

                        .animation(nil)
                    
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
                        .padding(.trailing)
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
