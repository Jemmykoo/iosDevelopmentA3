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
        print("\(ingredientString) is the ingredient string")
        return ingredientString
    }


}
