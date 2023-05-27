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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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

        for item in shoppingListItemsArray {
            realm.beginWrite()
            item.isInShoppingList = false
            item.isCheckedOff = false
            item.quantity = 1
            try! realm.commitWrite()
        }

        loadShoppingList()
        shoppingListTableView.reloadData()
    }

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

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if(.delete == editingStyle) {

            let cell = tableView.cellForRow(at: indexPath)!
            let ingredients = realm.objects(Ingredient.self)
            var ingName = cell.textLabel?.text
           
            
            for item in ingredients {
                if item.name == ingName {
                    try! realm.write {
                        item.isCheckedOff = false
                        item.isInShoppingList = false
                        item.quantity = 1
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
