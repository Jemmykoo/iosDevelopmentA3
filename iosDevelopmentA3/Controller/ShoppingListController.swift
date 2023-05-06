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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        for item in buttonsStyling {
            item.layer.cornerRadius = 10
        }
    }


}
