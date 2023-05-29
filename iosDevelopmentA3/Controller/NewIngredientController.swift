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
                feedbackLabel.text = "Please enter name"
            } else {
                // name is not blank, create and write to realm
                let newIngredient = Ingredient(ingredientName, 1, false)
                try! realm.write {
                    realm.add(newIngredient)
                }

                feedbackLabel.text = "Ingredient Added"
            }
        } else {
            feedbackLabel.text = "Ingredient already exists"
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 4) { self.feedbackLabel.text = " " }
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






