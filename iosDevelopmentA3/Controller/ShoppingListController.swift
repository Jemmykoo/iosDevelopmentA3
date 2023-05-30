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
    var shoppingListItemsArray: [Ingredient] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadShoppingList()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        shoppingListTableView.delegate = self
        shoppingListTableView.dataSource = self

        for item in buttonsStyling {
            item.layer.cornerRadius = 10
        }
    }

    // clear shopping list via reseting Ingredients properties to default values and use alert to avoid user clicking by mistake
    @IBAction func clearShoppingList(_ sender: UIButton) {

        let alert = UIAlertController(title: "Warning", message: "Are you sure you want to clear shopping list", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: "Default action"), style: .default, handler: { _ in
            //do nothing
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: "Default action"), style: .default, handler: { [self] _ in
      
            for item in shoppingListItemsArray {
                realm.beginWrite()
                item.isInShoppingList = false
                item.isCheckedOff = false
               // item.quantity = 1
                try! realm.commitWrite()
            }

            loadShoppingList()
            shoppingListTableView.reloadData()
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

    // load ingredients from realm into shoppingListItemArray
    func loadShoppingList() {
        shoppingListItemsArray.removeAll()
        let ingredients = realm.objects(Ingredient.self)

        for item in ingredients {
            if(item.isInShoppingList) {
                shoppingListItemsArray.append(item)
            }
        }

        shoppingListItemsArray.sort(by: { $0.name.lowercased() < $1.name.lowercased() })
        shoppingListTableView.reloadData()
    }
}


extension ShoppingListController: UITableViewDelegate {
    
    // if user clicks "selects" row toggle ingredient isCheckedOff property and reload tableview
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let ingredient = shoppingListItemsArray[indexPath.row]

        if ingredient.isCheckedOff == false {
            try! realm.write {
                ingredient.isCheckedOff = true
            }
        } else {
            try! realm.write {
                ingredient.isCheckedOff = false
            }
        }

        tableView.reloadData()
    }

}

extension ShoppingListController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return shoppingListItemsArray.count
    }

    // populate cell data from shoppingListItemsArray, if ingredients quantity is greater than 1, display quantity. if ingredients property isCheckedOff is true, set cells accessoryType to checkmark, else none
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if shoppingListItemsArray[indexPath.row].quantity > 1 {
            cell.textLabel?.text = "\(shoppingListItemsArray[indexPath.row].name)"
            cell.detailTextLabel?.text = "(\(shoppingListItemsArray[indexPath.row].quantity))"
        } else {
            cell.textLabel?.text = "\(shoppingListItemsArray[indexPath.row].name)"
            cell.detailTextLabel?.text = ""
        }
        
        if shoppingListItemsArray[indexPath.row].isCheckedOff {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {

        return .delete
    }

    // remove cell from tableview and reset ingredient properties to default values
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if(.delete == editingStyle) {

            let cell = tableView.cellForRow(at: indexPath)!
            let ingredients = realm.objects(Ingredient.self)
            let ingName = cell.textLabel?.text
           
            for item in ingredients {
                if item.name == ingName {
                    try! realm.write {
                        item.isCheckedOff = false
                        item.isInShoppingList = false
                        //item.quantity = 1
                    }
                    break
                }
            }

            shoppingListTableView.beginUpdates()
            shoppingListItemsArray.remove(at: indexPath.row)
            shoppingListTableView.deleteRows(at: [indexPath], with: .fade)
            shoppingListTableView.endUpdates()
        }
    }
}
