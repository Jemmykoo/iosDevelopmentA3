//
//  NewIngredientController.swift
//  iosDevelopmentA3
//
//  Created by N K shadi samour on 13/5/2023.
//

import Foundation
import UIKit
import RealmSwift

class NewIngredientController: UIViewController {
    
   
    @IBOutlet weak var ingredientNameTextField: UITextField!
    @IBOutlet weak var addNewItemButton: UIButton!
    @IBOutlet weak var feedbackLabel: UILabel!
   
    let realm = try! Realm()
    var ingredientListArray:[Ingredient] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    
    @IBAction func addNewItem(_ sender: UIButton) {
        
        loadIngredients()
        let ingredientName = ingredientNameTextField.text!
        let newIngredient = Ingredient(ingredientName,1,false)
        var hasIngredient = false
        
        for item in ingredientListArray
        {
            if(item.name.lowercased() == newIngredient.name.lowercased())
            {
                hasIngredient = true
            }
        }
    
        if (hasIngredient == false)
        {
            if newIngredient.name == ""
            {
                feedbackLabel.text = "Please enter name"
            }
            else
            {
                try! realm.write{
                    realm.add(newIngredient)
                }
                
                feedbackLabel.text = "Ingredient Added"
            }
            
   
        }
        else {
            feedbackLabel.text = "Ingredient Exists"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { self.feedbackLabel.text = ""}
    }
    
    func loadIngredients()
    {
        ingredientListArray.removeAll()
        let data = realm.objects(Ingredient.self)
        
        for item in data {
            
            ingredientListArray.append(item)
        }
    }
}






