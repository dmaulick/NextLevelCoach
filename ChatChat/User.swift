//
//  User.swift
//  ChatChat
//
//  Created by David Maulick on 11/14/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import Foundation
import Firebase

class User {
    
    let userId: String
    let username: String
    let firstName: String
    let lastName: String
    let sport: String
    let position: String
    let email: String
    let photoURL: URL?
    var groupKeys: [String]?
    let directChatKeys: [String]?
    
    /*
    init?(userId: String, ) {
        self.userId = userId
    }
    */
    
    init(snap: DataSnapshot) {
        let userDict = snap.value as! [String: AnyObject]
        
        self.userId = userDict["userId"] as! String
        self.username = userDict["username"] as! String
        self.firstName = userDict["firstName"] as! String
        self.lastName = userDict["lastName"] as! String
        self.sport = userDict["sport"] as! String
        self.position = userDict["position"] as! String
        self.email = userDict["email"] as! String
        self.photoURL = URL(string: userDict["photoURL"] as! String)
        
        groupKeys = [String]()
        directChatKeys = [String]()
        
        
        
    }
    
    /*init() {
        self.userId = "User did not get initialized"
        self.username = "User did not get initialized"
        self.firstName = "User did not get initialized"
        self.lastName = "User did not get initialized"
        self.sport = "User did not get initialized"
        self.position = "User did not get initialized"
        self.email = "User did not get initialized"
        self.photoURL = nil
        groupKeys = nil
        directChatKeys = nil
    }*/
    
    init(userId: String, username: String, firstName: String, lastName: String, sport: String, position: String,
         email: String, photoURL: URL) {
        
        self.userId = userId
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.sport = sport
        self.position = position
        self.email = email
        self.photoURL = photoURL
        
        groupKeys = [String]()
        directChatKeys = [String]()
    }
    
    init(userId: String, username: String, firstName: String, lastName: String, sport: String, position: String,
         email: String, photoURL: URL, groupKeys: [String], directChatKeys: [String]) {
        
        self.userId = userId
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.sport = sport
        self.position = position
        self.email = email
        self.photoURL = photoURL
        
        self.groupKeys = groupKeys
        self.directChatKeys = directChatKeys
    }
    
}
