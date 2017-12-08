//
//  Team.swift
//  ChatChat
//
//  Created by David Maulick on 11/28/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import Foundation

class Team {
    let teamId: String
    let teamName: String
    let teamPW: String
    let teamPhoto: UIImage
    
    /*
    init(teamId: String, teamName: String, teamPW: String) {
        self.teamId = teamId
        self.teamName = teamName
        self.teamPW = teamPW
        
        self.teamPhoto = nil
    }
    */
    
    init(teamId: String, teamName: String, teamPW: String, teamPhoto: UIImage) {
        self.teamId = teamId
        self.teamName = teamName
        self.teamPW = teamPW
        self.teamPhoto = teamPhoto
    }
}
