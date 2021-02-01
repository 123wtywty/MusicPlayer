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
    @ObservedObject var data2 = AppManager.default.appData
    @State private var filterString : String = ""
    
    @Binding var showState : Int
    var body: some View{
        
        
        VStack{
            
            
            HStack{
                Text("􀆉")
                    .padding([.leading, .top])
                    .onTapGesture {
                        withAnimation{
                            self.showState = 0
                        }
                        
                    }
                Spacer()
                Text("\(AppManager.default.viewingMusicListManager.Mlist.listName)  #\(AppManager.default.viewingMusicListManager.Mlist.count)")
                    .font(.subheadline)
                    .background(AppManager.default.viewingMusicListManager.Mlist.listName == AppManager.default.appData.playingList.listName ?
                                    Color.blue.opacity(0.15).cornerRadius(5)
                                    : Color.white.cornerRadius(5))
                    .padding([.top, .trailing])
                
                
                
                Spacer()
            }
            HStack{
                Button(action:{
                    AppManager.default.viewingMusicListManager.playThisList()
                }){
                    Text("􀊃")
                }
                .padding(.leading, 10.0)
                .padding(.trailing, 1.0)
                Spacer()
                
                TextField("", text: Binding<String>(get: {
                    self.filterString
                }, set: {
                    self.filterString = $0
                    AppManager.default.viewingMusicListManager.filterString = self.filterString
                })
                )
                .padding(.trailing)
                
            }
            
            ZStack(alignment: .bottomTrailing){
                VStack(spacing: 0){
                    ScrollViewReader { proxy in
                        
                        List {
                            ForEach(data.musicList, id:\.self) { i in
                                
                                MusicListCell().environmentObject(i.wrapper)
                                    .id(i.name)
                                    .animation(.none)
                                
                            }
                            
                            //                            .border(Color.gray, width: 2)
                            .listRowInsets(.init())
                            
                        }
                        //                        .border(Color.blue, width: 3)
                        
                        .onChange(of: self.data.needJumpTo) { (_) in
                            if let index = self.data.needJumpTo{
                                
                                for i in 0...2{
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 * Double(i)) {
                                        proxy.scrollTo(index)
                                    }
                                }
                                

                                //                                for i in 0...5{
                                //                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 * Double(i)) {
                                //                                        withAnimation{
                                //                                            proxy.scrollTo(index)
                                //                                        }
                                //                                    }
                                //                                }
                                self.data.needJumpTo = nil
                                
                            }
                        }
                        
                    }
                }
                if (AppManager.default.viewingMusicListManager.currentMusicExistInThisList()){
                    ScrollToRowButton()
                }
            }
        }
        .animation(.default)
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
