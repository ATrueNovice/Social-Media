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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageAdd: CircleView!


    var posts = [Post]()
    var imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self

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

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
                imageAdd.image = image
            } else {
                print("NOTE: A Vaild Image Was Not Selected!")

            }
            imagePicker.dismiss(animated: true, completion: nil)
        }
    }
    


    @IBAction func addImageTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }


    @IBAction func buttonPressed(_ sender: Any) {

        let keychainMessage = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        try!  FIRAuth.auth()?.signOut()
        print("NOTE: Key Forgotten \(keychainMessage)")
        self.dismiss(animated: false, completion: nil)

    }

}
