//
//  GroupProfile.swift
//  NextLevelCoach
//
//  Created by David Maulick on 10/7/17.
//  Copyright © 2017 mau8. All rights reserved.
//

import UIKit

class GroupProfile : NSObject, NSCoding {
   
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("savedGroups")
    
    var groupName: String
    var groupDescription: String
    var newChatMessage: String
    var newAnnouncement: String

    init(groupName: String, groupDescription: String) {
        self.groupName = groupName
        self.groupDescription = groupDescription
        newChatMessage = "false"
        newAnnouncement = "false"
    }
    
    init(groupName: String, groupDescription: String, groupPic: UIImage) {
        self.groupName = groupName
        self.groupDescription = groupDescription
        newChatMessage = "false"
        newAnnouncement = "false"
    }
    
    init(groupName: String, groupDescription: String, newAnnouncement: String, newChatMessage: String) {
        self.groupName = groupName
        self.groupDescription = groupDescription
        self.newAnnouncement = newAnnouncement
        self.newChatMessage = newChatMessage
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        groupName = aDecoder.decodeObject(forKey: "groupName") as! String
        groupDescription = aDecoder.decodeObject(forKey: "groupDescription") as! String
        newChatMessage = aDecoder.decodeObject(forKey: "newChatMessage") as! String
        newAnnouncement = aDecoder.decodeObject(forKey: "newAnnouncement") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(groupName, forKey: "groupName")
        aCoder.encode(groupDescription, forKey: "groupDescription")
        aCoder.encode(newChatMessage, forKey: "newChatMessage")
        aCoder.encode(newAnnouncement, forKey: "newAnnouncement")
    }
    
    
    
}
