//
//  PathsView.swift
//  MusicPlayer
//
//  Created by Gary Wu on 2020-04-30.
//  Copyright © 2020 Gary Wu. All rights reserved.
//

import Foundation
import SwiftUI

struct PathsView: View{
    @ObservedObject var data = AppManager.default.appData
    
    var body: some View{
        
        VStack{
            
            List(self.data.selectingPath, id:\.self){ path in
                PathsViewCell(path: path, isAvailable: !AppManager.default.appData.blockedPath.contains(path))
                
            }
            .animation(.easeInOut)
            .colorMultiply(Color.init(.sRGB, white: 1 - 0.03, opacity: 1))
            .cornerRadius(10)
            
            HStack{
                Spacer()
                Button(action:{
                    let panel = OpenPanelCustomize()
                    panel.openPanelCompletionHandler { path in
                        self.data.selectingPath.append(path)
                    }
                    panel.start()
                    
                }){
                    Text("add path")
                }
            }
            
        }
        .padding()
    }
}
