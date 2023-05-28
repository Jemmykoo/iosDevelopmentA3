//
//  Ingredient.swift
//  iosDevelopmentA3
//
//  Created by N K shadi samour on 12/5/2023.
//

import Foundation
import RealmSwift

class Ingredient: Object {

    @objc dynamic var name: String = ""
    @objc dynamic var quantity: Int = 1
    @objc dynamic var isInShoppingList: Bool = false
    @objc dynamic var isCheckedOff: Bool = false
    @objc dynamic var isSelected: Bool = false
    
    convenience init(_ name: String, _ quantity: Int, _ isCheckedOff: Bool) {
        self.init()
        self.name = name
        self.quantity = quantity
        self.isInShoppingList = isCheckedOff
    }
}
