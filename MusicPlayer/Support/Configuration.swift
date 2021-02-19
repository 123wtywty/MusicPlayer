//
//  Configuration.swift
//  MusicPlayer
//
//  Created by Gary Wu on 2021-02-18.
//  Copyright © 2021 Gary Wu. All rights reserved.
//

import Foundation


struct Configuration {
    
    static func likeDegreeSymbol(_ degree: Int, sf: Bool = false) -> String{
        switch degree {
        case 0:
            return sf ? "star" : "􀋂"
        case 1:
            return sf ? "star.leadinghalf.fill" : "􀋄"
        case 2:
            return sf ? "star.fill" : "􀋃"
            
            
        default:
            return sf ? "star" : "􀋂"
        }
    }
}


