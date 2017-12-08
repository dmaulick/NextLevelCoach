//
//  AddNewsPickGroupVC.swift
//  ChatChat
//
//  Created by David Maulick on 11/19/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit
import Firebase

class AddNewsPickGroupVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    var currentTeamForAPP: Team?
    
    var user: User?
    var GroupKeysOfCurrentUser: [String]?
    var GroupNamesOfCurrentUser: [String]?
    
    var groupKeysOfCurrentTeam: [String]?
    var groupNamesOfCurrentTeam: [String]?
    var curRowSelection: Int?
    
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var makeEventWarningLabel: UILabel!
    
    // MARK: View life cycles --------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeEventWarningLabel.alpha = 0.0
        if groupNamesOfCurrentTeam == nil || groupNamesOfCurrentTeam!.count == 0 {
            makeEventWarningLabel.alpha = 1.0
            makeEventWarningLabel.text = "No groups to add an event to!"
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func AddEventButton(_ sender: Any) {
        if groupNamesOfCurrentTeam != nil && groupNamesOfCurrentTeam!.count != 0 {
            performSegue(withIdentifier: "addEventSegue", sender: nil)
        }
        else {
            makeEventWarningLabel.alpha = 1.0
            makeEventWarningLabel.text = "To add an event, create a group in chat Section!"
        }
    }
    
    @IBAction func AddAnnounceButton(_ sender: Any) {
        
        makeEventWarningLabel.alpha = 1.0
        makeEventWarningLabel.text = "Announcements are not available in this version of the app."
    }
    
    // MARK: UI Picker Datasource -----------------------------------------
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if GroupKeysOfCurrentUser?.count != GroupNamesOfCurrentUser?.count {
            print("HUGEEE Warning!!: size of GroupKeysOfCurrentUser and GroupNamesOfCurrentUser are not the same!!")
        }
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
        
        if segue.identifier == "addEventSegue" {
            let addVC = segue.destination as! AddEventVC
            let selectedChannelName = groupNamesOfCurrentTeam![curRowSelection!]
            let selectedChannelKey = groupKeysOfCurrentTeam![curRowSelection!]
            
            addVC.user = self.user
            addVC.ChannelGroupName = selectedChannelName
            addVC.ChannelGroupKey = selectedChannelKey
            addVC.currentTeamForAPP = self.currentTeamForAPP
        }
    }
 

}
