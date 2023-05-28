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
    @IBOutlet weak var newRecipeStepsField: UITextField!
    @IBOutlet weak var newRecipeSaveButton: UIButton!
    @IBOutlet weak var newRecipeMultiSelect: UITableView!
    
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
        // Do any additional setup after loading the view.
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
        let cell = tableView.cellForRow(at: indexPath)!
        selectedIngredientListArray.append((cell.textLabel?.text)!)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        print(selectedIngredientListArray)
        for (index, item) in selectedIngredientListArray.enumerated() {
            if item == cell.textLabel?.text {
                selectedIngredientListArray.remove(at: index)
            }
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
        }
        return cell
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(.delete == editingStyle) {
            let cell = tableView.cellForRow(at: indexPath)!
            let data = realm.objects(Ingredient.self)
            for item in data {
                if item.name == cell.textLabel?.text {
                    try! realm.write {
                        realm.delete(item)
                    }
                    break
                }
            }
            newRecipeMultiSelect.beginUpdates()
            if(hasSearched) {
                let itemToRemove = ingredientListArraySearch[indexPath.row]
                let itemToRemoveIndex = ingredientListArray.firstIndex(of: itemToRemove)!
                ingredientListArray.remove(at: itemToRemoveIndex)
                ingredientListArraySearch.remove(at: indexPath.row)
            } else {
                ingredientListArray.remove(at: indexPath.row)
            }
            newRecipeMultiSelect.deleteRows(at: [indexPath], with: .fade)
            newRecipeMultiSelect.endUpdates()
        }
    }
}

