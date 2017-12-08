//
//  ExistingAccountVC.swift
//  ChatChat
//
//  Created by David Maulick on 11/16/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit
import Firebase

class ExistingAccountVC: UIViewController {

    
    private lazy var DBusersRef: DatabaseReference = Database.database().reference().child("Users")
    private var DBusersRefHandle: DatabaseHandle?
    
    @IBOutlet weak var noAccountLabel: UILabel!
    @IBOutlet weak var existingUsername: UITextField!
    @IBOutlet weak var existingEmail: UITextField!
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func RetrieveAccount(_ sender: Any) {
        
        if existingUsername.text != "",
            existingEmail.text != "" {
            
            DBusersRef.observeSingleEvent(of: .value, with: { snapshot in
                for child in snapshot.children.allObjects as! [DataSnapshot] {
                    let userKey = child.key
                    let firebaseUserDict = child.value as! [String: String]
                    let userName = firebaseUserDict["username"]
                    let email = firebaseUserDict["email"]
                    
                    
                    if let curUserId = Auth.auth().currentUser?.uid {
                        
                        if curUserId == userKey && userName == self.existingUsername.text && email == self.existingEmail.text {
                                self.performSegue(withIdentifier: "RetrieveAccount", sender: nil)
                        }
                        else {
                            self.noAccountLabel.text = "Incorrect username or email."
                            self.noAccountLabel.alpha = 1.0
                        }
                        
                        
                    }
                    
                }
            })
        }
        else {
            self.noAccountLabel.text = "Fill in the text fields."
            self.noAccountLabel.alpha = 1.0
        }
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "RetrieveAccount" {
            
            
            
            
            //let slideOutPrepVC = segue.destination as! slideOutPrepPageVC
            
        }
    }
    

}
