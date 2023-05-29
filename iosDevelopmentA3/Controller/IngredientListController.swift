//
//  IngredientListController.swift
//  iosDevelopmentA3
//
//  Created by N K shadi samour on 6/5/2023.
//

import Foundation
import UIKit
import RealmSwift

class IngredientListController: UIViewController {

    @IBOutlet weak var addItemButton: UIButton!
    @IBOutlet var buttonsStyling: [UIButton]!
    @IBOutlet weak var ingredientListTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    let realm = try! Realm()
    var ingredientListArray: [Ingredient] = []
    var ingredientListArraySearch: [Ingredient] = []
    var selectedIngredientListArray: [Ingredient] = []
    var hasSearched = false

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadIngredients()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        ingredientListTableView.delegate = self
        ingredientListTableView.dataSource = self
        searchBar.delegate = self
        resetSelected()

        for item in buttonsStyling {
            item.layer.cornerRadius = 10
        }
    }

    // append all ingredients that have isSelected = true into selectedIngredientArray
    func loadSelectedIngredients() {
        selectedIngredientListArray.removeAll()
        for item in ingredientListArray
        {
            if item.isSelected {
                selectedIngredientListArray.append(item)
            }
        }
    }

    // if selected ingredients is empty do nothing, otherwise if ingredient is in shopping list, increment quantity, if it's not, then set isInShoppingList true
    @IBAction func addItemsToShoppingList(_ sender: UIButton) {

        loadSelectedIngredients()

        if selectedIngredientListArray.isEmpty {
            let alert = UIAlertController(title: "No items selected", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: "Default action"), style: .default, handler: { _ in
                    // no items selected
                }))
            self.present(alert, animated: true, completion: nil)

        } else {

            let alert = UIAlertController(title: "Successfully Added", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: "Default action"), style: .default, handler: { [self] _ in

                    for ingredient in selectedIngredientListArray {
                        realm.beginWrite()
                        if(ingredient.isInShoppingList) {
                            ingredient.quantity += 1
                        } else {
                            ingredient.isInShoppingList = true
                        }
                        try! realm.commitWrite()
                    }

                }))
            self.present(alert, animated: true, completion: nil)
        }
    }

    //reset selected ingredients ( set isSelected to false on all ingredients that are currently true)
    func resetSelected()
    {
        let ingredients = realm.objects(Ingredient.self)
        let selectedIngredients = ingredients.where {
            $0.isSelected == true
        }

        for item in selectedIngredients
        {
            try! realm.write {
                item.isSelected = false
            }

        }
    }

    // load all ingredients from realm into ingredientListArray - sort them
    func loadIngredients() {

        ingredientListArray.removeAll()
        let ingredients = realm.objects(Ingredient.self)

        for item in ingredients {
            ingredientListArray.append(item)
        }

        ingredientListArray.sort(by: { $0.name.lowercased() < $1.name.lowercased() })
        //reset search bar to current searchbar.text, this fixed issue where tableview wouldn't show recently added ingredient if searching
        searchBar(self.searchBar, textDidChange: searchBar.text!)
        ingredientListTableView.reloadData()
    }
}

extension IngredientListController: UISearchBarDelegate {
    //set hasSearched to true, if searchText is empty, ingredientListArraySearch is a copy of ingredientListArray, otherwise IngredientListArraySearch contains filtered data according to searchTextt ignoring capitalisation
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        hasSearched = true

        if(searchText.isEmpty) {
            ingredientListArraySearch = ingredientListArray
        } else {
            ingredientListArraySearch = ingredientListArray.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }

        ingredientListTableView.reloadData()
    }
}

extension IngredientListController: UITableViewDelegate {

    // when user selects cell, set the corisponding ingredients IsSelected property to true
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

    // when user selects cell, set the corisponding ingredients IsSelected property to false
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

// return arrays count for number of rows in tableview dpending on if search is true or false
extension IngredientListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if(hasSearched) {
            return ingredientListArraySearch.count
        }

        return ingredientListArray.count
    }

    // populate cell depending on if search is true / false. Also set selected depending if ingredient isSelected is true / false
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

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {

        return .delete
    }

    // delete ingredient from realm that matches cells unique text label then update tableview and remove corresponding ingredient from ingredientListArray and/or ingredientListArraySearch depending on if hasSearched is true / false
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

            ingredientListTableView.beginUpdates()

            if(hasSearched) {
                let itemToRemove = ingredientListArraySearch[indexPath.row]
                let itemToRemoveIndex = ingredientListArray.firstIndex(of: itemToRemove)!
                ingredientListArray.remove(at: itemToRemoveIndex)
                ingredientListArraySearch.remove(at: indexPath.row)
            } else {
                ingredientListArray.remove(at: indexPath.row)
            }

            ingredientListTableView.deleteRows(at: [indexPath], with: .fade)
            ingredientListTableView.endUpdates()
        }
    }
}

