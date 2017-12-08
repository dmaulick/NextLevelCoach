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

    var currentTeamForAPP: Team?
    
    private lazy var EventRef: DatabaseReference = Database.database().reference().child("Events")
    private var EventRefHandle: DatabaseHandle?
    
    private lazy var GroupEventKeysRef: DatabaseReference = Database.database().reference().child("GroupEventKeys")
    private lazy var userGroupKeysRef: DatabaseReference = Database.database().reference().child("userGroupKeys")
    private lazy var channelsInTeamsRef: DatabaseReference = Database.database().reference().child("channelsInTeams")
    
    var groupKeysOfCurrentTeam: [String] = [String]()
    var groupNamesOfCurrentTeam: [String] = [String]()
    
    private var events: [Event] = []
    
    var GroupKeysOfCurrentUser: [String] = [String]()
    var GroupNamesOfCurrentUser: [String] = [String]()
    
    var eventKeys: [String] = [String]()
    
    var user: User?
    
    @IBOutlet weak var NewsFeedTableView: UITableView!
    
    
    
    
    
    
    
    // MARK: life cycle views ----------------------------------------life cycle views----------------------------------------life cycle views
     override func viewDidLoad() {
        super.viewDidLoad()
        
        //dateFormatter.dateStyle = .medium
        //dateFormatter.timeStyle = .medium
        
        
        //self.navigationItem.leftBarButtonItem = self.editButtonItem
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        self.navigationItem.rightBarButtonItem = addButton
        
        updateGroupKeysOfCurrentUserByCurrentTeam()
        
        
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func addTapped() {
        performSegue(withIdentifier: "addNewsSegue", sender: nil)
    }
    
    
    
    
    func updateGroupKeysOfCurrentUserByCurrentTeam() {
        channelsInTeamsRef.observeSingleEvent(of: .value, with: { snapshot in
            print(snapshot.childrenCount) // I got the expected number of items
            
            let teamId = self.currentTeamForAPP?.teamId
            
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let childDict = child.value as! [String: String]
                
                let curTeamID = childDict["TeamID"]
                let curTeam = childDict["GroupName"]
                let curChannelId = childDict["channelId"]
                
                if teamId == curTeamID {
                    self.groupKeysOfCurrentTeam.append(curChannelId!)
                    self.groupNamesOfCurrentTeam.append(curTeam!)
                }
            }
            print(self.GroupKeysOfCurrentUser)
            self.updateGroupKeysOfCurrentUser()
        })
    }
    
    private func updateGroupKeysOfCurrentUser() {
        userGroupKeysRef.observeSingleEvent(of: .value, with: { snapshot in
            print(snapshot.childrenCount) // I got the expected number of items
            
            let actualUser = self.user!
            
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let childDict = child.value as! [String: String]
                
                let curUserId = childDict["userId"]
                let curChannelId = childDict["channelId"]
                let curChannelName = childDict["GroupName"]
                
                if actualUser.userId == curUserId {
                    self.GroupKeysOfCurrentUser.append(curChannelId!)
                    self.GroupNamesOfCurrentUser.append(curChannelName!)
                }
            }
            
            print("In update User's group  keys")
            for val in self.GroupNamesOfCurrentUser {
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
                
                if self.GroupKeysOfCurrentUser.contains(curChannelKey!) && self.groupKeysOfCurrentTeam.contains(curChannelKey!){
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
                    let date = EventData["Date"] as? String,
                    //let startTime = EventData["startTime"] as? String,
                    //let endTime = EventData["endTime"] as? String!,
                    title.count > 0 {
                    self.events.append(Event(title: title, description: description, whatToWear: whatToWear, channelName: channelName, channelKey: channelKey,  date: date)) //startTime: startTime, endTime: endTime))
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
        
        var numOfSections: Int = 0
        if events.count > 0 {
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width / 2, height: tableView.bounds.size.height))
            noDataLabel.text          = "No upcoming events"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
        
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
        
        let calendar = NSCalendar.current
        let CellDateComponents = calendar.dateComponents([.hour, .minute], from: thisEvent.date)
        let stringMinute = String(describing: CellDateComponents.minute!)
        cell?.Time?.text = "\(String(describing: CellDateComponents.hour!)):\(CellDateComponents.minute! < 10 ? "0\(stringMinute)" : stringMinute )"
    
        cell?.Group?.text = thisEvent.channelName
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
        
        self.NewsFeedTableView.deselectRow(at: indexPath, animated: true)
        
        
        let event = self.events[(indexPath as NSIndexPath).row]
        self.performSegue(withIdentifier: "EventDetailFromNewsFeed", sender: event)
        
    }
    
    
    
    // Segue/ Navigation ----------------------------Segue/ Navigation----------------------------------Segue/ Navigation-----------
    
    @IBAction func unwindActionFromCancel(unwindSegue: UIStoryboardSegue){
        // This allows for unwind in detail view
    }
    @IBAction func unwindFromAdd(unwindSegue: UIStoryboardSegue){
        groupKeysOfCurrentTeam.removeAll()
        GroupKeysOfCurrentUser.removeAll()
        events.removeAll()
        updateGroupKeysOfCurrentUserByCurrentTeam()
        self.NewsFeedTableView.reloadData()
    }
    @IBAction func unwindFromEdit(unwindSegue: UIStoryboardSegue){
        // This allows for unwind in detail view
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        
        if segue.identifier == "addNewsSegue" {
            let addVC = segue.destination as! AddNewsPickGroupVC
            addVC.user = self.user
            addVC.GroupNamesOfCurrentUser = self.GroupNamesOfCurrentUser
            addVC.GroupKeysOfCurrentUser = self.GroupKeysOfCurrentUser
            
            
            addVC.groupKeysOfCurrentTeam = self.groupKeysOfCurrentTeam
            addVC.groupNamesOfCurrentTeam = self.groupNamesOfCurrentTeam
            addVC.currentTeamForAPP = self.currentTeamForAPP
        }
        
        if let event = sender as? Event {
            if segue.identifier == "EventDetailFromNewsFeed" {
                let eventDetailVC = segue.destination as! EventViewVC
                eventDetailVC.event = event
            }
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

