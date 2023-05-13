//
//  NewIngredientController.swift
//  iosDevelopmentA3
//
//  Created by N K shadi samour on 13/5/2023.
//

import Foundation
import UIKit

class NewIngredientController: UIViewController {

    
    var ingredientListArray:[String] = UserDefaultManager.shared.defaults!.array(forKey: "IngredientList") as? [String] ?? []
    
   
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
       
    }

    
}




