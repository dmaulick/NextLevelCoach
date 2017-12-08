//
//  newGroupVC.swift
//  ChatChat
//
//  Created by David Maulick on 11/14/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit


class ManageTeamsVC: UIViewController {

    enum Segment: Int {
        case createTeam = 0
        case findTeam = 1
        case editTeam = 2
    }
    
    
    
    var embedCreateTeam: CreateTeamVC?
    var embedFindTeam: FindTeamVC?
    var embedEditTeam: EditTeamVC?
    
    var user: User? 
    
    @IBOutlet weak var createTeamView: UIView!
    @IBOutlet weak var FindTeamView: UIView!
    @IBOutlet weak var EditTeamView: UIView!
    
    @IBOutlet weak var segControl: UISegmentedControl!
    
    @IBAction func segChanged(_ sender: Any) {
        updatePage()
    }
    
    func updatePage() {
        let currentSegment = segControl.selectedSegmentIndex//.titleForSegment(at: segControl.selectedSegmentIndex)
    
        if currentSegment == Segment.createTeam.rawValue {
            print(Segment.createTeam.rawValue)
            createTeamView.isHidden = false
            FindTeamView.isHidden = true
            EditTeamView.isHidden = true
        }
        else if currentSegment == Segment.findTeam.rawValue {
            print(Segment.findTeam.rawValue)
            createTeamView.isHidden = true
            FindTeamView.isHidden = false
            EditTeamView.isHidden = true
        }
        else if currentSegment == Segment.editTeam.rawValue {
            print(Segment.editTeam.rawValue)
            createTeamView.isHidden = true
            FindTeamView.isHidden = true
            EditTeamView.isHidden = false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updatePage()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        
        // **********************
        // If using async data in parent VC that you want to pass to child
        // Pass child a reference to self
        if segue.identifier == "createTeam" {
            let createVC = segue.destination as! CreateTeamVC
            //createVC.parentVC = self
            createVC.user = self.user
        }
        else if segue.identifier == "findTeam" {
            let findVC = segue.destination as! FindTeamVC
            //findVC.parentVC = self
            findVC.user = self.user
        }
        else if segue.identifier == "editTeam" {
            let editVC = segue.destination as! EditTeamVC
            //editVC.user = self.user
            editVC.user = self.user
        }
    }
}
