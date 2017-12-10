//
//  CreateTeamVC.swift
//  ChatChat
//
//  Created by David Maulick on 11/28/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit
import Firebase

class CreateTeamVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    enum imageNum: Int {
        case arsenal = 0
        case calPoly = 1
        case greenBay = 2
    }
    
    var imageEnumNum: Int = 0
    
    @IBOutlet weak var imageToggleOutlet: UIButton!
    @IBAction func ImageToggle(_ sender: Any) {
        imageToggleOutlet.alpha = 1.0
        imagePicked.alpha = 0.0
        
        if imageEnumNum == imageNum.arsenal.rawValue {
            imageToggleOutlet.setImage(#imageLiteral(resourceName: "cal-poly"), for: .normal)
            imageEnumNum = imageNum.calPoly.rawValue
        }
        else if imageEnumNum == imageNum.calPoly.rawValue {
            imageToggleOutlet.setImage(#imageLiteral(resourceName: "greenBay"), for: .normal)
            imageEnumNum = imageNum.greenBay.rawValue
        }
        else { //if imageEnumNum == imageNum.greenBay.rawValue {
            imageToggleOutlet.setImage(#imageLiteral(resourceName: "arsenal"), for: .normal)
            imageEnumNum = imageNum.arsenal.rawValue
        }
    }
    
    
    var parentVC: ManageTeamsVC?
    let storageRef = Storage.storage().reference()
    
    var user: User? {
        didSet {
            let tempUser = self.user
            print("User was Set!!!")
            print(tempUser?.firstName ?? ".. no first name... no user?")
            print(tempUser?.email ?? "....no email")
        }
    }
    
    private lazy var teamRef: DatabaseReference = Database.database().reference().child("Teams")
    private var teamRefHandle: DatabaseHandle?
    private lazy var userTeamKeysRef: DatabaseReference = Database.database().reference().child("userToTeamKeys")
    
    @IBOutlet weak var newTeamNameTextField: UITextField!
    @IBOutlet weak var newTeamPWTextField: UITextField!
    
    
    @IBOutlet weak var imagePicked: UIImageView!
    
    
    @IBAction func openCameraButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func openPhotoLibButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
 
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        imageToggleOutlet.alpha = 0.0
        imagePicked.image = image
        imagePicked.alpha = 1.0
        
        dismiss(animated:true, completion: nil)
    }
    
    var sampleTeamEmblems: [UIImage] = [UIImage]()
    
    
    
    
    
    
    @IBOutlet weak var createTeamWarningLabel: UILabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        createTeamWarningLabel.alpha = 0.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageToggleOutlet.setImage(#imageLiteral(resourceName: "arsenal"), for: .normal)
        imageToggleOutlet.alpha = 1.0
        imagePicked.alpha = 0.0
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    @IBAction func createTeamButton(_ sender: Any) {
        
        
        
        if newTeamNameTextField.text != "" && newTeamPWTextField.text != "" {
            
            if let teamName = newTeamNameTextField?.text, let teamPW = newTeamPWTextField.text{
                
                let actualUser = self.user!
                
                let newTeamRef = self.teamRef.childByAutoId()
                let teamId = newTeamRef.key
                let userNewGroupKey = self.userTeamKeysRef.childByAutoId()
                
                
                // Create a storage reference from a storage service
                // Using storage for photos
                // https://stackoverflow.com/questions/37780672/uploading-images-from-uiimage-picker-onto-new-firebase-swift
                
                
                var data = Data()
                data = UIImageJPEGRepresentation(imageToggleOutlet.image(for: .normal)!, 0.8)!
                // set upload path
                let filePath = "TeamStorage/\(teamId)/teamPhoto"
                let metaData = StorageMetadata()
                metaData.contentType = "image/jpg"
                
                self.performSegue(withIdentifier: "CreatedTeamUnwind", sender: nil)
                self.storageRef.child(filePath).putData(data, metadata: metaData){(metaData,error) in
                    
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    else{
                        
                        //store downloadURL
                        let downloadURL = metaData!.downloadURL()!.absoluteString
                        //store downloadURL at database along with other fields
                        let TeamItem = [
                            "TeamName"      : teamName,
                            "TeamPassword"  : teamPW,
                            "teamPhoto": downloadURL
                        ]
                        
                        let userIdToTeamKeyItem = [
                            "userId"    : actualUser.userId,
                            "TeamId"    : teamId,
                            "TeamName"  : teamName,
                            "TeamPW"    : teamPW
                        ]
                        
                        newTeamRef.setValue(TeamItem)
                        userNewGroupKey.setValue(userIdToTeamKeyItem)
                        self.newTeamNameTextField?.text = ""
                        self.newTeamPWTextField?.text = ""
                        
                    }
                    
                }
            
            }
            
        }
        else {
            createTeamWarningLabel.alpha = 1.0
            createTeamWarningLabel.text = "Fill In text fields."
        }
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
