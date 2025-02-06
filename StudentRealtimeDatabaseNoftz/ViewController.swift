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
        
        
        /*ref.child("students").observeSingleEvent(of: .value, with: { snapshot in
                        print("--inital load has completed and the last user was read--")
                    print(self.names)
                    })*/
        
        
        




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
        
        nameOutlet.text = ""
        ageOutlet.text = ""
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return names.count
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") as! NameCell
        //cell.nameLabel.text = "\(names[indexPath.row])"
        
       
        
        cell.nameLabel.text = "\(students[indexPath.row].name)"
        cell.ageLabel.text = "\(students[indexPath.row].age)"
        
        index = indexPath.row
        
        return cell
    }
    
    // swipe to delete on table view
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            students[indexPath.row].deleteFromFirebase()
            students.remove(at: indexPath.row)
            namesTableView.deleteRows(at: [indexPath], with: .fade)
            namesTableView.reloadData()
        } else if editingStyle == .insert {
            
        }
        
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
        
        
        
        
        // object
        ref.child("students2").observe(.childAdded, with: { (snapshot) in
            // snapshot is a dictionary with a key and a dictionary as a value
            // this gets the dictionary from each snapshot
            let dict = snapshot.value as! [String:Any]
                   
            // building a Student object from the dictionary
            let s = Student(dict: dict)
            
            s.key = snapshot.key

            // adding the student object to the Student array
            
            var yes = 0
            for stu in self.students {
                if stu.name == s.name && stu.age == s.age {
                    yes = 1
                }
            }
            if yes == 0 {
                self.students.append(s)
            }
            
            self.namesTableView.reloadData()
            // should only add the student if the student isn’t already in the array
            // good place to update the tableview also
                    
        })
        
        
        
        // CONTINUE FIGURE OUT THIS IS WHERE YOU LEFT OFF (9g in notes)
        // finding deleted objects
        ref.child("students2").observe(.childRemoved, with: { (snapshot) in
            // snapshot is a dictionary with a key and a dictionary as a value
            // this gets the dictionary from each snapshot
            let dict = snapshot.value as! [String:Any]
                   
            // building a Student object from the dictionary
            let s = Student(dict: dict)
            // adding the student object to the Student array
            self.students.append(s)
            self.namesTableView.reloadData()
            // should only add the student if the student isn’t already in the array
            // good place to update the tableview also
                    
        })
                

        

    }
    


}

