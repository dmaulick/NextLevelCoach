//
//  CreateUserVC.swift
//  ChatChat
//
//  Created by David Maulick on 11/14/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit
import Firebase

class CreateUserVC: UIViewController {

    var usernameTemp: String?
    
    @IBOutlet weak var DoNotHaveAccountLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var sportTextField: UITextField!
    @IBOutlet weak var positionTextField: UITextField!
    
    private lazy var DBusersRef: DatabaseReference = Database.database().reference().child("Users")
    private var DBusersRefHandle: DatabaseHandle?
    
    
    
    // MARK: View life cycle-----------------------------View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation-------------------------Navigation
    // Mark: Make new user-----------------------------------------Make new user-----------------------------------------Make new user

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func CreateUser(_ sender: Any) {
        
        if usernameTextField.text != "",
            firstNameTextField.text != "",
            lastNameTextField.text != "",
            sportTextField.text != "",
            positionTextField.text != "" {
            self.performSegue(withIdentifier: "CreateUser", sender: nil)
        }
        else {
            self.DoNotHaveAccountLabel.text = "Fill in the text fields!"
            self.DoNotHaveAccountLabel.alpha = 1.0
        }
        
        
    }
    
    @IBAction func ExistingAccoount(_ sender: Any) {
        
        DBusersRef.observeSingleEvent(of: .value, with: { snapshot in
            
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let userKey = child.key
                
                if let curUserId = Auth.auth().currentUser?.uid {
                    if curUserId == userKey && snapshot.childrenCount != 0 {
                        print("Found existing account")
                        self.performSegue(withIdentifier: "ExistingAccount", sender: nil)
                    }
                }
            }
            // if doesn't perform segue, no account exists or matches
            self.DoNotHaveAccountLabel.text = "You do not have and existing account!"
            self.DoNotHaveAccountLabel.alpha = 1.0
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var newUser: User?
        let authUser = Auth.auth().currentUser
        
        if segue.identifier == "CreateUser" {
            
            if let authUser = authUser {
                usernameTemp = authUser.email
                
                let userId = authUser.uid
                let username = usernameTextField?.text
                let firstName = firstNameTextField?.text
                let lastName = lastNameTextField?.text
                let sport = sportTextField?.text
                let postion = positionTextField?.text
                let email = authUser.email
                let photoURL = authUser.photoURL!
                newUser = User(userId: userId, username: username!, firstName: firstName!, lastName: lastName!, sport: sport!, position: postion!, email: email!, photoURL: photoURL)
                
                // Put user into the database
                let DBnewUserIdRef: DatabaseReference = DBusersRef.child(userId) // existing users
                
                let newUserItem = [
                    "userId"    :userId,
                    "username"  :username,
                    "firstName" :firstName,
                    "lastName"  :lastName,
                    "sport"     :sport,
                    "position"  :postion,
                    "email"     :email,
                    "photoURL"  :String(describing: photoURL)
                    ]
                DBnewUserIdRef.setValue(newUserItem)
                
            }
            else {
                print("Could not load firebase user data")
            }
            
            let slideOutPrepVC = segue.destination as! slideOutPrepPageVC
            slideOutPrepVC.username = usernameTemp
            slideOutPrepVC.user = newUser
        }
        
        else if segue.identifier == "SkipSegue" {
            
        }
        
    }
    
    
    
    
}


