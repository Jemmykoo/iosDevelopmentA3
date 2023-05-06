//
//  IngredientListController.swift
//  iosDevelopmentA3
//
//  Created by N K shadi samour on 6/5/2023.
//

import Foundation
import UIKit

class IngredientListController: UIViewController {

    
    @IBOutlet var buttonsStyling: [UIButton]!
    @IBOutlet weak var ingredientListTableView: UITableView!
    
    var ingredientListArray:[String] = []
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        ingredientListTableView.delegate = self
        ingredientListTableView.dataSource = self
        
    
        for item in buttonsStyling {
            item.layer.cornerRadius = 10
        }
    }

}


extension IngredientListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("selected")
     
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

