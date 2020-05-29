//
//  GetMusicFromQQMusicList.swift
//  MusicPlayer
//
//  Created by Gary Wu on 2020-05-28.
//  Copyright © 2020 Gary Wu. All rights reserved.
//

import Foundation
func GetMusicFromQQMusicList(filePath: String) -> [Music]{
    let allM = (try? FileManager.default.contentsOfDirectory(atPath: "/Users/gary/Music/QQ音乐")) ?? []
    
    let str = (try? String(contentsOfFile: filePath)) ?? ""
    let l = str.split(separator: "\n")
//    print(l)
    
    var musicList : [Music] = []
    
    for i in l{
        let start = i.firstIndex(of: "-") ?? i.startIndex
        var end = i.lastIndex(of: "(") ?? i.endIndex
        if start > end{
            end = i.endIndex
        }
        if let path = allM.containsString(str: String(i[start..<end])){
            
            let m = AppManager.default.musicMaker.make(name: String(i[start...]), urlString: "/Users/gary/Music/QQ音乐/\(path)", cover: nil)
            musicList.append(m)
        }else{
            print("not exist: \(i)")
        }
    }
    
    
    return musicList
}



extension Array where Element == String{
    func containsString(str: String) -> String?{
        for i in self{
            if i.contains(str){
                return i
            }
        }
        return nil
    }
}

