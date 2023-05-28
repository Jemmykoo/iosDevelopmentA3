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
    var selectedIngredientListArray: [String] = []
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

        for item in buttonsStyling {
            item.layer.cornerRadius = 10
        }
    }

    @IBAction func addItemsToShoppingList(_ sender: UIButton) {

        if selectedIngredientListArray.isEmpty {
            let alert = UIAlertController(title: "No items selected", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: "Default action"), style: .default, handler: { _ in
                //do nothing
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            let alert = UIAlertController(title: "Successfully Added", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: "Default action"), style: .default, handler: { [self] _ in
          
                for ingredientName in selectedIngredientListArray {
                    for item in ingredientListArray {
                        if(item.name == ingredientName) {

                            realm.beginWrite()
                            if(item.isInShoppingList) {
                                item.quantity += 1
                            } else {
                                item.isInShoppingList = true
                            }
                            try! realm.commitWrite()
                        }
                    }
                }
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }


    func loadIngredients() {

        ingredientListArray.removeAll()

        let ingredients = realm.objects(Ingredient.self)

        for item in ingredients {

            ingredientListArray.append(item)
        }

        ingredientListArray.sort(by: { $0.name.lowercased() < $1.name.lowercased() })

        ingredientListTableView.reloadData()
    }

   
}

extension IngredientListController: UISearchBarDelegate {
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let cell = tableView.cellForRow(at: indexPath)!
        selectedIngredientListArray.append((cell.textLabel?.text)!)

    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {

        let cell = tableView.cellForRow(at: indexPath)!

        var count = 0
        for item in selectedIngredientListArray {
            if item == cell.textLabel?.text {
                selectedIngredientListArray.remove(at: count)
            }

            count += 1
        }
    }
}

extension IngredientListController: UITableViewDataSource {
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

