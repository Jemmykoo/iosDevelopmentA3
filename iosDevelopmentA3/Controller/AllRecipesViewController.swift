//
//  AllRecipesViewController.swift
//  iosDevelopmentA3
//
//  Created by Jemima on 27/5/2023.
//

import UIKit
import Foundation
import RealmSwift

class AllRecipesViewController: UIViewController {
    
    
    let realm = try! Realm()
    var allRecipesArray: [Recipe] = [Recipe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
