//
//  SingleRecipeViewController.swift
//  iosDevelopmentA3
//
//  Created by Jemima on 28/5/2023.
//

import UIKit
import Foundation
import RealmSwift

class SingleRecipeViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var allIngredientsLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    
    var name : String = ""
    var ingredients : List<Ingredient> = List<Ingredient>()
    var steps = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        nameLabel.text = name
        allIngredientsLabel.text = "All ingredients steps "
        stepsLabel.numberOfLines = 10
        stepsLabel.text = steps
    }


}
