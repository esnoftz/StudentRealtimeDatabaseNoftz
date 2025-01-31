//
//  ViewController.swift
//  StudentRealtimeDatabaseNoftz
//
//  Created by EVANGELINE NOFTZ on 1/30/25.
//

import UIKit
import FirebaseCore
import FirebaseDatabase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var nameOutlet: UITextField!
    
    @IBOutlet weak var namesTableView: UITableView!
    
    
    var ref: DatabaseReference!

    var names: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        
        ref.child("students").observe(.childAdded, with: { (snapshot) in
                   // snapshot is a dictionary with a key and a value
                    
                    // this gets each name from each snapshot
                    let n = snapshot.value as! String
                    // adds the name to an array if the name is not already there
                    if !self.names.contains(n){
                        self.names.append(n)
                    }
                })
        
        //called after .childAdded is done
                ref.child("students").observeSingleEvent(of: .value, with: { snapshot in
                        print("--inital load has completed and the last user was read--")
                    print(self.names)
                    })



    }
    
    
    @IBAction func submitNameAction(_ sender: UIButton) {
        var name = nameOutlet.text
        
        // creates key called students if it doesn't find one
        // ref gets you to the database
        ref.child("students").childByAutoId().setValue(name)

    }
    


}

