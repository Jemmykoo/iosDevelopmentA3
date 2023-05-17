//
//  ShoppingListController.swift
//  iosDevelopmentA3
//
//  Created by N K shadi samour on 6/5/2023.
//

import Foundation
import UIKit
import RealmSwift

class ShoppingListController: UIViewController {

    
    @IBOutlet var buttonsStyling: [UIButton]!
    @IBOutlet weak var shoppingListTableView: UITableView!
    
    let realm = try! Realm()
    
    var shoppingListItemsArray:[Ingredient] = []
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadSelectedIngredients()
        
        }


    override func viewDidLoad() {
        super.viewDidLoad()
        shoppingListTableView.delegate = self
        shoppingListTableView.dataSource = self
        
        
        
    
        for item in buttonsStyling {
            item.layer.cornerRadius = 10
        }
    }

    
    
    @IBAction func clearShoppingList(_ sender: UIButton) {
        
        for item in shoppingListItemsArray
        {
            realm.beginWrite()
            item.selected = false
            try! realm.commitWrite()
        }
        
        loadSelectedIngredients()
        shoppingListTableView.reloadData()
    }
    
    func loadSelectedIngredients()
    {
        
            shoppingListItemsArray.removeAll()
            
            let data = realm.objects(Ingredient.self)
            
            for item in data {
                
                if(item.selected)
                {
                    shoppingListItemsArray.append(item)
                }
             
            }
            
            //ingredientListArray.sort()
            shoppingListTableView.reloadData()
        }
    
    
}


extension ShoppingListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
        
     
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
        
    }
}

extension ShoppingListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingListItemsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = shoppingListItemsArray[indexPath.row].name

        return cell
    }
}
