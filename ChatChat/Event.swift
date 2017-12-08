//
//  File.swift
//  ChatChat
//
//  Created by David Maulick on 11/13/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import Foundation

class Event {
    //internal let id: String
    let title: String
    let description: String
    let whatToWear: String
    let channelName: String
    let channelKey: String
    //date -- so that can check with selection
    let date: Date
    //let startTime: Date?
    //let endTime: Date?
    
    // Based on which date cell is selected
    // pull date from cellstate
    // and update array used for tableview to be only the events that match the date
    
    init(title: String, description: String, whatToWear: String, channelName: String, channelKey: String, date: String) { //startTime: String, endTime: String) {
        //self.id = id
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        
        self.title = title
        self.description = description
        self.whatToWear =  whatToWear
        self.channelName = channelName
        self.channelKey = channelKey
        let dateTemp = dateFormatter.date(from: date)
        self.date = dateTemp!
        //self.startTime = dateFormatter.date(from: startTime)
        //self.endTime = dateFormatter.date(from: endTime)
        
        /*
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        formatter.timeStyle = .MediumStyle
        
        let dateString = formatter.stringFromDate(morningOfChristmas)*/
    }
    
    /*
    init(title: String, description: String, whatToWear: String, channelName: String, channelKey: String startTime: String, endTime: String) {
        //self.id = id
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        
        self.title = title
        self.description = description
        self.whatToWear =  whatToWear
        self.channelName = channelName
        self.channelKey = channelKey
        self.startTime = dateFormatter.date(from: startTime)
        self.endTime = dateFormatter.date(from: endTime)
        
        /*
         let formatter = NSDateFormatter()
         formatter.dateStyle = NSDateFormatterStyle.LongStyle
         formatter.timeStyle = .MediumStyle
         
         let dateString = formatter.stringFromDate(morningOfChristmas)*/
    }
    */
}
