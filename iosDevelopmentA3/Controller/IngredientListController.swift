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
    
    
    var ingredientListArray:[String] = ["Bread", "Egg", "Milk", "Apple", "Avacado", "Almond", "Apple juice", "Bannana", "Bacon", "Babaganoosh"]
    
    var selectedIngredientListArray:[String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        ingredientListArray.sort()
        
        ingredientListTableView.delegate = self
        ingredientListTableView.dataSource = self
        
    
        for item in buttonsStyling {
            item.layer.cornerRadius = 10
        }
    }

    
    
    @IBAction func addItemsToShoppingList(_ sender: UIButton) {
        
        print(selectedIngredientListArray)
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
        return ingredientListArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = ingredientListArray[indexPath.row]

        return cell
    }
}

