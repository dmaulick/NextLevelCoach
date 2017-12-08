//
//  slideOutPrepPageVC.swift
//  ChatChat
//
//  Created by David Maulick on 11/28/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit
import Firebase

class slideOutPrepPageVC: SWRevealViewController {
    
    
    var username: String?
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation------------------------------------------------------
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "sw_front" {
            let navVc = segue.destination as! UINavigationController
            let HomeScreenVC = navVc.viewControllers.first as! HomeScreenVC
            HomeScreenVC.username = self.username
            HomeScreenVC.user = self.user
            //HomeScreenVC.fromExistingAccountVC = self.fromExistingAccountVC
        }
        if segue.identifier == "sw_rear" {
            let backTeamTableVC = segue.destination as! BackTableVC
        }
    }
}
