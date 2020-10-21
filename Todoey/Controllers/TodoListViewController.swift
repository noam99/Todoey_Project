//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import Realm
import ChameleonFramework

class TodoListViewController: SwipeTableViewController{
    
 // lesson 280 - datatype for realm is Results so its not like for core data  and we changed its name to  var itemArray = [Item]()// before we used this but its not efficient["Find Mike","Buy eggos", "destroy demogorgon"]
    var todoItems : Results<Item>?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try! Realm()
    
  // lesson 280 - no need for realm only in core data  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
   /* let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist") lesson 268 We don’t need the dataFilePath since no plist is created with the new method used*/
    

    
   // not useful anymore lesson 263 let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
         tableView.separatorStyle = .none
        
       
       // print(dataFilePath)
      /*
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "buy eggs"
        itemArray.append(newItem2)
         
         lesson 264 since we save and load data we dont need this part
 */
        
     /*if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
        itemArray = items
     }  lesson 263 commented since we do not use defaults anymore
 */
        //lesson 273 could use this to pass below ->let request : NSFetchRequest<Item> = Item.fetchRequest()
       //loadItems() //we commented it in 267 but then used it again with coreData after changed the data then we comment it again on lesson 277 and move it on didSet
    }
    
    override func viewWillAppear(_ animated: Bool) {
         if let colorHex = selectedCategory?.colour{
                guard let navBar = navigationController?.navigationBar else {fatalError("navigation controller does not exist")}
                   
            // for ios13 use navBar.backgroundColor
            
            if let navBarColor =  UIColor(hexString: colorHex){
                
                navBar.barTintColor = navBarColor
                
                navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
                
                 searchBar.barTintColor = navBarColor
            }
           
        }
         title = selectedCategory!.name
    }
        
       
        
        
    
 //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       // lesson 288, sont need sonce we inherit from swupe table view ans use the super class cell let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if  let item = todoItems?[indexPath.row]{
        
        cell.textLabel?.text = item.title // before creating the constant we used this itemArray[indexPath.row].title lesson 259
        
            if let color = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)){
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
             
            
        //Ternary operator__>
        // value = condition ? valueIfTrue : value if false
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        }else{
            cell.textLabel?.text = "no items added"
        }
     /*   if itemArray[indexPath.row].done == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }*/ // lesson 260 this was before we wrote the line of code above
        
        return cell
    
    }
    
    // MARK - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print(indexPath.row)
        // print(itemArray[indexPath.row])
        
   // lesson 272 we decided that its better to have the checkmark then eliminate reminder context.delete(itemArray[indexPath.row])
    // lesson 272    itemArray.remove(at: indexPath.row)
    
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                   // lesson 282 learn how to delete stuff from the database realm.delete(item)
                    item.done = !item.done
                }
            }catch{
                print("error saving status")
            }
        }
        
       //lesson 271 alternative to line of code below itemArray[indexPath.row].setValue(<#T##value: Any?##Any?#>, forKey: <#T##String#>)
        
       // lesson 281 - this was to change the done property with core data and then we saved now we use the "if let" that you see above todoItems[indexPath.row].done = !todoItems[indexPath.row].done
        
        /*
        if itemArray[indexPath.row].done == false{
            itemArray[indexPath.row].done = true
        }else{
            itemArray[indexPath.row].done = false
        }*/   //used this insted of the line above lesson 259
    
       /* if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            
        }else{
             tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }*/ //lesson 259 used to use this then we use reloadData
       // lesson 284 saveItems()
        
        tableView.reloadData() 
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
       
        var textField = UITextField()
        
        let alert = UIAlertController(title: "add new ToDoey ITem", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "add item", style: .default) { (action) in
            //what will happen once the user click the Add item button on our UIAlert
           // print("success")
            
           
       /* lesson 280 here we used this line for core Data but with realm is a little bit different (under comments is for realm)
        let newItem =  Item(context: self.context) // it used to be Item() instead of itemlesson 267 dont need it since we use entities and attributes
        newItem.title = textField.text!
        newItem.done = false
        newItem.parentCategory = self.selectedCategory
        self.itemArray.append(newItem) //it used to be this before we did the changes of lesson 259 textField.text!
    */ if let currentCategory = self.selectedCategory{
        do{
            try self.realm.write {
                let newItem = Item()
                newItem.title = textField.text!
                newItem.dateCreated = Date()
                currentCategory.items.append(newItem) // lesson 280 - this line of code is these 2 together newItem.parentCategory = self.selectedCategory and self.itemArray.append(newItem)
              }
           }catch{
            print(error)
           }
        }
            self.tableView.reloadData()
       // lesson 280 - we used this in core data but for realm we can do what we did above self.saveItems()
    }
            
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new item"
           // print(alertTextField.text)
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)

        
    }
    
    //MARK - Model Manipulation Methods
// save Data function is not needed for realm while for coreDAta yes - lesson 284
    /*
    func saveItems(){
      
        do {
            try context.save()
        }catch{
            print("error caught")
        }
        /*let encoder = PropertyListEncoder()
         
        //lesson 263, since we dont use anymore default, self.defaults.set(self.itemArray, forKey: "TodoListArray")
         
                   do{
                       let data = try encoder.encode(self.itemArray)
                       try data.write(to: self.dataFilePath!)
                   }catch{
                       print("error caught")
                   }
         lesson 267 - we dont use propertyListEnocder anymore so we can comment out this since we use entites
                   */
            self.tableView.reloadData()
                   
        }
 */
    
    func loadItems(){
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row]{
            do{
           try  realm.write{
                realm.delete(item)
            }
            }catch{
               print(error)
            }
        }
    }
    
    
    
  /* this was the load item for core DAta
     
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil){
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name Matches %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate ,additionalPredicate])
        } else{
            request.predicate = categoryPredicate
        }
      
        /*
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate ,predicate])
        
        request.predicate = compoundPredicate
         
         lesson 277 we use optional biding on this part of code to avoid issues
    */
        
      // lesson 273 no need anymore simce we pass it as input  let request : NSFetchRequest<Item> = Item.fetchRequest()
        do{
        itemArray = try context.fetch(request)
        }catch{
            print("error caught")
        }
        
        /*
        if let data = try? Data(contentsOf: dataFilePath!){
        let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            }catch{
              print("error caught")
            }
        }
 lesson 267-270 we dont need the load function anymore since we can use the staging area of the appDelegate to load data
  */
    }
   */
    
    
}

//MARK - Search Bar Methods
extension TodoListViewController : UISearchBarDelegate {
     
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // lesson 273 we use a shortcut instead of this let predicate = NSPredicate(format: "Title CONTAINS[cd] %@", searchBar.text!) and  request.predicate = predicate
       
        // request.predicate = NSPredicate(format: "Title CONTAINS[cd] %@", searchBar.text!) lesson 277 we go back to the way of lesson 272 and previous
        
        // under this it was title as sorting criteria until lesson 284
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
         tableView.reloadData()
        
        
 //lesson 284 - we need to update it fpr realm this was for core data   let request : NSFetchRequest<Item> = Item.fetchRequest()
        print(searchBar.text)
        
    //lesson 284 - we need to update it fpr realm this was for core data    let predicate = NSPredicate(format: "Title CONTAINS[cd] %@", searchBar.text!)
       
       // same reason of above  let sortDescriptor = NSSortDescriptor(key: "title", ascending: true) and  request.sortDescriptors = [sortDescriptor]
   //lesson 284 - we need to update it fpr realm this was for core data     request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        
     //lesson 284 - we need to update it fpr realm this was for core data   loadItems(with : request, predicate: predicate)
   /*     do{
        itemArray = try context.fetch(request)
        }catch{
            print("error caught")
        }
         lesson 273 we modified loadItems so its quickier of just copying and paste
        
        tableView.reloadData()
       */
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.count == 0 {
             loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}
