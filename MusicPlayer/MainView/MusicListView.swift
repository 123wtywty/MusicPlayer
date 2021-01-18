//
//  MusicListView.swift
//  MusicPlayer
//
//  Created by Gary Wu on 2021-01-17.
//  Copyright © 2021 Gary Wu. All rights reserved.
//


import Foundation
import SwiftUI


struct MusicListView : View{
    @ObservedObject var data = AppManager.default.viewingMusicListManager
    
    var body: some View{
        ScrollViewReader { proxy in
            VStack {

                List {
                    ForEach(data.musicList, id:\.self) { i in
//                        Text("\(i.displayeMusicName)")
//                            .id(i.name)
                        
                        MusicListCell().environmentObject(i.wrapper)
                            .id(i.name)
                    }
                }
            }.onChange(of: self.data.needJumpTo) { (_) in
                if let index = self.data.needJumpTo{
                    withAnimation{
                        proxy.scrollTo(index)
                        
                    }
                    self.data.needJumpTo = nil
                }
            }
        }
    }
}
    
