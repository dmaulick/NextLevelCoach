//
//  EditTeamVC.swift
//  ChatChat
//
//  Created by David Maulick on 11/28/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit
import Firebase

class EditTeamVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var teamKeysOfCurrentUser: [String] = [String]()
    var teamNameOfCurrentUser: [String] = [String]()
    private lazy var TeamsofCurrenUserRef: DatabaseReference = Database.database().reference().child("userToTeamKeys")
    
   
    @IBOutlet weak var pickerView: UIPickerView!
    
    
    var user: User? {
        didSet {
            //let tempUser = self.user
            print("aaAAaaA")
            
        }
    }
    
    @IBOutlet weak var editTeamWarningLabel: UILabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        editTeamWarningLabel.alpha = 0.0
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateTeamKeysOfCurrentUser()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func editButton(_ sender: Any) {
        editTeamWarningLabel.alpha = 1.0
        editTeamWarningLabel.text = "Team editing is not available in this version of the app."
    }
    
    
    
    
    func updateTeamKeysOfCurrentUser() {
        if let userID = Auth.auth().currentUser?.uid {
            print("ay")
            TeamsofCurrenUserRef.observeSingleEvent(of: .value, with: { snapshot in
            
                for child in snapshot.children.allObjects as! [DataSnapshot] {
                    print("bay")
                    let teamsOfUserDict = child.value as! [String: String]
                
                    let curTeamID = teamsOfUserDict["TeamId"]
                    let curUserId = teamsOfUserDict["userId"]
                    let curTeamName = teamsOfUserDict["TeamName"]
                    if userID == curUserId {
                        print("YESSS")
                        self.teamKeysOfCurrentUser.append(curTeamID!)
                        self.teamNameOfCurrentUser.append(curTeamName!)
                    }
                }
                
                for val in self.teamKeysOfCurrentUser {
                    print(val)
                }
                self.pickerView.reloadAllComponents()
            })
        }
    }// return 1 return teamKeysOfCurrentUser.count return teamKeysOfCurrentUser[row]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return teamNameOfCurrentUser.count
    }
    
    // MARK: - UIPickerViewDelegate Methods
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return teamNameOfCurrentUser[row]
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
