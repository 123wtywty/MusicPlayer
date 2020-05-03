//
//  AutoCloseWindow.swift
//  MusicPlayer
//
//  Created by Gary Wu on 2020-04-30.
//  Copyright © 2020 Gary Wu. All rights reserved.
//

import Foundation
import Cocoa

protocol AutoCloseWindow { }
extension AutoCloseWindow where Self: NSWindowController{
    func autoCloseWindow(){
        
        if (self.window?.occlusionState.rawValue != 8194) && self.window?.isVisible ?? false{
            print("close")
            self.window?.performClose(nil)
            
        }
    }
    
}
