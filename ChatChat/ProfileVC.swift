//
//  profileVC.swift
//  ChatChat
//
//  Created by David Maulick on 11/14/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    var user: User?
    @IBOutlet weak var userPhoto: UIImageView!
    
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var LastName: UILabel!
    @IBOutlet weak var email: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        firstName.text = user?.firstName
        LastName.text = user?.lastName
        email.text = user?.email
        
        //let photoURL = user?.photoURL
        //let photoData = NSData(contentsOf: photoURL!)
        //userPhoto.image = UIImage(data: photoData! as Data)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func unwindFromAdd(unwindSegue: UIStoryboardSegue){
        // This allows for unwind in add Key view
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
