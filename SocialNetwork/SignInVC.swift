//
//  ViewController.swift
//  SocialNetwork
//
//  Created by New on 5/21/17.
//  Copyright © 2017 HSI. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func facebookBtnTapped(_ sender: Any) {

        let facebookLogin = FBSDKLoginManager()

        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
            print("NOTE: Unable to Authenticate")

            } else if result?.isCancelled == true {
                print("NOTE: User Cancelled Authentication")
            } else {
                print("NOTE: User has been successfully Authenticated")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)

                //Created second but, called in here
                self.firebaseAuth(credential)
            }
        }
    }

    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in

            if error != nil {
                print("Note Unable to signin with Firebase -\(String(describing: error))")
            } else {
                print("Note: Successfully Authenticated with Firebase")
            }
        })
    }
    }
