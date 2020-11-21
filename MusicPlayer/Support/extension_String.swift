//
//  extension_String.swift
//  MusicPlayer
//
//  Created by Gary Wu on 2020-11-21.
//  Copyright © 2020 Gary Wu. All rights reserved.
//

import Foundation

extension String{
    func transformToPinyin() -> String {
        let stringRef = NSMutableString(string: self) as CFMutableString
        // 转换为带音标的拼音
        CFStringTransform(stringRef,nil, kCFStringTransformToLatin, false);
        // 去掉音标
        CFStringTransform(stringRef, nil, kCFStringTransformStripCombiningMarks, false);
        let pinyin = stringRef as String;
     
        return pinyin
    }
    
    func transformToPinyinWithoutBlank() -> String {
        var pinyin = self.transformToPinyin()
        // 去掉空格
        pinyin = pinyin.replacingOccurrences(of: " ", with: "")
        return pinyin
    }
    
}
