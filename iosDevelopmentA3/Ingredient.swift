//
//  Ingredient.swift
//  iosDevelopmentA3
//
//  Created by N K shadi samour on 12/5/2023.
//

import Foundation

struct Ingredient {
    
    var name: String
    var quantity: Int
    var selected: Bool
    
    init(_ name: String,_ quantity: Int,_ selected: Bool) {
        self.name = name
        self.quantity = quantity
        self.selected = selected
    }
    
    
}
