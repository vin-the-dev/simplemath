//
//  ViewController.swift
//  simplemath
//
//  Created by Vineeth Vijayan on 04/08/16.
//  Copyright © 2016 creativelogics. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import GoogleSignIn

class ViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {

    @IBOutlet weak var _lbl: UILabel!
    @IBOutlet weak var _btnGoogleSignIn: GIDSignInButton!
    @IBOutlet weak var _btnGoogleSignOut: UIButton!
    
    let usersRef = FIRDatabase.database().reference().child("users")
    let scoresRef = FIRDatabase.database().reference().child("scores")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.    }
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        _btnGoogleSignIn.isEnabled = true
        _btnGoogleSignOut.isEnabled = false
        
        
        if FIRAuth.auth()?.currentUser != nil {
            self._btnGoogleSignIn.isEnabled = false
            self._btnGoogleSignOut.isEnabled = true
        }
        
//        let defaults = UserDefaults.standard
//        if let idToken = defaults.value(forKey: UserDefaultsKey.GoogleCredentials_idToken_Key) as! String! {
//            if let accessToken = defaults.value(forKey: UserDefaultsKey.GoogleCredentials_accessToken_Key) as! String! {
//                
//                if let uId = defaults.value(forKey: UserDefaultsKey.GoogleCredentials_userId_Key) as! String! {
//                
//                
//
//                }
//            }
//        }
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if FIRAuth.auth()?.currentUser != nil {
            _lbl.text = "Welcome " + (FIRAuth.auth()?.currentUser?.displayName)!
            
            let userID = FIRAuth.auth()?.currentUser?.uid
            scoresRef.child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                
                print(snapshot.value!["score"]??.stringValue)
                
                if let score = snapshot.value!["score"]??.description {
                    if let totQ = snapshot.value!["totalQuestions"]??.description {
                        self._lbl.text = self._lbl.text! + " Score: " + score + "/" + totQ
                    }
                }
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }
            
//            if let strScore = scoresRef.child((FIRAuth.auth()?.currentUser?.uid)!) {
//                _lbl.text = strScore.value(forKey: "score") as? String
//            }
        }
        else{
            _lbl.text = "Not Logged in!!!"
        }

    }
    
    @IBAction func btnSignOutClicked(_ sender: AnyObject) {
        try! FIRAuth.auth()!.signOut()
        
        let defaults = UserDefaults.standard
        
        defaults.set("", forKey: UserDefaultsKey.GoogleCredentials_idToken_Key)
        defaults.set("", forKey: UserDefaultsKey.GoogleCredentials_accessToken_Key)
        
        _btnGoogleSignIn.isEnabled = true
        _btnGoogleSignOut.isEnabled = false
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Delegates

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: NSError!) {
        if error == nil {
            let authentication = user.authentication
            let credential = FIRGoogleAuthProvider.credential(withIDToken: (authentication?.idToken)!, accessToken: (authentication?.accessToken)!)
            
            
            FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                if user != nil {
                    let message = "Welcome " + (user?.displayName)!
                    
                    let defaults = UserDefaults.standard
                    
                    defaults.set(authentication?.idToken, forKey: UserDefaultsKey.GoogleCredentials_idToken_Key)
                    defaults.set(authentication?.accessToken, forKey: UserDefaultsKey.GoogleCredentials_accessToken_Key)
                    defaults.set(user?.uid, forKey: UserDefaultsKey.GoogleCredentials_userId_Key)
                    
                    let alert = UIAlertController(title: "Simple Math", message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
                    self.present(alert, animated: true){}
                    
//                    let alertView = UIAlertView(title: "Simple Math",
//                                                message: message,
//                                                delegate: nil,
//                                                cancelButtonTitle: "Ok",
//                                                otherButtonTitles: "")
//                    alertView.show()
                    
                    let userData: [String : AnyObject] = ["userName":  (user?.displayName)!,
                                                          "email": (user?.email)!]
                    
                    self.usersRef.child((user?.uid)!).setValue(userData)
                    
                    
                    let scoreData: [String : AnyObject] = ["score":  "0",
                                                          "totalQuestions": "0"]
                    
                    self.scoresRef.child((user?.uid)!).setValue(scoreData)
                    
                    
                    self._btnGoogleSignIn.isEnabled = false
                    self._btnGoogleSignOut.isEnabled = true
                }
            }
        }
    }
}

