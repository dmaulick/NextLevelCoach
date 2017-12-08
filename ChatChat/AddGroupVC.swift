//
//  AddGroupVC.swift
//  ChatChat
//
//  Created by David Maulick on 12/1/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit
import Firebase

class AddGroupVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    private lazy var userGroupKeysRef: DatabaseReference = Database.database().reference().child("userGroupKeys")
    
    
    var currentTeamForAPP: Team?
    
    var user: User?
    
    var groupKeysOfCurrentTeam: [String]?
    var groupNamesOfCurrentTeam: [String]?
    var curRowSelection: Int?
    
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var findGroupWarningLabel: UILabel!
    
    // MARK: View life cycles --------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        findGroupWarningLabel.alpha = 0.0
        if groupNamesOfCurrentTeam == nil || groupNamesOfCurrentTeam!.count == 0 {
            findGroupWarningLabel.alpha = 1.0
            findGroupWarningLabel.text = "No groups in current team!"
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func AddGroupButton(_ sender: Any) {
        
        if groupNamesOfCurrentTeam != nil && groupNamesOfCurrentTeam!.count != 0 {
            if let groupNameToAdd = groupNamesOfCurrentTeam![curRowSelection!] as String?,
                let groupKeyToAdd = groupKeysOfCurrentTeam![curRowSelection!] as String?{
                
                
                let userNewGroupKey = userGroupKeysRef.childByAutoId()
                let actualUser = user!
                
                let userGroupKeyItem = [
                    "userId"    : actualUser.userId,
                    "channelId" : groupKeyToAdd,
                    "GroupName" : groupNameToAdd
                    
                ]
                
                
                userNewGroupKey.setValue(userGroupKeyItem)
                performSegue(withIdentifier: "addGroupUnwind", sender: nil)
                
            }
        }
        else {
            findGroupWarningLabel.alpha = 1.0
            findGroupWarningLabel.text = "No groups, create group in previous page!"
        }
        
        
    
        
    }

    
    
    // MARK: UI Picker Datasource -----------------------------------------
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return groupNamesOfCurrentTeam!.count
    }
    
    
    // MARK: - UIPickerViewDelegate Methods
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        curRowSelection = row
        return self.groupNamesOfCurrentTeam?[row]
    }

    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        /*if segue.identifier == "addEventSegue" {
            let addVC = segue.destination as! AddEventVC
            let selectedChannelName = groupNamesOfCurrentTeam![curRowSelection!]
            let selectedChannelKey = groupKeysOfCurrentTeam![curRowSelection!]
            
            addVC.user = self.user
            addVC.ChannelGroupName = selectedChannelName
            addVC.ChannelGroupKey = selectedChannelKey
            addVC.currentTeamForAPP = self.currentTeamForAPP
        }*/
    }

}
