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
    
    var name : String = ""
    var ingredients : List<Ingredient> = List<Ingredient>()
    var steps = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        print("name is \(name)")
        // Do any additional setup after loading the view.
    }


}
