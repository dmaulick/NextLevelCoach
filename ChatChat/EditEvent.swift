//
//  ProfileVC.swift
//  NextLevelCoach
//
//  Created by David Maulick on 10/7/17.
//  Copyright © 2017 mau8. All rights reserved.
//

import UIKit

class EditEvent: UIViewController, UITextFieldDelegate {
    
    // TO DO:
    // NEED to change this class to an event view
    // TO DO^

    var groupNameFromTable : String?
    var groupDescriptionFromTable : String?
    var newAnnouncementFromTable : String?
    var newChatMessageFromTable : String?
    var profilePicFromTable: UIImage?
    var indexPressed: Int?
    
    @IBOutlet weak var profileNameTexfield: UITextField!
    @IBOutlet weak var GroupDescriptionTexfield: UITextField!
    @IBOutlet weak var newMessageTexfield: UITextField!
    @IBOutlet weak var newAnnounceTexfield: UITextField!
    @IBOutlet weak var profilePic: UIImageView!
    
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileNameTexfield.text = groupNameFromTable
        GroupDescriptionTexfield.text = groupDescriptionFromTable
        
        newMessageTexfield.text = newChatMessageFromTable
        newAnnounceTexfield.text = newAnnouncementFromTable
        
        
        //profilePic.layer.borderWidth = 3.0
        //profilePic.layer.borderColor = CGColor.black
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //inputLabel.text = textfield.text
        textField.resignFirstResponder()
        return true
        
    }
    
    // MARK: - Navigation


    
    
    
    
    
    // To bring back to save edits
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "saveEdit" {
            print("hereeeee")
            let destVC = segue.destination as? GroupTableView
            
            let newProfile = GroupProfile(groupName: profileNameTexfield.text!, groupDescription: GroupDescriptionTexfield.text!, newAnnouncement: newAnnounceTexfield.text!, newChatMessage: newMessageTexfield.text!)
                
                //groupName: "fieldOne", groupDescription: "fieldTwo", newAnnouncement: true, newChatMessage: false)
            
            print(newProfile.groupName + newProfile.groupDescription + newProfile.newAnnouncement + newProfile.newChatMessage)
            
                                          
      
          
            
            destVC?.editGroupArray(newGroupProfile: newProfile, indexToEdit: indexPressed!)
            
        }
        
    }*/
    

}
