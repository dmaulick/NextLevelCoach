//
//  ProfileVC.swift
//  NextLevelCoach
//
//  Created by David Maulick on 10/7/17.
//  Copyright © 2017 mau8. All rights reserved.
//

import UIKit
import Firebase

class AddEventVC: UIViewController, UITextFieldDelegate {
    
    var user: User?
    var ChannelGroupName: String?
    var ChannelGroupKey: String?
    
    @IBOutlet weak var newTitleTextField: UITextField!
    @IBOutlet weak var newDescriptionTextField: UITextField!
    @IBOutlet weak var newWhatToWearField: UITextField!
    
    
    private lazy var EventRef: DatabaseReference = Database.database().reference().child("Events")
    private lazy var GroupEventKeysRef: DatabaseReference = Database.database().reference().child("GroupEventKeys")
    private var EventRefHandle: DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newTitleTextField.text = ChannelGroupKey
        newDescriptionTextField.text = ChannelGroupName
        newWhatToWearField.text = ""
        
        
        
        
        //profilePic.layer.borderWidth = 3.0
        //profilePic.layer.borderColor = CGColor.black
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    // Mark: ----------------------------------------------------------------
    
    
    @IBAction func createEvent(_ sender: AnyObject) {
        if newTitleTextField?.text != "",
            newDescriptionTextField?.text != "",
            newWhatToWearField?.text != ""
            {
                let title = newTitleTextField?.text
                let description = newDescriptionTextField?.text
                let whatToWear = newWhatToWearField?.text
                
                let EventItem = [
                    "title"         : title,
                    "description"   : description,
                    "whatToWear"    : whatToWear,
                    "ChannelName"   : self.ChannelGroupName,
                    "ChannelKey"    : self.ChannelGroupKey
                ]
                let newEventRef = EventRef.childByAutoId()
                newEventRef.setValue(EventItem)
                
                
                let groupEventItem = [
                    "ChannelName" : self.ChannelGroupName,
                    "ChannelKey": self.ChannelGroupKey,     // Link to actual group in groups
                    "EventKey"  : newEventRef.key           // Link to actual event in events
                    
                
                ]
                let newGroupEventKey = GroupEventKeysRef.childByAutoId()
                newGroupEventKey.setValue(groupEventItem)
                
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //inputLabel.text = textfield.text
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Navigation --------------------------------------Navigation---------------------------------------------------------Navigation
    
    // Unwind segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addFromAddView" { // for the save segue
            print("add group")
            
            
            /*let destVC = segue.destination as? GroupTableView
            let newProfile = GroupProfile(groupName: profileNameTexfield.text!, groupDescription: GroupDescriptionTexfield.text!, newAnnouncement: newAnnounceTexfield.text!, newChatMessage: newMessageTexfield.text!)
            //groupName: "fieldOne", groupDescription: "fieldTwo", newAnnouncement: true, newChatMessage: false)
            print(newProfile.groupName + newProfile.groupDescription + newProfile.newAnnouncement + newProfile.newChatMessage)
            destVC?.addToGroupArray(newGroupProfile: newProfile)
            */
            
            
            if let title = newTitleTextField?.text,
                let description = newTitleTextField?.text,
                let whatToWear = newDescriptionTextField?.text {
                //let startTime = newStartTimeField?.text,
                //let endTime = newEndTimeField?.text {
                
                let newEventRef = EventRef.childByAutoId()
                let EventItem = [
                    
                    "title"     : title,
                    "descript"  :description,
                    "whatToWear":whatToWear
                ]
                newEventRef.setValue(EventItem)
            }
            
        }
        
    }
 
    
}

