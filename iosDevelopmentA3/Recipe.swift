//
//  Recipe.swift
//  iosDevelopmentA3
//
//  Created by Jemima on 27/5/2023.
//

import Foundation
import RealmSwift

class Recipe : Object {

    @objc dynamic var name: String = ""
    var ingredients  = List<Ingredient>()
    var steps : String = ""

    convenience init(_ name: String ,_ ingredients : List<Ingredient>, _ steps: String) {
        self.init()
        self.name = name
        self.ingredients = ingredients
        self.steps = steps

    }
}
