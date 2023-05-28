//
//  ViewController.swift
//  iosDevelopmentA3
//
//  Created by Jemima on 2/5/23.
//
import Foundation
import UIKit
import RealmSwift

class ViewController: UIViewController {

    @IBOutlet var buttonsStyling: [UIButton]!

    var ingredientNameArray: [String] = ["Bread", "Egg", "Milk", "Apple", "Avacado", "Almond", "Apple juice", "Bannana", "Bacon",
        "Babaganoosh", "Arugala", "Artichoke", "Bruscetta", "Bagel", "Baked beans", "Black beans",
        "Corn", "Melon", "Mango", "Cherries", "Broccoli", "Cabbage", "Greek Yogurt", "Yogurt", "Blue Cheese",
        "Pineapple", "Plums", "Black Olives", "Green Olives", "Tuna", "Smoked Salmon", "Salmon", "Pasta",
        "Spagetti", "Red Onion", "Onion", "Soy sauce", "Parmesan Cheese", "Oregano", "Olive oil", "Vegetable oil",
        "Sessame oil", "White rice", "Brown rice", "Potato", "Peas", "Zucchini", "Zaartar", "Labneh", "Hummus", "Feta",
        "Sausages", "Lettuce", "Tomatos", "Cucumber"]
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()

        //print(Realm.Configuration.defaultConfiguration.fileURL)
        //deleteRealmDataTestingFunctionality()

        writeDefaultIngredients()
        
        for item in buttonsStyling {
            item.layer.cornerRadius = 10
        }
    }

    func writeDefaultIngredients() {
       
        let ingredients = realm.objects(Ingredient.self)
        
        if(ingredients.isEmpty) {

            for item in ingredientNameArray {
                let ingredient = Ingredient(item, 1, false)

                try! realm.write {
                    realm.add(ingredient)
                }
            }
        }
    }
    
    func deleteRealmDataTestingFunctionality() {
        try! realm.write {
            realm.deleteAll()
        }
    }
}

