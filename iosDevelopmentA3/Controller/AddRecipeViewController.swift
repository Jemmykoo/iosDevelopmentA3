//
//  AddRecipeViewController.swift
//  iosDevelopmentA3
//
//  Created by Jemima on 28/5/2023.
//

import UIKit

class AddRecipeViewController: UIViewController {

    
    @IBOutlet weak var newRecipeNameField: UITextField!
    @IBOutlet weak var newRecipeSearchBar: UISearchBar!
    @IBOutlet weak var newRceipeMultiSelect: UITableView!
    @IBOutlet weak var newRecipeStepsField: UITextField!
    @IBOutlet weak var newRecipeSaveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
