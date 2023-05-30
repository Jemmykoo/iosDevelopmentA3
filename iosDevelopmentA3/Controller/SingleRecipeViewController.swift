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
    
  
    @IBOutlet weak var recipeIngredientTableView: UITableView!
    @IBOutlet weak var addToShoppingListButton: UIButton!
    @IBOutlet weak var recipeStepsTextView: UITextView!
    
    let realm = try! Realm()

    var name : String = ""
    var ingredients : List<Ingredient> = List<Ingredient>()
    var steps = ""
    var recipeIngredientsArray: [Ingredient] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadRecipeIngredients()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeIngredientTableView.dataSource = self
        self.title = "Recipe: \(name)"
        recipeStepsTextView.text = "Steps:\n\(steps)"
        addToShoppingListButton.layer.cornerRadius = 10
    }
    
    func loadRecipeIngredients() {
        
        recipeIngredientsArray.removeAll()

        for item in ingredients {
            recipeIngredientsArray.append(item)
        }

        recipeIngredientTableView.reloadData()
        
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
                    item.quantity = 1
                }
            }

        }
        let alert = UIAlertController(title: "The ingredients in this recipe have all been added to your shopping list.", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: "Default action"), style: .default, handler: { _ in
                        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension SingleRecipeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return recipeIngredientsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        
        cell.textLabel?.text = "\(recipeIngredientsArray[indexPath.row].name)"
        
        
        return cell
    }
}
