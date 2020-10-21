//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Noam Moyal on 14/07/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import Realm
import SwipeCellKit
import ChameleonFramework

class CategoryViewController: SwipeTableViewController  {// it used to inherit this until lesson 287 UITableViewController
    
    let realm = try! Realm()

    // var categories = [Category]() lesson 280 - this is not good anymore for realm it was good for core data
    var categories: Results<Category>?
    
  // lesson 280 - we use realm so no need for this anymore  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
        
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {fatalError("navigation controller does not exist")}
        navBar.backgroundColor = UIColor(hexString: "1D9BF6")
    }
    
    
    //MARK - TableView Datasource Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
   /* from cocopods lesson 286
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
        cell.delegate = self
        return cell
    }
 */
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       //lesson 287 we dont need this since we created the class SwipeTAbleViewController  and put this there  let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
         cell.textLabel?.text = categories?[indexPath.row].name ?? "no categories added yet"
        
        cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].colour ?? "1D9BF6" )
        
     // last lesson   cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: categories?[indexPath.row].colour ?? "1D9BF6") , returnFlat: true)
        
    //lesson 287 we dont need this since we created the class SwipeTAbleViewController  cell.delegate = self
        
        return cell
    }
    
    
    //MARK - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
        var textField = UITextField()
               
        let alert = UIAlertController(title: "add new category", message: "", preferredStyle: .alert)
               
        let action = UIAlertAction(title: "add item", style: .default) { (action) in
            
       // lesson 279 - used to be like this for core data let now we use realm newCategory =  Category(context: self.context)
        let newCategory = Category()
        newCategory.name = textField.text!
        newCategory.colour = UIColor.randomFlat().hexValue()
       // lesson 280 - no neeed with realm because it auto updates immediatly in realm while we need this code for Core DAta self.categories.append(newCategory)
        self.saveCategories(category: newCategory)
        
      }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            
        alertTextField.placeholder = "Create a new item"
        textField = alertTextField
        }
                     
        present(alert, animated: true, completion: nil)
       
    }
    
    
      //MARK - Data Manipulation Method
    func saveCategories(category: Category){
        do {
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("error caught")
           
        }
        /* lesson 279 used to be like this for core data and class didnt use to take category as input
          do {
              try context.save()
          }catch{
              print("error caught")
          }
 */
             
          self.tableView.reloadData()
      }
         
         
      func loadCategories(){
        
        categories = realm.objects(Category.self)
        
        
        /* lesson 279 - used to be like this for core data
          let request : NSFetchRequest<Category> = Category.fetchRequest()
        
             do{
             categories = try context.fetch(request)
             }catch{
                 print("error caught")
             }
        */
        tableView.reloadData()
         }

    //MARK - TableView Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
            
        }
    }
  //MARK: - Delete Data From Swipe
    override func updateModel(at indexPath: IndexPath) {
        super.updateModel(at: indexPath) // with this line of code we call update model of the Swipe Controller
        
        if let categoryForDeletion = self.categories?[indexPath.row]{
        do{
            try  self.realm.write{
                self.realm.delete(categoryForDeletion)
                }
        }catch{
            print(error)
        }
    }
}

//MARK: - Swipe Cell Delegate Method
/* we moved this part in the Swipe Controller like this we create a superclass for both view controller
 
extension CategoryViewController: SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }

            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                // handle action by updating model with deletion
                
                if let categoryForDeletion = self.categories?[indexPath.row]{
            do{
                try  self.realm.write{
                    self.realm.delete(categoryForDeletion)
                    }
            }catch{
                print(error)
                    }
                  
            }
        }
           
            // customize the action appearance
            deleteAction.image = UIImage(named: "delete")

            return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
}
*/
    
}
