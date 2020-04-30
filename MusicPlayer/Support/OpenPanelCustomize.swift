//
//  OpenPanelCustomize.swift
//  MusicPlayer
//
//  Created by Gary Wu on 2020-04-30.
//  Copyright © 2020 Gary Wu. All rights reserved.
//

import Foundation
import SwiftUI
import Cocoa

class OpenPanelCustomize{
    private let panel = NSOpenPanel()
    private var completionHandler : (String)->() = {_ in
    }
    
    init() {
        panel.canChooseFiles = true
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
    }
    
    init(canChooseFiles : Bool, canChooseDirectories : Bool, allowsMultipleSelection : Bool) {
        panel.canChooseFiles = canChooseFiles
        panel.canChooseDirectories = canChooseDirectories
        panel.allowsMultipleSelection = allowsMultipleSelection
    }
    
    func openPanelCompletionHandler(completionHandler: @escaping (String) -> () ){
        print(#function)
        NSApp.activate(ignoringOtherApps: true)
        self.completionHandler = completionHandler
        
        
    }
    
    func start(){
        self.panel.begin { (result) in
            if result == .OK {
//                let path = self.panel.directoryURL?.path ?? ""
                let path = self.panel.url?.path ?? ""
                self.completionHandler(path)
            }
        }
    }
    
}
