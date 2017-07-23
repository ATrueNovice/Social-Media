//
//  DataServices.swift
//  SocialNetwork
//
//  Created by New on 6/21/17.
//  Copyright © 2017 HSI. All rights reserved.
//

//This code allows us to put posts, users, and content into a data base that will allow us to retreive later.

//Here we are creating a singleton class that can be referenced by any view controller.

import Foundation
import Firebase
import SwiftKeychainWrapper

let DB_BASE = FIRDatabase.database().reference()
//This code gets the database from the Google service Plist. This houses the URL to the firebase file.

let STORAGE_BASE = FIRStorage.storage().reference()
//Tells the app where to pull data from.

class Dataservice {

    static let ds = Dataservice()

    //DB References

    private var _REF_BASE = DB_BASE

    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")


    //These two make a reference to the link to the actual database (DB_Base) and then the name of the array, in the parenthesis, to start with.


    //Storage References

    private var _REF_POST_IMAGES = STORAGE_BASE.child("post-pics")
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }

    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }

    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }

    var REF_POST_IMAGES: FIRStorageReference {
        return _REF_POST_IMAGES
    }

    var REF_USER_CURRENT: FIRDatabaseReference{
        let  uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        let user = REF_USERS.child(uid!)
        return user
    }


    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        //This function creates a new user based on the parameters uid & userdata to build out the array. Thats why we put userData as a dictionary. To add likes, photos, and other information based on the array in the data base.
        
        REF_USERS.child(uid).updateChildValues(userData)

    }

}
