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
    
    var currentTeamForAPP: Team?
    
    var user: User?
    var ChannelGroupName: String?
    var ChannelGroupKey: String?
    var dateFormatter = DateFormatter()
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var newTitleTextField: UITextField!
    @IBOutlet weak var newDescriptionTextField: UITextField!
    @IBOutlet weak var newWhatToWearField: UITextField!

    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func titleClicked(_ sender: Any) {
        newTitleTextField.text = ""
    }
    @IBAction func descriptionClicked(_ sender: Any) {
        newDescriptionTextField.text = ""
    }
    @IBAction func whatToWearClicked(_ sender: Any) {
        newWhatToWearField.text = ""
    }
    
    private lazy var EventRef: DatabaseReference = Database.database().reference().child("Events")
    private lazy var GroupEventKeysRef: DatabaseReference = Database.database().reference().child("GroupEventKeys")
    private var EventRefHandle: DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        
        titleLabel.text = "Create an event to be added to \(String(describing: ChannelGroupName!))"
        newTitleTextField.text = "Event Title"
        newDescriptionTextField.text = "Event Description"
        newWhatToWearField.text = "What to Wear"
        
        
        
        
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
                let date = datePicker.date
                
                let EventItem = [
                    "title"         : title,
                    "description"   : description,
                    "whatToWear"    : whatToWear,
                    "ChannelName"   : self.ChannelGroupName,
                    "ChannelKey"    : self.ChannelGroupKey,
                    "Date"          : dateFormatter.string(from: date)
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

