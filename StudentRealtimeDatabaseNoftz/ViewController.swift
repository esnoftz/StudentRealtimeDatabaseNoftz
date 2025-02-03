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

    var names = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        namesTableView.delegate = self
        namesTableView.dataSource = self

        
        ref = Database.database().reference()
        
        readFromFirebase()


    }
    
    
    @IBAction func submitNameAction(_ sender: UIButton) {
        var name = nameOutlet.text!
        
        // creates key called students if it doesn't find one
        // ref gets you to the database
        ref.child("students").childByAutoId().setValue(name)
        names.append(name)
        nameOutlet.text = ""

    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") as! NameCell
        cell.nameLabel.text = "\(names[indexPath.row])"
        return cell
    }
    
    
    
    func readFromFirebase() {
        // childAdded is called every time a child is added to database
        ref.child("students").observe(.childAdded, with: { (snapshot) in
            // snapshot is a dictionary with a key and a value
                    
            // this gets each name from each snapshot
            let n = snapshot.value as! String
            // adds the name to an array if the name is not already there
            self.names.append(n)
            //print(n)
            self.namesTableView.reloadData()
                    
                })
        
        // when this is printed, there's nothing in names yet (this happens BEFORE the observe function)
        print(names)
        
        
        //called after .childAdded is done
                ref.child("students").observeSingleEvent(of: .value, with: { snapshot in
                        print("--inital load has completed and the last user was read--")
                    print(self.names)
                    //self.namesTableView.reloadData()
                    })
    }
    


}

