//
//  ViewController.swift
//  iosDevelopmentA3
//
//  Created by Jemima on 2/5/23.
//
import Foundation
import UIKit
import RealmSwift

class ViewController: UIViewController {

    
    @IBOutlet var buttonsStyling: [UIButton]!
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        //deleteRealmDataTestingFunctionality()
        
        for item in buttonsStyling {
            item.layer.cornerRadius = 10
        }
    }

    func deleteRealmDataTestingFunctionality()
    {
        try! realm.write {
            realm.deleteAll()
        }
    }
}

