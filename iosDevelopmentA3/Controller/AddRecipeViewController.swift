//
//  AddRecipeViewController.swift
//  iosDevelopmentA3
//
//  Created by Jemima on 28/5/2023.
//

import UIKit
import Foundation
import RealmSwift

class AddRecipeViewController: UIViewController {
    
    
    @IBOutlet weak var newRecipeNameField: UITextField!
    @IBOutlet weak var newRecipeSearchBar: UISearchBar!
    @IBOutlet weak var newRecipeSaveButton: UIButton!
    @IBOutlet weak var newRecipeMultiSelect: UITableView!
    @IBOutlet weak var newRecipeStepsView: UITextView!
    
    let realm = try! Realm()
    var ingredientListArray: [Ingredient] = []
    var ingredientListArraySearch: [Ingredient] = []
    var selectedIngredientListArray: [String] = []
    var hasSearched = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadIngredients()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newRecipeMultiSelect.delegate = self
        newRecipeMultiSelect.dataSource = self
        newRecipeSearchBar.delegate = self
        
        resetSelected()
        newRecipeSaveButton.layer.cornerRadius = 10
    }
    
    func resetSelected() {
        let ingredients = realm.objects(Ingredient.self)
        let selectedIngredients = ingredients.where {
            $0.isSelected == true
        }

        for item in selectedIngredients {
            try! realm.write {
                item.isSelected = false
            }
        }
    }
    
    func loadSelectedIngredients() {
        selectedIngredientListArray.removeAll()
        for item in ingredientListArray
        {
            if item.isSelected {
                selectedIngredientListArray.append(item.name)
            }
        }
    }
    
    func loadIngredients() {
        ingredientListArray.removeAll()
        let ingredients = realm.objects(Ingredient.self)
        
        for item in ingredients {
            ingredientListArray.append(item)
        }
        
        ingredientListArray.sort(by: { $0.name.lowercased() < $1.name.lowercased() })
        newRecipeMultiSelect.reloadData()
    }
    
    @IBAction func saveRecipe(_ sender: Any) {
        
        loadSelectedIngredients()
        
        let newRecipeName = newRecipeNameField.text!
        let newRecipeSteps = newRecipeStepsView.text!
        if newRecipeName == ""  || newRecipeSteps == "" ||  selectedIngredientListArray.count < 1 {
            let alert = UIAlertController(title: "Please select your ingredients, fill out the steps and name your recipe.", message: "", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: "Default action"), style: .default, handler: { _ in
                            }))
            self.present(alert, animated: true, completion: nil)
        } else if recipeNameIsUsed() == true {
            let alert = UIAlertController(title: "Please name your recipe something unique.", message: "", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: "Default action"), style: .default, handler: { _ in
                            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            let newRecipeIngredients = generateIngredientsList()
            let recipeToSave = Recipe(newRecipeName, newRecipeIngredients, newRecipeSteps)
            try! realm.write {
                realm.add(recipeToSave)
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func recipeNameIsUsed() -> Bool {
        let data = realm.objects(Recipe.self)
        for item in data {
            if item.name == newRecipeNameField.text! {
                return true
            }
        }
        return false
    }
    
    func generateIngredientsList() -> List<Ingredient>{
        
        let ingredients = List<Ingredient>()
        for item in ingredientListArray {
            if selectedIngredientListArray.contains(item.name) {
                ingredients.append(item)
            }
        }
        return ingredients
    }
}

extension AddRecipeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        hasSearched = true
        if(searchText.isEmpty) {
            ingredientListArraySearch = ingredientListArray
        } else {
            ingredientListArraySearch = ingredientListArray.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        newRecipeMultiSelect.reloadData()
    }
}

extension AddRecipeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var ingredient = Ingredient()

        if hasSearched {
            ingredient = ingredientListArraySearch[indexPath.row]
        } else {
            ingredient = ingredientListArray[indexPath.row]
        }

        try! realm.write {
            ingredient.isSelected = true
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        var ingredient = Ingredient()

        if hasSearched {
            ingredient = ingredientListArraySearch[indexPath.row]
        } else {
            ingredient = ingredientListArray[indexPath.row]
        }

        try! realm.write {
            ingredient.isSelected = false
        }
    }
}

extension AddRecipeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(hasSearched) {
            return ingredientListArraySearch.count
        }
        return ingredientListArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = ingredientListArray[indexPath.row].name
        
        if(hasSearched) {
            cell.textLabel?.text = ingredientListArraySearch[indexPath.row].name
            if ingredientListArraySearch[indexPath.row].isSelected {
                cell.setSelected(true, animated: false)
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
        } else {
            if ingredientListArray[indexPath.row].isSelected {
                cell.setSelected(true, animated: false)
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
        }
        
        return cell
    }

}

