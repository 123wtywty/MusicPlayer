//
//  MusicManager.swift
//  MusicPlayer
//
//  Created by Gary Wu on 2020-04-29.
//  Copyright © 2020 Gary Wu. All rights reserved.
//

import Foundation

fileprivate protocol IMusicManager {
    func GetAllMusic() -> [Music]
    func GetMusicByFolderName() -> [(String, [Music])]
}


class MusicManager{
    

}
