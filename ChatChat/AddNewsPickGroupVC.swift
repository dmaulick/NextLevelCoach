//
//  AddNewsPickGroupVC.swift
//  ChatChat
//
//  Created by David Maulick on 11/19/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit
import Firebase

class AddNewsPickGroupVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    var user: User?
    var userGroupKeys: [String]?
    var userGroupNames: [String]?
    var curRowSelection: Int?
    
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    
    // MARK: View life cycles --------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for val in userGroupNames! {
            print("printing")
            print(val)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func AddEventButton(_ sender: Any) {
        performSegue(withIdentifier: "addEventSegue", sender: nil)
    }
    
    
    // MARK: UI Picker Datasource -----------------------------------------
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if userGroupKeys?.count != userGroupNames?.count {
            print("HUGEEE Warning!!: size of userGroupKeys and userGroupNames are not the same!!")
        }
        return userGroupNames!.count
    }
    
    
    // MARK: - UIPickerViewDelegate Methods
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        curRowSelection = row
        return self.userGroupNames?[row]
    }
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "addEventSegue" {
            let addVC = segue.destination as! AddEventVC
            let selectChannelName = userGroupNames![curRowSelection!]
            let selectChannelKey = userGroupKeys![curRowSelection!]
            
            addVC.user = self.user
            addVC.ChannelGroupName = selectChannelName
            addVC.ChannelGroupKey = selectChannelKey
            
        }
    }
 

}
