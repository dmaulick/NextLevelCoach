//
//  EventViewVC.swift
//  ChatChat
//
//  Created by David Maulick on 11/26/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit

class EventViewVC: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var whatToWearLabel: UILabel!
    
    @IBOutlet weak var channelLabel: UILabel!
    
    @IBOutlet weak var ChannelKey: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    var event: Event?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTextFields()
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setTextFields() {
        titleLabel.text = event!.title
        descriptionLabel.text = event!.description
        whatToWearLabel.text = event!.whatToWear
        channelLabel.text = event!.channelName
        ChannelKey.text = event!.channelKey
        dateLabel.text = "To be set"//event!.date
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
