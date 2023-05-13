//
//  IngredientListController.swift
//  iosDevelopmentA3
//
//  Created by N K shadi samour on 6/5/2023.
//

import Foundation
import UIKit

class IngredientListController: UIViewController {

    
    @IBOutlet weak var addItemButton: UIButton!
    @IBOutlet var buttonsStyling: [UIButton]!
    @IBOutlet weak var ingredientListTableView: UITableView!
    
    @IBOutlet weak var feedbackLabel: UILabel!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var ingredientListArray:[String] = UserDefaultManager.shared.defaults!.array(forKey: "IngredientList") as? [String] ?? []
    
    var ingredientListArrayDefault = ["Bread", "Egg", "Milk", "Apple", "Avacado", "Almond", "Apple juice", "Bannana", "Bacon", "Babaganoosh","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""]
    
    var ingredientListArraySearch:[String] = []
    var selectedIngredientListArray:[String] = []
    var hasSearched = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        ingredientListArray.sort()
        ingredientListArrayDefault.sort()
        
        if(ingredientListArray.isEmpty)
        {
            ingredientListArray.append(contentsOf: ingredientListArrayDefault)
            UserDefaultManager.shared.defaults!.set(ingredientListArrayDefault, forKey: "IngredientList")
        }
        
        ingredientListTableView.delegate = self
        ingredientListTableView.dataSource = self
        searchBar.delegate = self
    
        for item in buttonsStyling {
            item.layer.cornerRadius = 10
        }
    }

    
    
    @IBAction func addItemsToShoppingList(_ sender: UIButton) {
        
    
        var shoppingList = UserDefaultManager.shared.defaults!.array(forKey: "ShoppingList") as? [String] ?? []
        
        if shoppingList.isEmpty {
            UserDefaultManager.shared.defaults!.set(selectedIngredientListArray, forKey: "ShoppingList")
        
        } else
        {
            shoppingList.append(contentsOf: selectedIngredientListArray)
            UserDefaultManager.shared.defaults!.set(shoppingList, forKey: "ShoppingList")
        }
       
        feedbackLabel.text = "Items Added"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { self.feedbackLabel.text = ""}
    }
    
}

extension IngredientListController : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        hasSearched = true
        
        if(searchText.isEmpty){
            ingredientListArraySearch = ingredientListArray
        }else{
            ingredientListArraySearch = ingredientListArray.filter{$0.lowercased().contains(searchText.lowercased())}
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
        for item in selectedIngredientListArray
        {
            if item == cell.textLabel?.text
            {
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
       
        cell.textLabel?.text = ingredientListArray[indexPath.row]
        
        if(hasSearched) {
            cell.textLabel?.text = ingredientListArraySearch[indexPath.row]
        }
        
        

        return cell
    }
}

