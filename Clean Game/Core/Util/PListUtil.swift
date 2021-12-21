//
//  PListUtil.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/11/6.
//

import Foundation

struct PlistUtil {
    enum PlistType: String {
        case CleanGame = "CleanGame-Info"
    }
    
    static func getValueString(of key: String, from plist: PlistType) -> String? {
        guard let filePath = Bundle.main.path(forResource: plist.rawValue, ofType: "plist") else {
            return nil
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let link = plist?.object(forKey: key) as? String else {
            return nil
        }
        return link
    }
}
