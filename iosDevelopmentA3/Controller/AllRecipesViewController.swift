//
//  AllRecipesViewController.swift
//  iosDevelopmentA3
//
//  Created by Jemima on 27/5/2023.
//

import UIKit
import Foundation
import RealmSwift

class AllRecipesViewController: UIViewController {
    
    
    @IBOutlet weak var allRecipesTableView: UITableView!
    @IBOutlet weak var allRecipesSearchBar: UISearchBar!
    
    let realm = try! Realm()
    var allRecipesArray: [Recipe] = [Recipe]()
    var allRecipesArraySearch: [Recipe] = []
    var selectedRecipeListArray: [String] = []
    var hasSearched = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        writeDefaultRecipes()
        loadAllRecipes()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allRecipesTableView.delegate = self
        allRecipesTableView.dataSource = self
        allRecipesSearchBar.delegate = self
        
//        for item in buttonsStyling {
//            item.layer.cornerRadius = 10
//        }
    }
    
    
    func loadAllRecipes() {
        allRecipesArray.removeAll()
        let recipes = realm.objects(Recipe.self)
        
        for item in recipes {
            allRecipesArray.append(item)
        }
        
        allRecipesArray.sort(by: { $0.name.lowercased() < $1.name.lowercased() })
        allRecipesTableView.reloadData()
    }
    
    func writeDefaultRecipes() {
        let recipes = realm.objects(Recipe.self)
        if recipes.count < 1 {
            let steps = "mix then bake"
            let ingredients  = List<Ingredient>()
            let recipe = Recipe("Apple Pie",ingredients,steps)
            
            try! realm.write {
                realm.add(recipe)
            }
        }
        
    }
}

    extension AllRecipesViewController: UISearchBarDelegate {
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

            hasSearched = true

            if(searchText.isEmpty) {
                allRecipesArraySearch  = allRecipesArray
            } else {
                allRecipesArraySearch = allRecipesArray.filter { $0.name.lowercased().contains(searchText.lowercased()) }
            }

            allRecipesTableView.reloadData()
        }
    }

    extension AllRecipesViewController: UITableViewDelegate {

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

            let cell = tableView.cellForRow(at: indexPath)!
            selectedRecipeListArray.append((cell.textLabel?.text)!)

        }

        func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {

            let cell = tableView.cellForRow(at: indexPath)!
            var count = 0
            for item in selectedRecipeListArray {
                if item == cell.textLabel?.text {
                    selectedRecipeListArray.remove(at: count)
                }
                count += 1
            }
        }
    }

extension AllRecipesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(hasSearched) {
            return allRecipesArraySearch.count
        }
        return allRecipesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = allRecipesArray[indexPath.row].name
        if(hasSearched) {
            cell.textLabel?.text = allRecipesArraySearch[indexPath.row].name
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
            allRecipesTableView.beginUpdates()
            if(hasSearched) {
                let itemToRemove = allRecipesArraySearch[indexPath.row]
                let itemToRemoveIndex = allRecipesArray.firstIndex(of: itemToRemove)!
                allRecipesArray.remove(at: itemToRemoveIndex)
                allRecipesArraySearch.remove(at: indexPath.row)
            } else {
                allRecipesArray.remove(at: indexPath.row)
            }
            allRecipesTableView.deleteRows(at: [indexPath], with: .fade)
            allRecipesTableView.endUpdates()
        }
    }
}
    
    


