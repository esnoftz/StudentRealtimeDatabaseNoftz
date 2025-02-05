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
    
    @IBOutlet weak var ageOutlet: UITextField!
    
    @IBOutlet weak var namesTableView: UITableView!
    
    
    var ref: DatabaseReference!

    var names = [String]()
    
    var students = [Student]()
    
    var index = -1
    
    var studentName = ""
    
    var studentAge = 0

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
    
    
    @IBAction func saveStudentAction(_ sender: UIButton) {
        var student = Student(name: nameOutlet.text!, age: Int(ageOutlet.text!)!)
        
        student.saveToFirebase()
        
        //ref.child("students2").childByAutoId().setValue(student)
        students.append(student)
                
        namesTableView.reloadData()
        
        //nameOutlet.text = ""
        //ageOutlet.text = ""
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return names.count
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") as! NameCell
        //cell.nameLabel.text = "\(names[indexPath.row])"
        
        studentName = cell.nameLabel.text!
        studentAge = Int(cell.ageLabel.text!)!
        
        cell.nameLabel.text = "\(students[indexPath.row].name)"
        cell.ageLabel.text = "\(students[indexPath.row].age)"
        
        index = indexPath.row
        
        return cell
    }
    
    
    
    func readFromFirebase() {
        // childAdded is called every time a child is added to database
        ref.child("students").observe(.childAdded, with: { (snapshot) in
            // snapshot is a dictionary with a key and a value
                    
            // this gets each name from each snapshot
            let n = snapshot.value as! String
            // adds the name to an array if the name is not already there
            if !self.names.contains(n){
                self.names.append(n)
            }
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
        
        
        // childAdded is called every time a child is added to database
        /*ref.child("students2").observe(.childAdded, with: { (snapshot) in
            print(snapshot)

            //let a = snapshot.value(forKey: "age") as! Int
            //let n = snapshot.value(forKey: "name") as! String

            /*if !self.students.contains(n){
                self.names.append(n)
            }*/
            //self.students.append(Student(name: n, age: a))
            //print(n)
            self.namesTableView.reloadData()
                    
        })
        
        // when this is printed, there's nothing in names yet (this happens BEFORE the observe function)
        print(names)
        
        
        //called after .childAdded is done
        ref.child("students2").observeSingleEvent(of: .value, with: { snapshot in
            print("--inital load has completed and the last user was read--")
            print(self.names)
            //self.namesTableView.reloadData()
        })*/
        

    }
    


}

