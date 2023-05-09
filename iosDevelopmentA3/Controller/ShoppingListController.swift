//
//  ShoppingListController.swift
//  iosDevelopmentA3
//
//  Created by N K shadi samour on 6/5/2023.
//

import Foundation
import UIKit

class ShoppingListController: UIViewController {

    
    @IBOutlet var buttonsStyling: [UIButton]!
    @IBOutlet weak var shoppingListTableView: UITableView!
    
    var shoppingListItemsArray:[String] = []
  
    
//    override func viewWillAppear() {
//        super.viewDidAppear(true)
//        print("hi")
//        
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        
        var shoppingList = UserDefaultManager.shared.defaults!.array(forKey: "ShoppingList") as? [String] ?? []

        shoppingListItemsArray.append(contentsOf: shoppingList)
        
      
        
        shoppingListTableView.delegate = self
        shoppingListTableView.dataSource = self
        
    
        for item in buttonsStyling {
            item.layer.cornerRadius = 10
        }
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
        cell.textLabel?.text = shoppingListItemsArray[indexPath.row]

        return cell
    }
}

