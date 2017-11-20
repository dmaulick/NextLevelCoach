//
//  NavigationVC.swift
//  ChatChat
//
//  Created by David Maulick on 11/9/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class HomeScreenVC: UIViewController {

    var username: String?
    var user: User?
    @IBOutlet weak var userTitle: UILabel!
    
    var fromExistingAccountVC: Bool = false
    
    // Mark: Life cycle views ------------------------------------------------------------------------------------- Life cycle views
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if fromExistingAccountVC {
            print("from existing")
            if let currentUserId = Auth.auth().currentUser {
                let usersRef: DatabaseReference = Database.database().reference().child("Users").child(currentUserId.uid)
                
                usersRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    print("Got Here")
                    self.user = User(snap: snapshot)
                    
                    self.userTitle.text = self.user?.email
                    print(self.user)
                })
            }
        }
        else {
            print("from create")
        }
        
        
        
        
        
       //print(user!)
        //print(user?.email)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //---- sign out ------------------------------------Navigation------------------------------------------------------------Navigation
    
    @IBAction func SignOutButtonPress(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            GIDSignIn.sharedInstance().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            return
        }
        print("Successfully Logged out")
        //There is a segue to home screen on storyboard
    }
    

    // MARK: Navigation------------------------------------------------Navigation---------------------------------------------------Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "showChat" {
            let channelVc = segue.destination as! ChannelListViewController
            channelVc.user = self.user
            channelVc.username = username
        }
        
        else if segue.identifier == "showProfile" {
            let profileVC = segue.destination as! ProfileVC
            profileVC.user = user
        }
        else if segue.identifier == "showNewsFeed" {
            let NewsFeedTable = segue.destination as! NewsFeedTableView
            NewsFeedTable.user = user
        }
        
    }

}
