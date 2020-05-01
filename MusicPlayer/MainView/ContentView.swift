//
//  ContentView.swift
//  MusicPlayer
//
//  Created by Gary Wu on 2020-04-28.
//  Copyright © 2020 Gary Wu. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HStack{
            VStack{
                PlayerUIView()
                    .frame(width: 400, height: 225, alignment: .center) // 225 = 400 * 9 /16
                    .cornerRadius(8)
                    .padding()
                
                
                
                
                PathsView()
            }
//            MusicListView()
            MusicListOverView()

        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
