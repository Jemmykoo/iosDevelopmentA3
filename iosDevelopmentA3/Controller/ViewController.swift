//
//  ViewController.swift
//  iosDevelopmentA3
//
//  Created by Jemima on 2/5/23.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet var buttonsStyling: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        for item in buttonsStyling {
            item.layer.cornerRadius = 10
        }
    }


}

