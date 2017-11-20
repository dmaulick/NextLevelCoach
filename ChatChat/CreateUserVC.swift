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
        print("Viewdidload")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation-------------------------Navigation
    // Mark: Make new user-----------------------------------------Make new user-----------------------------------------Make new user

    
    @IBAction func CreateUser(_ sender: Any) {
        
        if usernameTextField.text != "",
            firstNameTextField.text != "",
            lastNameTextField.text != "",
            sportTextField.text != "",
            positionTextField.text != "" {
            self.performSegue(withIdentifier: "CreateUser", sender: nil)
        }
        
        //NOTE: need to add if they have an account- we will pull user info from DB
        // should match username and email with the key to retrieve the actual user
    }
    
    @IBAction func ExistingAccoount(_ sender: Any) {
        self.performSegue(withIdentifier: "ExistingAccount", sender: nil)
        
        //NOTE: need to add if they have an account- we will pull user info from DB
        // should match username and email with the key to retrieve the actual user
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
                print("Loaded firebase user data correctly")
                
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
            
            let navVc = segue.destination as! UINavigationController // 1
            let HomeScreenVC = navVc.viewControllers.first as! HomeScreenVC
            HomeScreenVC.username = usernameTemp
            HomeScreenVC.user = newUser
        }        
    }

    
    
    
}


