//
//  SaveShoppingListController.swift
//  iosDevelopmentA3
//
//  Created by N K shadi samour on 30/5/2023.
//

import UIKit
import Foundation
import RealmSwift

class SaveShoppingListController: UIViewController {
    
    
    @IBOutlet weak var savedShoppingListableView: UITableView!
    @IBOutlet weak var saveNewShoppingListButton: UIButton!
    @IBOutlet weak var loadShoppingListButton: UIButton!
    @IBOutlet weak var shoppingListNameTextField: UITextField!
    
    let realm = try! Realm()
    
    var allShoppingListArray: [ShoppingList] = []
    var selectedShoppingList = ShoppingList()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        loadAllShoppingLists()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        savedShoppingListableView.delegate = self
        savedShoppingListableView.dataSource = self
        
    }
    
    @IBAction func saveShoppingListButton(_ sender: UIButton) {
        var nameExists = false
        let name = shoppingListNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        for item in allShoppingListArray {
            if item.name.lowercased() == name.lowercased() {
                nameExists = true
            }
        }
        
        if nameExists {
            let alert = UIAlertController(title: "Shopping List with same name exists", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: "Default action"), style: .default, handler: { _ in
                    // same name exists
                }))
            
            self.present(alert, animated: true, completion: nil)
        } else {
            
            if name == "" {
                let alert = UIAlertController(title: "Enter valid name", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: "Default action"), style: .default, handler: { _ in
                        // Please enter valid name
                    }))
                
                self.present(alert, animated: true, completion: nil)
            } else {
                let ingredientsInShoppingList = generateIngredientsList()
                
                if ingredientsInShoppingList.isEmpty {
                    let alert = UIAlertController(title: "Error: Shopping list empty", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: "Default action"), style: .default, handler: { _ in
                            return
                        }))
                    
                    self.present(alert, animated: true, completion: nil)
                }
                
                let alert = UIAlertController(title: "Shopping List Saved", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: "Default action"), style: .default, handler: { [self] _ in
                       
                     
                        let shoppingList = ShoppingList(name, ingredientsInShoppingList)
                        
                        try! realm.write {
                            realm.add(shoppingList)
                          
                        }
                        
                        loadAllShoppingLists()
                        savedShoppingListableView.reloadData()
                    
                    }))
                
                self.present(alert, animated: true, completion: nil)
                
            }
        }
    }
    
    @IBAction func loadSavedShoppingList(_ sender: UIButton) {
        
        if selectedShoppingList.shoppingList.isEmpty {
            let alert = UIAlertController(title: "Select Shopping list to load", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: "Default action"), style: .default, handler: { _ in
                    // select shopping list
                }))
            
            self.present(alert, animated: true, completion: nil)
        } else {
            
            let alert = UIAlertController(title: "Shopping List loaded", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: "Default action"), style: .default, handler: { [self] _ in
                    
                    let ingredients = realm.objects(Ingredient.self)
                    let currentShoppingListIngredients = ingredients.where {
                        $0.isInShoppingList == true
                    }
                    
                    for item in currentShoppingListIngredients {
                        try! realm.write {
                            item.isInShoppingList = false
                        }
                    }
                    
                    let list = selectedShoppingList.shoppingList
                    
                    for item in list {
                        try! realm.write {
                            item.isInShoppingList = true
                            item.isCheckedOff = false
                        }
                    }
                }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func generateIngredientsList() -> List<Ingredient>{
        
        let data = realm.objects(Ingredient.self)
        let ingredients = List<Ingredient>()
        
        for item in data {
            if item.isInShoppingList {
                ingredients.append(item)
            }
        }
        
        return ingredients
    }
    
    
    func loadAllShoppingLists() {
        
        allShoppingListArray.removeAll()
        let shoppingLists = realm.objects(ShoppingList.self)
        
        for item in shoppingLists {
            allShoppingListArray.append(item)
        }
        
        savedShoppingListableView.reloadData()
    }
    
}

extension SaveShoppingListController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        selectedShoppingList  = allShoppingListArray[indexPath.row]

    }
}

extension SaveShoppingListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return allShoppingListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = allShoppingListArray[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if(.delete == editingStyle) {
            
            let cell = tableView.cellForRow(at: indexPath)!
            let data = realm.objects(ShoppingList.self)
            
            for item in data {
                
                if item.name == cell.textLabel?.text {
                    try! realm.write {
                        realm.delete(item)
                    }
                    break
                }
            }
            
            savedShoppingListableView.beginUpdates()
            allShoppingListArray.remove(at: indexPath.row)
            savedShoppingListableView.deleteRows(at: [indexPath], with: .fade)
            savedShoppingListableView.endUpdates()
        }
    }
}
    
    



