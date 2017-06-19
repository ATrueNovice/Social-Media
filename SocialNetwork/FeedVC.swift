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

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
    }

    


    @IBAction func buttonPressed(_ sender: Any) {

        let keychainMessage = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        try!  FIRAuth.auth()?.signOut()
        print("NOTE: Key Forgotten \(keychainMessage)")
        self.dismiss(animated: false, completion: nil)

    }












}
