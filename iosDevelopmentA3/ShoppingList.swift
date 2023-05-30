//
//  ShoppingList.swift
//  iosDevelopmentA3
//
//  Created by N K shadi samour on 30/5/2023.
//

import Foundation
import RealmSwift

class ShoppingList: Object {

    @objc dynamic var name = ""
    var shoppingList = List<Ingredient>()

    convenience init(_ name: String, _ ingredients: List<Ingredient>) {
        self.init()
        self.name = name
        self.shoppingList = ingredients
    }
}

