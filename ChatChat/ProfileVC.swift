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
    
    
    @IBOutlet weak var Position: UILabel!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Username: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Position.text = "Position: \(user?.position ?? "No position")"
        Name.text = "\(user?.firstName ?? "First Name") \(user?.lastName ?? "Last Name")"
        Username.text = user?.username
        
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let photoURL = self.user?.photoURL
            let photoData = try? Data(contentsOf: photoURL!)
            let profileImage = UIImage(data: photoData!)
            
            DispatchQueue.main.async {
                self.userPhoto.image = profileImage
            }
        }
        
        let teamsButton = UIBarButtonItem(title: "Manage Teams", style: .plain, target: self, action: #selector(teamsBarItemClicked))
        self.navigationItem.rightBarButtonItem = teamsButton
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func teamsBarItemClicked() {
        performSegue(withIdentifier: "viewMyTeams", sender: nil)
    }
    
    // MARK: - Navigation

    
    @IBAction func unwindFromAdd(unwindSegue: UIStoryboardSegue){
        // This allows for unwind in detail view
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "viewMyTeams" {
            let manageTeamVC = segue.destination as! ManageTeamsVC
            manageTeamVC.user = user
            /*let embededViews = manageTeamVC.childViewControllers
            print("Children")
            print(embededViews.count)
            for view in embededViews {
                print("Classesss")
                let v = view.classForCoder
                print(v)
                manageTeamVC.first
            }*/
            
        }
    }
    

}
