/*
 * Copyright (c) 2015 Razeware LLC
 * Author: David Maulick
 */

import UIKit
import Firebase
import FirebaseAuth

enum Section: Int {
    case createNewChannelSection = 0
    case currentChannelsSection
}

class ChannelListViewController: UITableViewController {

    var username: String?
    var user: User?
    var newChannelTextField: UITextField?
    var userGroupKeys: [String] = [String]()
    
    private var channels: [Channel] = []
    private lazy var DBchannelRef: DatabaseReference = Database.database().reference().child("channels")
    private var DBchannelRefHandle: DatabaseHandle?
    private lazy var userGroupKeysRef: DatabaseReference = Database.database().reference().child("userGroupKeys")
    
    
    
    // MARK: View Lifecycle ------------------------------------View Lifecycle---------------------------------------------View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chat"
        
        updateUserGroupKeys()
        
        
        
      
        
    }
    
    deinit {
        if let refHandle = DBchannelRefHandle {
            DBchannelRef.removeObserver(withHandle: refHandle)
        }
    }
    
    //This is the function that will update this view controllers userGroup keys rray so that it only shows groups that the user is a part of
    func updateUserGroupKeys() {
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
                    self.userGroupKeys.append(curChannelId!)
                }
            }
            print(self.userGroupKeys)
            self.observeChannels()
        })
    
    }
    
    
    
    // MARK: Firebase related methods -------------------------Firebase related methods------------------------------------Firebase related methods

    // When press create in upper section of table view
    @IBAction func createChannel(_ sender: AnyObject) {
        
        if newChannelTextField?.text != "" {
            if let name = newChannelTextField?.text {
                
                let channelItem = [
                    "GroupName"     : name
                ]
                let newChannelRef = DBchannelRef.childByAutoId()
                newChannelRef.setValue(channelItem)
                
                
                let actualUser = user!
                
                
                let userGroupKeyItem = [
                    "userId"    : actualUser.userId,
                    "channelId" : newChannelRef.key,
                    "GroupName" : name
                    
                ]
                
                let userNewGroupKey = userGroupKeysRef.childByAutoId()
                userNewGroupKey.setValue(userGroupKeyItem)
                
                // to update the user group keys when this user creates a channel
                self.userGroupKeys.append(newChannelRef.key)
            }
            newChannelTextField?.text = ""
        }
    }
    
    private func observeChannels() {
        
        DBchannelRefHandle = DBchannelRef.observe(.childAdded, with: { (snapshot) -> Void in
            let channelData = snapshot.value as! Dictionary<String, AnyObject>
            let curGroupKey = snapshot.key
            
            if self.userGroupKeys.contains(curGroupKey) {
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
        if indexPath.section == Section.currentChannelsSection.rawValue {
            let channel = channels[(indexPath as NSIndexPath).row]
            self.performSegue(withIdentifier: "ShowChannel", sender: channel)
        }
    }
    
    // MARK: Navigation -------------------------------------Navigation-------------------------------------------------Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let channel = sender as? Channel {
            let chatVc = segue.destination as! ChatViewController
            let actualUser = user!
            chatVc.senderDisplayName = actualUser.username
            chatVc.channel = channel
            chatVc.channelRef = DBchannelRef.child(channel.id)
        }
    }
    
    
}
