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
    var ingredientListArray: [Ingredient] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        ingredientNameTextField.delegate = self
        addNewItemButton.layer.cornerRadius = 10
    }

    // add new ingredient to realm that user created
    @IBAction func addNewItem(_ sender: UIButton) {

        loadIngredients()
        // trim leading and trailing whitespace to avoid users entering blank strings and other negative consequences such as user having " Apple", "  Apple", "    Apple", etc.
        let ingredientName = ingredientNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        var hasIngredient = false

        for item in ingredientListArray {
            if(item.name.lowercased() == ingredientName.lowercased()) {
                hasIngredient = true
            }
        }
        
        // if ingredient doesn't exist in realm, and the new ingredients name is blank, display feedback
        if (hasIngredient == false) {
            if ingredientName == "" {
                let alert = UIAlertController(title: "Please enter valid name", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: "Default action"), style: .default, handler: { _ in
                        // Please enter valid name
                    }))
                self.present(alert, animated: true, completion: nil)

            } else {
                // name is not blank, create and write to realm
                let alert = UIAlertController(title: "Ingredient Added", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: "Default action"), style: .default, handler: { [self] _ in
                    
                        let newIngredient = Ingredient(ingredientName, 1, false)
                        try! realm.write {
                            realm.add(newIngredient)
                        }
                    
                    }))
                
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Ingredient already exists", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Okay", comment: "Default action"), style: .default, handler: { _ in
                    // ingredient already exists
                }))
            self.present(alert, animated: true, completion: nil)
        }
    }

    // load ingredients from realm into ingredient List Array
    func loadIngredients() {
        ingredientListArray.removeAll()
        let ingredients = realm.objects(Ingredient.self)

        for item in ingredients {
            ingredientListArray.append(item)
        }
    }
}

// limit characters in ingredientNameTextField to 26
extension NewIngredientController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentString = (textField.text ?? "") as NSString
        let replacementString = currentString.replacingCharacters(in: range, with: string)

        return replacementString.count <= 26
    }
}






