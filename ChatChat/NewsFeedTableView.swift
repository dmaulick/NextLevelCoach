//
//  GroupTableViewTableViewController.swift
//  NextLevelCoach
//
//  Created by David Maulick on 10/7/17.
//  Copyright © 2017 mau8. All rights reserved.
//

import UIKit
import Firebase

class NewsFeedTableView: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private lazy var EventRef: DatabaseReference = Database.database().reference().child("Events")
    private var EventRefHandle: DatabaseHandle?
    
    private lazy var GroupEventKeysRef: DatabaseReference = Database.database().reference().child("GroupEventKeys")
    
    private var events: [Event] = []
    
    var user: User?
    
    @IBOutlet weak var NewsFeedTableView: UITableView!
    
    
    var userGroupKeys: [String] = [String]()
    var userGroupNames: [String] = [String]()
    
    var eventKeys: [String] = [String]()
    
    private lazy var userGroupKeysRef: DatabaseReference = Database.database().reference().child("userGroupKeys")
    
    
    
    // MARK: life cycle views ----------------------------------------life cycle views----------------------------------------life cycle views
     override func viewDidLoad() {
        super.viewDidLoad()
        
        //dateFormatter.dateStyle = .medium
        //dateFormatter.timeStyle = .medium
        
        //self.navigationItem.leftBarButtonItem = self.editButtonItem
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        self.navigationItem.rightBarButtonItem = addButton
        
        updateUserGroupKeys()
        
        
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func addTapped() {
        performSegue(withIdentifier: "addNewsSegue", sender: nil)
    }
    
    
    
    
   
    
    private func updateUserGroupKeys() {
        userGroupKeysRef.observeSingleEvent(of: .value, with: { snapshot in
            print(snapshot.childrenCount) // I got the expected number of items
            
            let actualUser = self.user!
            
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let childDict = child.value as! [String: String]
                
                let curUserId = childDict["userId"]
                let curChannelId = childDict["channelId"]
                let curChannelName = childDict["GroupName"]
                
                if actualUser.userId == curUserId {
                    self.userGroupKeys.append(curChannelId!)
                    self.userGroupNames.append(curChannelName!)
                }
            }
            
            print("In update User's group  keys")
            for val in self.userGroupNames {
                print(val)
            }
            self.updateEventKeys()
        })
    }
    
    private func updateEventKeys() {
        // GroupEventKeys
        GroupEventKeysRef.observeSingleEvent(of: .value, with: { snapshot in
            
            //let actualUser = self.user!
            
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let childDict = child.value as! [String: String]
                
                //let curChannelName = childDict["ChannelName"]
                let curChannelKey = childDict["ChannelKey"]
                let curEventKey = childDict["EventKey"]
                
                if self.userGroupKeys.contains(curChannelKey!) {
                    self.eventKeys.append(curEventKey!)
                }
            }
            print("In update event keys")
            for val in self.eventKeys {
                print(val)
            }
            
            self.observeEvents()
        })
        
    }
    
    
    // Storage/Data -------------------------------------- Storage/Data -------------------------------------Storage /Data----------------
    
    
    private func observeEvents() {
        // Use the observe method to listen for new
        // channels being written to the Firebase DB
        
        print("Not in closure")
        EventRefHandle = EventRef.observe(.childAdded, with: { (snapshot) -> Void in // 1
            let EventData = snapshot.value as! Dictionary<String, AnyObject> // 2
            let curEventKey = snapshot.key
            
            print("In closure")
            
            if self.eventKeys.contains(curEventKey) {
                print("In if statement")
                if let title = EventData["title"] as? String,
                    let description = EventData["description"] as? String,
                    let whatToWear = EventData["whatToWear"] as? String,
                    let channelName = EventData["ChannelName"] as? String,
                    let channelKey = EventData["ChannelKey"] as? String,
                    //let startTime = EventData["startTime"] as? String,
                    //let endTime = EventData["endTime"] as? String!,
                    title.count > 0 {
                    self.events.append(Event(title: title, description: description, whatToWear: whatToWear, channelName: channelName, channelKey: channelKey)) //startTime: startTime, endTime: endTime))
                    self.NewsFeedTableView.reloadData()
                    print("loaded Event")
                } else {
                    print("Error! Could not decode newsfeed data on newsfeed table")
                }
            }
        })
        
    }
    
    
    
    
    
    

    // Edit table array--------------------------------------Edit table array---------------------------------------------Edit table array---------
    
    func editGroupArray(newEvent: Event, indexToEdit: Int) {
        events[indexToEdit] = newEvent
        NewsFeedTableView.reloadData()
    }
    
    func addToGroupArray(newEvent: Event) {
        events.append(newEvent)
        NewsFeedTableView.reloadData()
    }
    

    
    // MARK: - Table view ------------------------------------Table view----------------------------------------------Table view---------
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return events.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as? EventTableCell
        
        // Configure the cell...
        let thisEvent = events[indexPath.row]
        cell?.titleLabel?.text = thisEvent.title
        cell?.descriptLabel?.text = thisEvent.description
        cell?.startTimeLabel?.text = thisEvent.whatToWear
        cell?.endTimeLabel?.text = thisEvent.channelName
        //cell?.backgroundColor = UIColor.gray
 
        return cell!
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            events.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isEditing {
            performSegue(withIdentifier: "defaultProfileSegue", sender: nil)
        }
    }
    
    
    
    // Segue/ Navigation ----------------------------Segue/ Navigation----------------------------------Segue/ Navigation-----------
    
    @IBAction func unwindActionFromCancel(unwindSegue: UIStoryboardSegue){
        // This allows for unwind in detail view
    }
    @IBAction func unwindFromAdd(unwindSegue: UIStoryboardSegue){
        // This allows for unwind in detail view
    }
    @IBAction func unwindFromEdit(unwindSegue: UIStoryboardSegue){
        // This allows for unwind in detail view
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "addNewsSegue" {
            let addVC = segue.destination as! AddNewsPickGroupVC
            addVC.user = self.user
            addVC.userGroupNames = self.userGroupNames
            addVC.userGroupKeys = self.userGroupKeys
        }
        /*
        if segue.identifier == "defaultProfileSegue" {
            let destVC = segue.destination as? ProfileVC
            let selectedIndexPath = tableView.indexPathForSelectedRow
            destVC?.groupNameFromTable = groups[(selectedIndexPath?.row)!].groupName
            destVC?.groupDescriptionFromTable = groups[(selectedIndexPath?.row)!].groupDescription
            destVC?.newAnnouncementFromTable = groups[(selectedIndexPath?.row)!].newAnnouncement
            destVC?.newChatMessageFromTable = groups[(selectedIndexPath?.row)!].newChatMessage
            destVC?.indexPressed = (selectedIndexPath?.row)!
            
        }
        */
        
    }
    
    
    
}

