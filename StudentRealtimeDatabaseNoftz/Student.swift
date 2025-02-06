//
//  Student.swift
//  StudentRealtimeDatabaseNoftz
//
//  Created by EVANGELINE NOFTZ on 2/4/25.
//

import Foundation
import FirebaseCore
import FirebaseDatabase

class Student {
    var name: String
    var age: Int
    var key = ""
    
    var ref = Database.database().reference()

    
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
    init(dict: [String: Any]) {
        // Safely unwrapping values from dictionary
        if let a = dict["age"] as? Int{
            age = a
        } else {
            age = 0
        }
        
        if let n = dict["name"] as? String{
            name = n
        } else {
            name = ""
        }

    }
    
    func saveToFirebase() {
        let dict = ["name": name, "age": age] as [String: Any]
        ref.child("students2").childByAutoId().setValue(dict)
        key = ref.child("students2").childByAutoId().key ?? "0"

    }
    
    func deleteFromFirebase() {
        ref.child("students2").child(key).removeValue()
    }
    
    
    
    
}
