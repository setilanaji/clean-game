//
//  ProfileModel.swift
//  Clean Game
//
//  Created by Yudha Setyaji on 2021/12/9.
//

import Foundation

struct ProfileModel {
    static let userNameKey = "name"
    static let userImageKey = "image"
    static let userEmailKey = "email"
    
    static var userName: String {
        get {
            return UserDefaults.standard.string(forKey: userNameKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: userNameKey)
        }
    }
    
    static var userImage: String {
        get {
            return UserDefaults.standard.string(forKey: userImageKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: userImageKey)
        }
    }
    
    static var userEmail: String {
        get {
            return UserDefaults.standard.string(forKey: userEmailKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: userEmailKey)
        }
    }
    
    static func deteleAll() -> Bool {
        if let domain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: domain)
            synchronize()
            return true
        } else { return false }
    }
    
    static func synchronize() {
        UserDefaults.standard.synchronize()
    }
}
