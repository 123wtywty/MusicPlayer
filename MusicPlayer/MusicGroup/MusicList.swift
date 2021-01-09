//
//  MusicList.swift
//  MusicPlayer
//
//  Created by Gary Wu on 2020-11-26.
//  Copyright © 2020 Gary Wu. All rights reserved.
//

import Foundation


class MusicList{
    var listName : String = ""
    var folderPath : String? = nil
    var isSpecialList : Bool = false
    var list : [Music] = []
    
    private var _count : Int = -1
    private func getCount(){
        self._count = self.list.count
    }
    var count : Int{
        get{
            if self._count == -1{
                self.getCount()
            }
            return self._count
        }
    }
    
}
