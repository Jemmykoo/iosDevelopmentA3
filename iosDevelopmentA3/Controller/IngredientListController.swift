//
//  IngredientListController.swift
//  iosDevelopmentA3
//
//  Created by N K shadi samour on 6/5/2023.
//

import Foundation
import UIKit
import RealmSwift

class IngredientListController: UIViewController {

    
    @IBOutlet weak var addItemButton: UIButton!
    @IBOutlet var buttonsStyling: [UIButton]!
    @IBOutlet weak var ingredientListTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try! Realm()
    
    var ingredientNameArray: [String] = ["Bread", "Egg", "Milk", "Apple", "Avacado", "Almond", "Apple juice", "Bannana", "Bacon", "Babaganoosh","Arugala","Artichoke","Bruscetta","Bagel","Baked beans","Black beans","Corn","Melon","Mango","Cherries","Broccoli","Cabbage","Greek Yogurt","Yogurt","Creame cheese","Pineapple","Plums","Black Olives","Green Olives","Tuna","Smoked Salmon","Salmon","Pasta","Spagetti","Red Onion","Onion","Soy sauce","Parmesan cheese","Oregano","Olive oil","Vegetable oil","Sessame oil","White rice","Brown rice","Potato","Peas","Zucchini","Zaartar","Labneh","Hummus","Feta","Sausages","Lettuce","Tomatos","Cucumber"]
    
   
    
    var ingredientListArray:[Ingredient] = []
    var ingredientListArraySearch:[Ingredient] = []
    
    var selectedIngredientListArray:[String] = []
    var hasSearched = false
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       
        
        writeDefaultIngredients()
        loadIngredients()
        //sort
        ingredientListArray.sort(by: { $0.name.lowercased() < $1.name.lowercased() })
      
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        ingredientListTableView.delegate = self
        ingredientListTableView.dataSource = self
        
        searchBar.delegate = self
    
       
        for item in buttonsStyling {
            item.layer.cornerRadius = 10
        }
    }

    
    
    @IBAction func addItemsToShoppingList(_ sender: UIButton) {
        
        for ingredientName in selectedIngredientListArray
        {
            for item in ingredientListArray
            {
                if(item.name == ingredientName)
                {
                    realm.beginWrite()
                    item.isInShoppingList = true
                    try! realm.commitWrite()
                    
                }
            }
        }
       
    }
    
    
    func loadIngredients()
    {
        
        ingredientListArray.removeAll()
        
        let data = realm.objects(Ingredient.self)
        
        for item in data {
            
            ingredientListArray.append(item)
        }
        
        //ingredientListArray.sort()
        ingredientListTableView.reloadData()
    }
    
    
    func writeDefaultIngredients()
    {
        if(realm.isEmpty) {
          
            for item in ingredientNameArray
            {
                let ingredient = Ingredient(item,1,false)
                
                try! realm.write {
                    realm.add(ingredient)
                }
            }
        }
    }
}

extension IngredientListController : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        hasSearched = true
        
        if(searchText.isEmpty){
            ingredientListArraySearch = ingredientListArray
        }else{
            ingredientListArraySearch = ingredientListArray.filter{$0.name.lowercased().contains(searchText.lowercased())}
        }
        
        
        ingredientListTableView.reloadData()
        
    }
}
    
extension IngredientListController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        let cell = tableView.cellForRow(at: indexPath)!

        
        selectedIngredientListArray.append((cell.textLabel?.text)!)
     
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)!
        
        var count = 0
        for item in selectedIngredientListArray
        {
            if item == cell.textLabel?.text
            {
                selectedIngredientListArray.remove(at: count)
            }

            count += 1
        }
    }
    
}

extension IngredientListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if(hasSearched) {
          return ingredientListArraySearch.count
        }
        
        return ingredientListArray.count

        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
       
        cell.textLabel?.text = ingredientListArray[indexPath.row].name
        
        if(hasSearched) {
            cell.textLabel?.text = ingredientListArraySearch[indexPath.row].name
        }
        
        

        return cell
    }
    
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return .delete
//    }
//    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        
//        if editingStyle == .delete
//        {
//            ingredientListTableView.beginUpdates()
//            if(hasSearched) {
//                ingredientListArraySearch.remove(at: indexPath.row)
//            }
//            else {
//                ingredientListArray.remove(at: indexPath.row)
//            }
//            
//            print(ingredientListArray)
//            
//            ingredientListTableView.deleteRows(at: [indexPath], with: .fade)
//            
//            ingredientListTableView.endUpdates()
//            
//            //ingredientListTableView.reloadData()
//            
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//           
//            let data = realm.objects(Ingredient.self)
//            
//            for item in data {
//                
//                if item.name == cell.textLabel?.text
//                {
//                    try! realm.write {
//                        realm.delete(item)
//                    }
//                }
//            }
//        }
//    }
    
}

