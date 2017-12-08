//
//  FindTeamVC.swift
//  ChatChat
//
//  Created by David Maulick on 11/28/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit
import Firebase

class FindTeamVC: UIViewController {
    
    @IBOutlet weak var teamNameTextField: UITextField!
    @IBOutlet weak var TeamPWTextField: UITextField!
    
    private lazy var teamRef: DatabaseReference = Database.database().reference().child("Teams")
    private var teamRefHandle: DatabaseHandle?
    private lazy var userTeamKeysRef: DatabaseReference = Database.database().reference().child("userToTeamKeys")
    
    var parentVC: ManageTeamsVC?
    
    var user: User? {
        didSet {
            let tempUser = self.user
        }
    }
    
    @IBOutlet weak var findTeamOutlet: UIButton!
    
    @IBOutlet weak var findTeamWarningLabel: UILabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        findTeamWarningLabel.alpha = 0.0
        findTeamOutlet.setTitle("Find Team", for: .normal)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func findTeamButton(_ sender: Any) {
        
        if teamNameTextField.text != "" && TeamPWTextField.text != "" {
            
            if let teamNameInField = teamNameTextField?.text, let teamPWInField = TeamPWTextField.text{
                
                findTeamOutlet.setTitle("Find Team", for: .disabled)
                teamRefHandle = teamRef.observe(.value, with: { (snapshot) -> Void in
                    //let teamData = snapshot.value as! Dictionary<String, AnyObject>
                    //let teamId = snapshot.key
                    
                    for child in snapshot.children.allObjects as! [DataSnapshot] {
                        let teamData = child.value as! [String: String]
                        let teamKey = child.key
                        
                        if let teamName = teamData["TeamName"] as String!,
                            let teamPW = teamData["TeamPassword"] as String!,
                            teamName.count > 0 {
                            
                            if teamName == teamNameInField && teamPW == teamPWInField {
                            
                                let userNewGroupKey = self.userTeamKeysRef.childByAutoId()
                                let actualUser = self.user!
                                
                                let userIdToTeamKeyItem = [
                                    "userId"    : actualUser.userId,
                                    "TeamId"    : teamKey,
                                    "TeamName"  : teamName,
                                    "TeamPW"    : teamPW
                                ]

                                userNewGroupKey.setValue(userIdToTeamKeyItem)
                                print("Successs")
                                self.performSegue(withIdentifier: "FoundTeamSegue", sender: nil)
                            }
                        }
                    }
                    
                })
                findTeamOutlet.setTitle("Find Team", for: .normal)
                findTeamWarningLabel.alpha = 1.0
                findTeamWarningLabel.text = "Could Not find team."
                
                
            }
        }
        else {
            findTeamWarningLabel.alpha = 1.0
            findTeamWarningLabel.text = "Fill In text fields."
        }
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
