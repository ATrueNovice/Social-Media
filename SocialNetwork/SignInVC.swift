//
//  ViewController.swift
//  SocialNetwork Workspace GroupSocialNetwork
//
//  Created by New on 5/21/17.
//  Copyright © 2017 HSI. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController {

    @IBOutlet weak var emailField: FancyText!
    @IBOutlet weak var passwordField: FancyText!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }

    //Pull Keychain here. If user has already been authenticated, the keychain will auto sign them in to the next page
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID){
        performSegue(withIdentifier: "goToFeed", sender: nil)
        print("NOTE: User ID Found In Keychain. Signing In")
    }
    }

    @IBAction func facebookBtnTapped(_ sender: Any) {

        let facebookLogin = FBSDKLoginManager()

        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
            print("NOTE: Unable to FB Authenticate")

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

                if let user = user {
                    let userData = ["provider": credential.provider]
                    self.completeSignIn(id: user.uid, userData: userData)
            }
        }
        })
    }
    //Email Authentication code
    @IBAction func SignInTapped(_ sender: Any) {
        if let email = emailField.text, let pwd = passwordField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil{
                    print("NOTE: Email User Authenticated W/ Firebase")
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }

                } else {
                    FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil{
                            print("NOTE: Unable To Authenticate Email User w/ Firebase")

                        } else {
                            print("NOTE: Successfully User Authenticated W/ Firebase")
                            if let user = user {
                                let userData = ["provider": user.providerID]
                                self.completeSignIn(id: user.uid, userData: userData)
                            }

                        }
                })
        }

    })
    }
}
    //Passed in parameters for function since we can no longer reach the object
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        Dataservice.ds.createFirebaseDBUser(uid: id, userData: userData)
       let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("NOTE: Data Saved to Keychain \(keychainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)


    }



}
