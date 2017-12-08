/*
 * Copyright (c) 2015 Razeware LLC
 * Author: David Maulick
 */

import UIKit
import Firebase
import FirebaseAuth

enum Section: Int {
    case createNewChannelSection = 0
    case currentChannelsSection = 1
}

class ChannelListViewController: UITableViewController {

    
    
    
    var currentTeamForAPP: Team?
    
    var username: String?
    var user: User?
    var newChannelTextField: UITextField?
    
    var groupKeysOfCurrentTeam: [String] = [String]()
    var GroupKeysOfCurrentUser: [String] = [String]()
    var groupNamesOfCurrentTeam: [String] = [String]()
    
    private var channels: [Channel] = []
    
    private lazy var DBchannelRef: DatabaseReference = Database.database().reference().child("channels")
    private var DBchannelRefHandle: DatabaseHandle?
    private lazy var userGroupKeysRef: DatabaseReference = Database.database().reference().child("userGroupKeys")

    private lazy var channelsInTeamsRef: DatabaseReference = Database.database().reference().child("channelsInTeams")
    
    
    @IBOutlet weak var ExistingTeamsOutlet: UIBarButtonItem!
    // MARK: View Lifecycle ------------------------------------View Lifecycle---------------------------------------------View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        //let addButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(addTapped))
        ExistingTeamsOutlet.title = "Other Groups"
        //self.navigationItem.rightBarButtonItem = addButton
        
        updateGroupKeysOfCurrentUserByCurrentTeam()
        
    }
    
    
    
    @IBAction func ExistingTeamsButton(_ sender: Any) {
        performSegue(withIdentifier: "findGroup", sender: nil)
    }
    
    
    deinit {
        if let refHandle = DBchannelRefHandle {
            DBchannelRef.removeObserver(withHandle: refHandle)
        }
    }
    
    func updateGroupKeysOfCurrentUserByCurrentTeam() {
        channelsInTeamsRef.observeSingleEvent(of: .value, with: { snapshot in
            print(snapshot.childrenCount) // I got the expected number of items
            
            let teamId = self.currentTeamForAPP?.teamId
            
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let childDict = child.value as! [String: String]
                
                let curTeamID = childDict["TeamID"]
                let curChannelId = childDict["channelId"]
                let curChannelName = childDict["GroupName"]
                
                if teamId == curTeamID {
                    self.groupKeysOfCurrentTeam.append(curChannelId!)
                    self.groupNamesOfCurrentTeam.append(curChannelName!)
                }
            }
            print(self.GroupKeysOfCurrentUser)
            self.updateGroupKeysOfCurrentUser()
        })
    }
    
    //This is the function that will update this view controllers GroupKeysOfCurrentUser array so that it only shows groups that the user is a part of
    func updateGroupKeysOfCurrentUser() {
        userGroupKeysRef.observeSingleEvent(of: .value, with: { snapshot in
            print(snapshot.childrenCount) // I got the expected number of items
            
            let actualUser = self.user!
            print(actualUser)
            
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let childDict = child.value as! [String: String]
                
                let curUserId = childDict["userId"]
                let curChannelId = childDict["channelId"]
                
                print("Cur Child:")
                print(child.value ?? "Child.value was nil")
                print(curUserId ?? "curUserId was nil")
                print(curChannelId ?? "curChannelId was nil")
                if actualUser.userId == curUserId {
                    self.GroupKeysOfCurrentUser.append(curChannelId!)
                    
                }
            }
            print(self.GroupKeysOfCurrentUser)
            self.observeChannels()
        })
    
    }
    
    
    
    // MARK: Firebase related methods -------------------------Firebase related methods------------------------------------Firebase related methods

    // When press create in upper section of table view
    @IBAction func createChannel(_ sender: AnyObject) {
        
        if newChannelTextField?.text != "" {
            if let name = newChannelTextField?.text {
                
                let newGroupInCurTeamRef = channelsInTeamsRef.childByAutoId()
                let newChannelRef = DBchannelRef.childByAutoId()
                let userNewGroupKey = userGroupKeysRef.childByAutoId()
                
                let groupsInTeamItem = [
                    "GroupName"     : name,
                    "channelId"     : newChannelRef.key,
                    "TeamName"      : currentTeamForAPP?.teamName,
                    "TeamID"        : currentTeamForAPP?.teamId
                ]
                
                let channelItem = [
                    "GroupName"     : name
                ]
                
                
                
                
                let actualUser = user!
                
                
                let userGroupKeyItem = [
                    "userId"    : actualUser.userId,
                    "channelId" : newChannelRef.key,
                    "GroupName" : name
                    
                ]
                
                newGroupInCurTeamRef.setValue(groupsInTeamItem)
                newChannelRef.setValue(channelItem)
                userNewGroupKey.setValue(userGroupKeyItem)
                
                // to update the user group keys when this user creates a channel
                self.GroupKeysOfCurrentUser.append(newChannelRef.key)
                self.groupKeysOfCurrentTeam.append(newChannelRef.key)
                
            }
            newChannelTextField?.text = ""
            //self.observeChannels()
        }
        
        //groupKeysOfCurrentTeam.removeAll()
        //GroupKeysOfCurrentUser.removeAll()
        
    }
    
    private func observeChannels() {
        
        DBchannelRefHandle = DBchannelRef.observe(.childAdded, with: { (snapshot) -> Void in
            let channelData = snapshot.value as! Dictionary<String, AnyObject>
            let curGroupKey = snapshot.key
            
            if self.GroupKeysOfCurrentUser.contains(curGroupKey) && self.groupKeysOfCurrentTeam.contains(curGroupKey) {
                if let name = channelData["GroupName"] as! String!, name.count > 0 {
                    // if user. groups contains name...?
                    self.channels.append(Channel(id: curGroupKey, name: name))
                    self.tableView.reloadData()
                    print("loaded channel")
                } else {
                    print("Error! Could not decode channel data on channel table")
                }
            }
        })
    }
    
    
    // MARK: UITableViewDataSource / UITableViewDelegate ------------------------------------------------UITableViewDataSource / UITableViewDelegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // 2
        if let currentSection: Section = Section(rawValue: section) {
            switch currentSection {
            case .createNewChannelSection:
                return 1
            case .currentChannelsSection:
                return channels.count
            }
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = (indexPath as NSIndexPath).section == Section.createNewChannelSection.rawValue ? "NewChannel" : "ExistingChannel"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        if (indexPath as NSIndexPath).section == Section.createNewChannelSection.rawValue {
            if let createNewChannelCell = cell as? CreateChannelCell {
                newChannelTextField = createNewChannelCell.newChannelNameField
            }
        } else if (indexPath as NSIndexPath).section == Section.currentChannelsSection.rawValue {
            cell.textLabel?.text = channels[(indexPath as NSIndexPath).row].name
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == Section.currentChannelsSection.rawValue {
            let channel = channels[(indexPath as NSIndexPath).row]
            self.performSegue(withIdentifier: "ShowChannel", sender: channel)
        }
        else {
            print(" Do Nothing")
        }
    }
    
    @IBAction func unwindFromAdd(unwindSegue: UIStoryboardSegue){
        groupKeysOfCurrentTeam.removeAll()
        GroupKeysOfCurrentUser.removeAll()
        
        groupNamesOfCurrentTeam.removeAll()
        
        channels.removeAll()
        updateGroupKeysOfCurrentUserByCurrentTeam()
        self.tableView.reloadData()
    }
    
    // MARK: Navigation -------------------------------------Navigation-------------------------------------------------Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        
        if segue.identifier == "findGroup" {
            let addVC = segue.destination as! AddGroupVC
            addVC.user = self.user
            
            addVC.groupKeysOfCurrentTeam = self.groupKeysOfCurrentTeam
            addVC.groupNamesOfCurrentTeam = self.groupNamesOfCurrentTeam
            addVC.currentTeamForAPP = self.currentTeamForAPP
        }
        
        if segue.identifier == "ShowChannel" {
            if let channel = sender as? Channel {
                let chatVc = segue.destination as! ChatViewController
                let actualUser = user!
                chatVc.senderDisplayName = actualUser.username
                chatVc.channel = channel
                chatVc.channelRef = DBchannelRef.child(channel.id)
            }
        }
    }
    
    
}
