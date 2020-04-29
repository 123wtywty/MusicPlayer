//
//  MusicWrapper.swift
//  MusicPlayer
//
//  Created by Gary Wu on 2020-04-29.
//  Copyright © 2020 Gary Wu. All rights reserved.
//

import Foundation
import SwiftUI

fileprivate protocol IMusicWrapper {
    var id : String { get }
    var music : Music? { get set }
    
    init(id : String)
    func update()
}

class MusicWrapper: IMusicWrapper, ObservableObject, Identifiable{
    
    var id: String
    weak var music: Music?
    
    required init(id : String){
        self.id = id
        self.music = nil
    }
    
    func update() {
        objectWillChange.send()
    }
    
    
}
