//
//  PathsViewCell.swift
//  MusicPlayer
//
//  Created by Gary Wu on 2020-04-30.
//  Copyright © 2020 Gary Wu. All rights reserved.
//

import Foundation
import SwiftUI

struct PathsViewCell: View {
    
    var path: String
    var isAvailable : Bool
    
    var body: some View {
        HStack{
            Text(path)
                .strikethrough(!self.isAvailable, color: .gray)
            Spacer()
            
            Button(action:{
                if AppManager.default.appData.blockedPath.contains(self.path){
                    AppManager.default.appData.blockedPath.removeAll { (str) -> Bool in
                        str == self.path
                    }
                }
                else{
                    AppManager.default.appData.blockedPath.append(self.path)
                }
                
            }){
                Text("Block")
            }
            
            Button(action:{
                AppManager.default.appData.selectingPath.removeAll { (p) -> Bool in
                    p == self.path
                }
            }){
                Text("remove")
            }
        }
        
    }
}
