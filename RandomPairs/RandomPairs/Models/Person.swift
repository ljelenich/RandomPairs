//
//  Person.swift
//  RandomPairs
//
//  Created by LAURA JELENICH on 11/15/20.
//

import Foundation

class Person: Codable {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

extension Person: Equatable {
    static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.name == rhs.name
    }
}
