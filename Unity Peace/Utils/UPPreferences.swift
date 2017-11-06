//
//  UPPreferences.swift
//  Unity Peace
//
//  Created by bsingh9 on 06/11/17.
//  Copyright © 2017 com. All rights reserved.
//

import UIKit

class UPPreferences {
    
    fileprivate static let TUTORIAL_SHOWN_KEY = "TUTORIAL_SHOWN_KEY"
    fileprivate static let LOGIN_KEY = "LOGIN_KEY"
    fileprivate let RECOMMENDATION_ON_KEY = "RECOMMENDATION_ON_KEY"
    fileprivate let DISPLAY_NAME_KEY = "DISPLAY_NAME_KEY"
    fileprivate let PHONE_KEY  = "PHONE_KEY"
    fileprivate let PAN_KEY = "PAN_KEY"
    fileprivate let DEPOSITORY_KEY = "DEPOSITORY_KEY"
    fileprivate let DPID_KEY = "DPID_KEY"
    fileprivate let CLIENT_ID_KEY = "CLIENT_ID_KEY"
    fileprivate let SYNC_KEY = "SYNC_KEY"
    fileprivate let EMAIL_KEY = "EMAIL_KEY"
    fileprivate let USER_IMAGE_KEY = "USER_IMAGE_KEY"
    fileprivate let SAVED_NEWS_KEY = "SAVED_NEWS_KEY"
    fileprivate let ID_TOKEN_KEY = "ID_TOKEN_KEY"
    fileprivate let ACCESS_TOKEN_KEY = "ACCESS_TOKEN_KEY"
    
    static let sharedInstance = UPPreferences()
    fileprivate var userDefaults: UserDefaults!
    
    fileprivate init() {
        self.userDefaults = UserDefaults()
    }
    
    func isTutorialShown () -> Bool {
        return self.userDefaults.bool(forKey: UPPreferences.TUTORIAL_SHOWN_KEY)
    }
    
    func setTutorialShown () {
        self.userDefaults.set(true, forKey: UPPreferences.TUTORIAL_SHOWN_KEY)
    }
    
    func isLoggedIn () -> Bool {
        return self.userDefaults.bool(forKey: UPPreferences.LOGIN_KEY)
    }
    
    func setLoggedIn (status : Bool) {
        if status {
            self.userDefaults.set(status, forKey: UPPreferences.LOGIN_KEY)
        }else {
            self.userDefaults.removeObject(forKey: UPPreferences.LOGIN_KEY)
        }
    }
    
    func isRecomendationOn () -> Bool {
        return self.userDefaults.bool(forKey: RECOMMENDATION_ON_KEY)
    }
    
    func setRecommendation (on : Bool) {
        self.userDefaults.set(on, forKey: RECOMMENDATION_ON_KEY)
    }
    
    func displayName() ->  String? {
        return self.userDefaults.string(forKey: DISPLAY_NAME_KEY)
    }
    
    func setDisplayName (name : String) {
        self.userDefaults.set(name, forKey: DISPLAY_NAME_KEY)
    }

    func phoneNumber() ->  String? {
        return self.userDefaults.string(forKey: PHONE_KEY)
    }
    
    func setPhoneNumber (number : String) {
        self.userDefaults.set(number, forKey: PHONE_KEY)
    }

    func panNumber() ->  String? {
        return self.userDefaults.string(forKey: PAN_KEY)
    }
    
    func setPANNumber (number : String) {
        self.userDefaults.set(number, forKey: PAN_KEY)
    }
    
    func depository() ->  String? {
        return self.userDefaults.string(forKey: DEPOSITORY_KEY)
    }
    
    func setDepository (name : String) {
        self.userDefaults.set(name, forKey: DEPOSITORY_KEY)
    }
    
    func dpidNumber() ->  String? {
        return self.userDefaults.string(forKey: DPID_KEY)
    }
    
    func setDPID (number : String) {
        self.userDefaults.set(number, forKey: DPID_KEY)
    }

    func clientID() ->  String? {
        return self.userDefaults.string(forKey: CLIENT_ID_KEY)
    }
    
    func setClientID (number : String) {
        self.userDefaults.set(number, forKey: CLIENT_ID_KEY)
    }

    
    func syncType() ->  Int {
        return self.userDefaults.integer(forKey: SYNC_KEY) 
    }
    
    func setSynType (type : Int) {
        self.userDefaults.set(type, forKey: SYNC_KEY)
    }

    func email() ->  String? {
        return self.userDefaults.string(forKey: EMAIL_KEY)
    }
    
    func setEmail (email : String) {
        self.userDefaults.set(email, forKey: EMAIL_KEY)
    }

    func imageURL() ->  String? {
        return self.userDefaults.string(forKey: USER_IMAGE_KEY)
    }
    
    func setImageURL (urlString : String?) {
        self.userDefaults.set(urlString, forKey: USER_IMAGE_KEY)
    }

    func setSavedNews (news : [[String : Any?]]) {
        self.userDefaults.set(news, forKey: SAVED_NEWS_KEY)
    }
    
    func saveNews(news : [String : Any?]) {
        var savedNews = self.savedNews()
        let filteredItems = savedNews.filter { (item) -> Bool in
            return item["id"] as? String == news["id"] as? String
        }
        if filteredItems.count > 0 {
            return
        }else {
            savedNews.append(news)
            self.userDefaults.set(savedNews, forKey: SAVED_NEWS_KEY)
        }
    }
    
    func savedNews () -> [[String : Any?]] {
        if let news = userDefaults.value(forKey: SAVED_NEWS_KEY) as? [[String : Any?]] {
            return news
        }
        return []
    }
    
    func idToken() ->  String? {
        return self.userDefaults.string(forKey: ID_TOKEN_KEY)
    }
    
    func setIdToken (token : String) {
        self.userDefaults.set(token, forKey: ID_TOKEN_KEY)
    }
    
    func accessToken() ->  String? {
        return self.userDefaults.string(forKey: ACCESS_TOKEN_KEY)
    }
    
    func setAccessToken (token : String) {
        self.userDefaults.set(token, forKey: ACCESS_TOKEN_KEY)
    }

    
    func clearAll() {
        self.userDefaults.removeObject(forKey: UPPreferences.TUTORIAL_SHOWN_KEY)
        self.userDefaults.removeObject(forKey: UPPreferences.LOGIN_KEY)
        self.userDefaults.removeObject(forKey: RECOMMENDATION_ON_KEY)
        self.userDefaults.removeObject(forKey: DISPLAY_NAME_KEY)
        self.userDefaults.removeObject(forKey: PHONE_KEY)
        self.userDefaults.removeObject(forKey: PAN_KEY)
        self.userDefaults.removeObject(forKey: DEPOSITORY_KEY)
        self.userDefaults.removeObject(forKey: DPID_KEY)
        self.userDefaults.removeObject(forKey: CLIENT_ID_KEY)
        self.userDefaults.removeObject(forKey: SYNC_KEY)
        self.userDefaults.removeObject(forKey: EMAIL_KEY)
        self.userDefaults.removeObject(forKey: USER_IMAGE_KEY)
        self.userDefaults.removeObject(forKey: SAVED_NEWS_KEY)
        self.userDefaults.removeObject(forKey: ACCESS_TOKEN_KEY)
        self.userDefaults.removeObject(forKey: ID_TOKEN_KEY)

    }
    
}
