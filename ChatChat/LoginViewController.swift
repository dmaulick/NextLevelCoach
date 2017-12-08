/*
* Copyright (c) 2015 Razeware LLC
* Author: David Maulick
*/

import UIKit
import Firebase
import GoogleSignIn


class LoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var bottomLayoutGuideConstraint: NSLayoutConstraint!
  

    // MARK: View Lifecycle ----------------------------------View Lifecycle-----------------------------------------------View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            GIDSignIn.sharedInstance().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            return
        }
        print("Successfully Logged last user out")
        
        let googleSignInButton = GIDSignInButton()
        googleSignInButton.frame = CGRect(x: 16, y: 300, width: view.frame.width - 32, height: 50)
        view.addSubview(googleSignInButton)
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShowNotification(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHideNotification(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
  
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    // Log in via Google ------------------------------------------Log in via Google----------------------------------------Log in via Google
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        
        if let error = error {
            print("There was an error with the user's initial sign in. \(error)")
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            // authenticate credential
            if let error = error {
                print("There was an error with the user's credentials: \(error)")
                return
            }
        }
        print("Successfully logged into Next Level Coach")
        performSegue(withIdentifier: "LoginToChat", sender: nil)
    }
  
    // MARK: - Notifications -----------------------------------Notifications-----------------------------------------------Notifications
  
    @objc func keyboardWillShowNotification(_ notification: Notification) {
        let keyboardEndFrame = ((notification as NSNotification).userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let convertedKeyboardEndFrame = view.convert(keyboardEndFrame, from: view.window)
        bottomLayoutGuideConstraint.constant = view.bounds.maxY - convertedKeyboardEndFrame.minY
    }
  
    @objc func keyboardWillHideNotification(_ notification: Notification) {
        bottomLayoutGuideConstraint.constant = 48
    }
    
    
    // MARK: Navigation ----------------------------------------Navigation----------------------------------------------------Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        let makeUserVC = segue.destination as? CreateUserVC // 1
        makeUserVC?.usernameTemp = nameField?.text // 3
        
        
    }
  
}


