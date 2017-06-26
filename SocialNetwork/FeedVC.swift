//
//  FeedVC.swift
//  SocialNetwork
//
//  Created by New on 6/2/17.
//  Copyright © 2017 HSI. All rights reserved.
//

import UIKit

import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        //This code listens to hear if anything has changed. We put it in the View did load to make sure that the view updates when something changes.

        Dataservice.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    print("SNAP: \(snap)")

                    if let postDict = snap.value as? Dictionary<String, Any> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }

            self.tableView.reloadData()
        })

    }

    func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let post = posts[indexPath.row]

        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            cell.configureCell(post: post)

            return cell
        } else {
            return PostCell()
    }
    }
    


    @IBAction func buttonPressed(_ sender: Any) {

        let keychainMessage = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        try!  FIRAuth.auth()?.signOut()
        print("NOTE: Key Forgotten \(keychainMessage)")
        self.dismiss(animated: false, completion: nil)

    }

}
