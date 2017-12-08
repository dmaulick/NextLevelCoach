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
    
    
    @IBOutlet weak var SelectTeamWarningLabel: UILabel!
    
    @IBOutlet weak var test: UILabel!
    
    var currentTeamForAPP: Team?
    var varView: Int = 3
    
    var username: String? // this is the email... we get actual info in view did load
    var user: User?
    @IBOutlet weak var welcomeTitle: UILabel!
    
    @IBOutlet weak var openTeamsList: UIBarButtonItem!
    
    // Mark: Life cycle views ------------------------------------------------------------------------------------- Life cycle views
    
    override func viewDidAppear(_ animated: Bool) {
        SelectTeamWarningLabel.alpha = 0.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        openTeamsList.target = self.revealViewController()
        openTeamsList.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        /*
        If want to show team menu immediately
        if currentTeamForAPP == nil {
            openTeamsList.target?.perform(openTeamsList.action, with: nil)
        }
        */
        test.text = currentTeamForAPP?.teamName
        
        print("Account already existed - home screen")
        if let currentUser = Auth.auth().currentUser {
            print("Google user on home screen")
            let usersRef: DatabaseReference = Database.database().reference().child("Users").child(currentUser.uid)
            
            usersRef.observeSingleEvent(of: .value, with: { (snapshot) in
                self.user = User(snap: snapshot)
                self.welcomeTitle.alpha = 1.0
                self.welcomeTitle.text = "Welcome, \(self.user?.firstName ?? "No firstName")"
                
                
                //self.updateArrayOfTeamKeysOfCurrentUser()
            })
        }
            
            
        
        else {
            print("New Account Created")
        }
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
    
    @IBAction func ChatIconSelected(_ sender: Any) {
        if currentTeamForAPP != nil {
            performSegue(withIdentifier: "showChat", sender: nil)
        }
        else {
            SelectTeamWarningLabel.text = "Select A Team!!! (Pan right to see Teams)"
            SelectTeamWarningLabel.alpha = 1.0
        }
    }
    
    @IBAction func CalendarIconSelected(_ sender: Any) {
        if currentTeamForAPP != nil {
            performSegue(withIdentifier: "showCalendar", sender: nil)
        }
        else {
            SelectTeamWarningLabel.text = "Select A Team!!! (Pan right to see Teams)"
            SelectTeamWarningLabel.alpha = 1.0
        }
    }
    
    @IBAction func NewsFeedIconSelected(_ sender: Any) {
        if currentTeamForAPP != nil {
            performSegue(withIdentifier: "showNewsFeed", sender: nil)
        }
        else {
            SelectTeamWarningLabel.text = "Select A Team!!! (Pan right to see Teams)"
            SelectTeamWarningLabel.alpha = 1.0
        }
    }
    
    
    // MARK: Navigation------------------------------------------------Navigation---------------------------------------------------Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "showChat" {
            let channelVc = segue.destination as! ChannelListViewController
            channelVc.user = self.user
            channelVc.username = username
            channelVc.currentTeamForAPP = self.currentTeamForAPP
        }
        
        else if segue.identifier == "showProfile" {
            let profileVC = segue.destination as! ProfileVC
            profileVC.user = user
        }
        else if segue.identifier == "showNewsFeed" {
            let NewsFeedTable = segue.destination as! NewsFeedTableView
            NewsFeedTable.user = user
            NewsFeedTable.currentTeamForAPP = self.currentTeamForAPP
        }
        else if segue.identifier == "showCalendar" {
            let calendarVC = segue.destination as! CalendarVC
            calendarVC.user = user
            calendarVC.currentTeamForAPP = self.currentTeamForAPP
        }
        
    }

}

