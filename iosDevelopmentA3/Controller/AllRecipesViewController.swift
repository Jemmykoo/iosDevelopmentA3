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
        print(recipes)
        if recipes.count < 1 {
            let steps = "1. Cut up the apples \n2. Add your pastry to the pie tin \n3. Add your apples to the pie tin \n3. Bake at 180"
            let ingredients  = applePieIngredients()
            let recipe = Recipe("Apple Pie",ingredients,steps)
            try! realm.write {
                realm.add(recipe)
            }
        }
        
    }
    
    func applePieIngredients() -> List<Ingredient>{
        let ingredients = realm.objects(Ingredient.self)
        let applePieIngredients = List<Ingredient>()
        if ingredients.count > 0 {
            for item in ingredients{
                if item.name == "Apple" || item.name == "Pastry" || item.name == "Sugar" || item.name == "Cinnamon" {
                    applePieIngredients.append(item)
                }
            }
        }
        return applePieIngredients
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
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SingleRecipeVC") as! SingleRecipeViewController
        var name = "Recipe Name"
        var ingredients = List<Ingredient>()
        var steps = "STEPS"

        if allRecipesArraySearch.count > 0 {
            print(allRecipesArraySearch[indexPath.row])
            name = allRecipesArraySearch[indexPath.row].name
            ingredients = allRecipesArraySearch[indexPath.row].ingredients
            steps = allRecipesArraySearch[indexPath.row].steps
        } else {
            print(allRecipesArray[indexPath.row])
            name = allRecipesArray[indexPath.row].name
            ingredients = allRecipesArray[indexPath.row].ingredients
            steps = allRecipesArray[indexPath.row].steps
        }
        
        vc.name = name
        vc.ingredients = ingredients
        vc.steps = steps
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//            let cell = tableView.cellForRow(at: indexPath)!
            
                  // Navigate on other view
               
//            var count = 0
//            for item in selectedRecipeListArray {
//                if item == cell.textLabel?.text {
//                    selectedRecipeListArray.remove(at: count)
//                }
//                count += 1
//            }

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
            let data = realm.objects(Recipe.self)
            
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
    
    


