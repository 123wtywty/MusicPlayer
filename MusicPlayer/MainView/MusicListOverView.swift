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
    @State private var showState = 0
    @State private var filterString : String = ""
    
    var body: some View{
        
        GeometryReader{ geo in
            
            
            if self.showState == 0{
                VStack{
                    
                    List{
                        
                        ForEach(AppManager.default.musicListOverViewData.subBlock){ block in
                            Section(header: Text(block.name)){
                                ForEach(block.subList){ list in
                                    VStack{
                                        Text(list.name)
                                            .font(.subheadline)
                                            .foregroundColor(.black)
                                    }.modifier(RowModifier(selected: list.name == AppManager.default.appData.playingList.listName))
                                    .onTapGesture {
                                        
                                        AppManager.default.viewingMusicListManager = list.getMusicList()
                                        
                                        self.showState = 1
                                    }
                                }
                            }
                        }
                        
                    }
                    
//                    .animation(nil)
                    
                }
            }
            
            else if self.showState == 1{
                MusicListView(showState: self.$showState)
                    .background(Color.white)
            }
            
            
            
        }
//        .padding(.trailing, 20)
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


