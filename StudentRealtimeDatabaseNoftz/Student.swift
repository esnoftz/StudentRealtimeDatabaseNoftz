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
    
    var ref = Database.database().reference()

    
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
    
    func saveToFirebase() {
        let dict = ["name": name, "age": age] as [String: Any]
        ref.child("students2").childByAutoId().setValue(dict)

    }
    
    
    
    
}
