//
//  BackTableVC.swift
//  ChatChat
//
//  Created by David Maulick on 11/29/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import Foundation
import Firebase

class BackTableVC:UITableViewController {
    
    var selectedRowIndex: Int?
    
    let storageRef = Storage.storage().reference()
    
    private lazy var teamRef: DatabaseReference = Database.database().reference().child("Teams")
    private var teamRefHandle: DatabaseHandle?
    private lazy var userTeamKeysRef: DatabaseReference = Database.database().reference().child("userToTeamKeys")
    
    var TeamKeysOfCurrentUser: [String] = [String]()
    var TeamNamesOfCurrentUser: [String] = [String]()
    var teams: [Team] = []
    
    
    var user: User?
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("Account already existed - BackTable")
        if let currentUserId = Auth.auth().currentUser {
            
            let usersRef: DatabaseReference = Database.database().reference().child("Users").child(currentUserId.uid)
            
            usersRef.observeSingleEvent(of: .value, with: { (snapshot) in
                self.user = User(snap: snapshot)
                self.TeamKeysOfCurrentUser.removeAll()
                self.TeamNamesOfCurrentUser.removeAll()
                self.teams.removeAll()
                self.updateArrayOfTeamKeysOfCurrentUser()
            })
        }
        else {
            print("New Account Created - BackTable")
        }
    
    }
    
    override func viewDidLoad() {
        
        
    }
    
    func updateArrayOfTeamKeysOfCurrentUser() {
        
        userTeamKeysRef.observeSingleEvent(of: .value, with: { snapshot in
            
            let actualUser = self.user!
            
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let childDict = child.value as! [String: String]
                
                let curUserId = childDict["userId"]
                let curTeamId = childDict["TeamId"]
                let curTeamName = childDict["TeamName"]
                
                if actualUser.userId == curUserId {
                    self.TeamKeysOfCurrentUser.append(curTeamId!)
                    self.TeamNamesOfCurrentUser.append(curTeamName!)
                }
            }
            
            self.observeTeams()
        })
        
    }
    
    func teamSorterByName(this:Team, that:Team) -> Bool {
        return this.teamName > that.teamName
    }
    
    private func observeTeams() {
        
        teamRefHandle = teamRef.observe(.childAdded, with: { (snapshot) -> Void in
            let teamData = snapshot.value as! Dictionary<String, AnyObject>
            let teamId = snapshot.key
            
            if self.TeamKeysOfCurrentUser.contains(teamId) {
                
                if let teamName = teamData["TeamName"] as! String!,
                    let teamPW = teamData["TeamPassword"] as! String!,
                    let teamPhotoURL = teamData["teamPhoto"] as! String!,
                    teamName.count > 0 {
                    
                        let filePath = "TeamStorage/\(teamId)/teamPhoto"
                    
                        self.storageRef.child(filePath).getData(maxSize: 10*1024*1024, completion: { (data, error) in // Assuming a < 10MB file, though you can change that
                            let teamPhoto = UIImage(data: data!)
                            self.teams.append(Team(teamId: teamId, teamName: teamName, teamPW: teamPW, teamPhoto: teamPhoto!))
                            self.teams.sort(by: self.teamSorterByName)
                            self.tableView.reloadData()
                        })
                }
            }
            else {
                    print("Error! Could not decode Team data on back Table")
                
            }
        })
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if teams.count > 0 {
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width / 2, height: tableView.bounds.size.height))
            noDataLabel.text          = "Add teams in your profile Section"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .left
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return teams.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BackTableTeamCell
        
        //cell.textLabel?.text = TableArray[indexPath.row]
        cell.TeamNameLabel.text = teams[indexPath.row].teamName
        cell.teamImage.image = teams[indexPath.row].teamPhoto
        
        print("Loading table cell")
        print(selectedRowIndex)
        
        if indexPath.row == selectedRowIndex {
            cell.teamImage.alpha = 1
        }
        else {
            cell.teamImage.alpha = 0.2
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let i = indexPath.row
        selectedRowIndex = i
        
        performSegue(withIdentifier: "reloadTeamSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        let navVC = segue.destination as! UINavigationController
        let HomeScreenVC = navVC.viewControllers.first as! HomeScreenVC
        let index: NSIndexPath = self.tableView.indexPathForSelectedRow! as NSIndexPath
        
        print(index.row)
        let currentTeamForAPP = teams[index.row]
        HomeScreenVC.currentTeamForAPP = teams[index.row]
        HomeScreenVC.varView = index.row
        //HomeScreenVC.test.text = String(index.row)
        //if self.fromExistingAccountVC == true {
        //    HomeScreenVC.fromExistingAccountVC = true
        //}
    }
    
}
