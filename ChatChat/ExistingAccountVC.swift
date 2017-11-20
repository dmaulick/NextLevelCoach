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
            performSegue(withIdentifier: "RetrieveAccount", sender: nil)
        }
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "RetrieveAccount" {
            
            let navVc = segue.destination as! UINavigationController // 1
            let HomeScreenVC = navVc.viewControllers.first as! HomeScreenVC
            HomeScreenVC.fromExistingAccountVC = true
            
            // usersRef.queryOrdered(byChild: "username").queryEqual(toValue: "snu").observe(.value, with: { snapshot in
            /*
            var existingUser: User?
            
            if let currentUserId = Auth.auth().currentUser {
                let usersRef: DatabaseReference = Database.database().reference().child("Users").child(currentUserId.uid)
                
                usersRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    existingUser = User(snap: snapshot)
                    self.user = existingUser
                    
                })
            }
            
            
            let navVc = segue.destination as! UINavigationController // 1
            let HomeScreenVC = navVc.viewControllers.first as! HomeScreenVC
            HomeScreenVC.username = self.user?.username
            HomeScreenVC.user = self.user
                */
        }
    }
    

}
