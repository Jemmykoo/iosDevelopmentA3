//
//  SingleRecipeViewController.swift
//  iosDevelopmentA3
//
//  Created by Jemima on 28/5/2023.
//

import UIKit
import Foundation
import RealmSwift

class SingleRecipeViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var allIngredientsLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var addToShoppingListButton: UIButton!
    
    let realm = try! Realm()

    var name : String = ""
    var ingredients : List<Ingredient> = List<Ingredient>()
    var steps = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        let ingredientString : String = loadIngredients()
        stepsLabel.numberOfLines = 10
        allIngredientsLabel.numberOfLines = 10
        nameLabel.text = "Recipe Name: \(name)"
        allIngredientsLabel.text = "Ingredients:\(ingredientString) "
        stepsLabel.text = "Steps:\n\(steps)"
    }
    
    func loadIngredients() -> String{
        var ingredientString:String = ""
        for item in ingredients{
            ingredientString = "\(ingredientString)\n- \(item.name)"
        }
        return ingredientString
    }

    @IBAction func AddToShoppingList(_ sender: Any) {
        for item in ingredients {
            if(item.isInShoppingList) {
                try! realm.write {
                    item.quantity += 1
                }
            } else {
                try! realm.write {
                    item.isInShoppingList = true
                }
            }

        }
        let alert = UIAlertController(title: "The ingredients in this recipe have all been added to your shopping list.", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: "Default action"), style: .default, handler: { _ in
                        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}
