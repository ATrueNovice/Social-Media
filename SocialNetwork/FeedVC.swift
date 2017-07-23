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
    @IBOutlet weak var captionField: FancyText!
    


    var posts = [Post]()
    var imagePicker = UIImagePickerController()
    static var imageCache: NSCache <NSString, UIImage> = NSCache()
    var imageSelected = false

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self

        //This code listens to hear if anything has changed. We put it in the View did load to make sure that the view updates when something changes.

        Dataservice.ds.REF_POSTS.observe(.value, with: { (snapshot) in

            self.posts = [] //Clear out the arrray everytime.

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

    //Update the table view with image, text and likes.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let post = posts[indexPath.row]

        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {


            if let img = FeedVC.imageCache.object(forKey: post.imageUrl as NSString) {
                cell.configureCell(post: post, img: img)
                return cell
            } else {
                cell.configureCell(post: post, img: nil)
                return cell
            }
        } else {
            return PostCell()
    }
}

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
                imageAdd.image = image
                imageSelected = true
            } else {
                print("NOTE: A Vaild Image Was Not Selected!")

            }
            imagePicker.dismiss(animated: true, completion: nil)
        }

    


    @IBAction func addImageTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func postBtnTapped(_ sender: Any) {
        guard let caption = captionField.text, caption != "" else {
            print("Note: Caption Must Be Entered")
            return
        }

        guard let img = imageAdd.image, imageSelected == true else {

            print("NOTE: An Image Must Be Selected")
            return
        }

        if let imgData = UIImageJPEGRepresentation(img, 0.2) {

            //Fill in explanation
            let imgUid = NSUUID().uuidString
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            Dataservice.ds.REF_POST_IMAGES.child(imgUid).put(imgData, metadata: metadata) { (metadata, error) in

                if error != nil {
                    print("NOTE: Unable to upload image to Firebase")
                } else {
                    print("NOTE: Successfully uploaded Image to Firebase")

                    let downloadURL = metadata?.downloadURL()?.absoluteString

                    if let url = downloadURL {

                    self.postToFirebase(imgUrl: url)
                    }
                }

            }
        }
    }

    //This posts data to firebase. Match the wording correctly!!!
    func postToFirebase(imgUrl: String) {
        let post: Dictionary<String, AnyObject> = [
            "caption": captionField.text! as AnyObject,
            "imageUrl": imgUrl as AnyObject,
            "likes": 0 as AnyObject
        ]

        //Sends post to firebase and creates an id automatically for the post.
        let firebasePost = Dataservice.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)

        //This code resets the value of the caption field to empty, image selected to none and, removes the selected image to set it back to the stock image.

        captionField.text = ""
        imageSelected = false
        imageAdd.image = UIImage(named: "add-image")


        //Sets table to the new value!
        tableView.reloadData()
    }

    @IBAction func buttonPressed(_ sender: Any) {

        let keychainMessage = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        try!  FIRAuth.auth()?.signOut()
        print("NOTE: Key Forgotten \(keychainMessage)")
        self.dismiss(animated: false, completion: nil)

    }

}
