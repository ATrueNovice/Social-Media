//
//  DataServices.swift
//  SocialNetwork
//
//  Created by New on 6/21/17.
//  Copyright © 2017 HSI. All rights reserved.
//

//Here we are creating a singleton class that can be referenced by any view controller.

import Foundation
import Firebase


let DB_BASE = FIRDatabase.database().reference()
//This code gets the database from the Google service Plist. This houses the URL to the firebase file.

class Dataservice {

    static let ds = Dataservice()

    private var _REF_BASE = DB_BASE

    private var _REF_POSTS = DB_BASE.child("post")
    private var _REF_USERS = DB_BASE.child("users")
    //These two make a reference to the link to the actual database (DB_Base) and then the name of the array, in the parenthesis, to start with.

    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }

    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }

    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }


    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        //This function creates a new user based on the parameters uid & userdata to build out the array. Thats why we put userData as a dictionary. To add likes, photos, and other information based on the array in the data base. 
        
        REF_USERS.child(uid).updateChildValues(userData)

    }


}
