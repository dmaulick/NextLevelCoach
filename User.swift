//
//  User.swift
//  ChatChat
//
//  Created by David Maulick on 11/13/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import Foundation
import Firebase

class User {
    
    var firebaseUser: FirUser?
    
    init(firebaseUser: FirUser) {
        self.firebaseUser = firebaseUser
    }
    
}
