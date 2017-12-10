//
//  ViewController.swift
//  testCalendar
//
//  Created by David Maulick on 11/8/17.
//  Copyright © 2017 mau8. All rights reserved.
//

import UIKit
import JTAppleCalendar
import Firebase

class CalendarVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var currentTeamForAPP: Team?
    
    private lazy var EventRef: DatabaseReference = Database.database().reference().child("Events")
    private var EventRefHandle: DatabaseHandle?
    
    private lazy var GroupEventKeysRef: DatabaseReference = Database.database().reference().child("GroupEventKeys")
    private lazy var userGroupKeysRef: DatabaseReference = Database.database().reference().child("userGroupKeys")
    private lazy var channelsInTeamsRef: DatabaseReference = Database.database().reference().child("channelsInTeams")
    
    var groupKeysOfCurrentTeam: [String] = [String]()
    
    var GroupKeysOfCurrentUser: [String] = [String]()
    var GroupNamesOfCurrentUser: [String] = [String]()
    
    private var events: [Event] = []
    var eventKeys: [String] = [String]()
    var EventsForSelectedCellDate: [Event] = []
    
    var user: User?
    
    
    
    @IBOutlet weak var CalTableView: UITableView!
    
    @IBOutlet weak var CalendarView: JTAppleCalendarView!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    
    let formatter = DateFormatter()
    
    let outsideMonthColor = UIColor(colorWithHexValue: 0x584a66)
    let monthColor = UIColor.white
    let selectedMonthColor = UIColor(colorWithHexValue: 0x3a294b)
    let currentDateSelectedViewColor = UIColor(colorWithHexValue: 0x4e3f5d)
    
    
    
    
    
    // MARK: ViewLifeCycles -------------------------------------------------------------ViewLifeCycles------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        SetUpCalendar()
        updateGroupKeysOfCurrentUserByCurrentTeam()
        
        CalendarView.scrollToDate(Date())
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    func updateGroupKeysOfCurrentUserByCurrentTeam() {
        channelsInTeamsRef.observeSingleEvent(of: .value, with: { snapshot in
            print(snapshot.childrenCount) // I got the expected number of items
            
            let teamId = self.currentTeamForAPP?.teamId
            
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let childDict = child.value as! [String: String]
                
                let curTeamID = childDict["TeamID"]
                let curChannelId = childDict["channelId"]
                
                if teamId == curTeamID {
                    self.groupKeysOfCurrentTeam.append(curChannelId!)
                }
            }
            print(self.GroupKeysOfCurrentUser)
            self.updateGroupKeysOfCurrentUser()
        })
    }
    
    // MARK: GroupEventKeysWork -----------------------------------------------------GroupEventKeysWork------------------------
    
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
                
                if self.GroupKeysOfCurrentUser.contains(curChannelKey!) && self.groupKeysOfCurrentTeam.contains(curChannelKey!) {
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
                    //self.NewsFeedTableView.reloadData()
                    print("loaded Event")
                } else {
                    print("Error! Could not decode newsfeed data on newsfeed table")
                }
            }
        })
        
    }
    
    
    
    
    
    
    // Mark: TableViewStuff ---------------------------------------------------------TableViewStuff---------------------
    
    let testGroup = ["test1", "test2", "test3", "test4", "test5", "test6", "test7", "test8"]
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if EventsForSelectedCellDate.count > 0 {
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width / 2, height: tableView.bounds.size.height))
            noDataLabel.text          = "No events on this Day"
            noDataLabel.textColor     = UIColor.white
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.EventsForSelectedCellDate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalTableCel", for: indexPath) as? CalendarTableViewCell
        
        let cellEvent = self.EventsForSelectedCellDate[indexPath.row]
        let calendar = NSCalendar.current
        let CellDateComponents = calendar.dateComponents([.hour, .minute], from: cellEvent.date)
        
        let stringMinute = String(describing: CellDateComponents.minute!)
        cell?.timeLabel.text = "\(String(describing: CellDateComponents.hour!)):\(CellDateComponents.minute! < 10 ? "0\(stringMinute)" : stringMinute )"
        cell?.titleLabel.text = cellEvent.title
        cell?.whatToWearLabel.text = cellEvent.whatToWear
        cell?.groupNameLabel.text = cellEvent.channelName
            
        cell?.event = cellEvent
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = self.EventsForSelectedCellDate[(indexPath as NSIndexPath).row]
        self.CalTableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "EventDetailFromCalendar", sender: event)
    }
    
    
    // MARK: Calendar Functions ------------------------------------------------------- Calendar Functions----------------------
    func SetUpCalendar() {
        
        // Set year label color to a faded color compared to Month
        yearLabel.textColor = outsideMonthColor
        
        // minimiza spacing between dates
        CalendarView.minimumLineSpacing = 0
        CalendarView.minimumInteritemSpacing = 0
        
        // set up label
        CalendarView.visibleDates() { (visibleDates) in
            self.SetupViewsOfCalendar(from: visibleDates)
        }
    }
    func handleCellTextColor(view: JTAppleCell?, CellState:CellState) {
        guard let validCell = view as? CustomCell else { return }
        
        if CellState.isSelected {
            validCell.dateLabel.textColor = selectedMonthColor
        } else {
            if CellState.dateBelongsTo == .thisMonth {
                validCell.dateLabel.textColor = monthColor
            } else {
                validCell.dateLabel.textColor = outsideMonthColor
            }
        }
    }
    
    
    func handleCellSelected(cell: JTAppleCell?, CellState:CellState) {
        guard let validCell = cell as? CustomCell else { return }
        if validCell.isSelected {
            validCell.selectedView.isHidden = false
        
            let selectedCellDate = CellState.date
            let calendar = NSCalendar.current
            let selectedCellDateComponents = calendar.dateComponents([.day, .month, .year], from: selectedCellDate)
            
            self.EventsForSelectedCellDate.removeAll()
            
            for thisEvent in events {
                let eventDate = thisEvent.date
                let eventDateComponents = calendar.dateComponents([.day, .month, .year], from: eventDate)
                
                if eventDateComponents.day == selectedCellDateComponents.day && eventDateComponents.month == selectedCellDateComponents.month && eventDateComponents.year == selectedCellDateComponents.year {
                    
                    self.EventsForSelectedCellDate.append(thisEvent)
                }
            }
            
            self.CalTableView.reloadData()
            print(self.EventsForSelectedCellDate)
            
        } else {
            validCell.selectedView.isHidden = true
        }
    }
    
    func SetupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        
        formatter.dateFormat = "yyyy"
        yearLabel.text = formatter.string(from: date)
        
        formatter.dateFormat = "MMMM"
        monthLabel.text = formatter.string(from: date)
    }
    
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let event = sender as? Event {
            if segue.identifier == "EventDetailFromCalendar" {
                
                let eventDetailVC = segue.destination as! EventViewVC
                eventDetailVC.event = event
            }
        }
    }

}




















 extension CalendarVC: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomCell
        cell.dateLabel.text = cellState.text
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2017 01 01")!
        let endDate = formatter.date(from: "2019 12 31")!
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
    
    
    
 
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        cell.dateLabel.text = cellState.text
        
        
        handleCellSelected(cell: cell, CellState: cellState)
        handleCellTextColor(view: cell, CellState: cellState)
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(cell: cell, CellState: cellState)
        handleCellTextColor(view: cell, CellState: cellState)
    }
   
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(cell: cell, CellState: cellState)
        handleCellTextColor(view: cell, CellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        SetupViewsOfCalendar(from: visibleDates)
    }
}

extension UIColor {
    convenience init(colorWithHexValue value: Int, alpha:CGFloat = 1.0) {
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}


