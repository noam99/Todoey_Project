//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Noam Moyal on 24/07/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 80
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
               
       
        cell.delegate = self
               
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }

            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                // handle action by updating model with deletion
                
                print("delete cell")
                self.updateModel(at: indexPath)
                
               /*since from this class we have no access to the categories[indexPath] we comment out this part
                if let categoryForDeletion = self.categories?[indexPath.row]{
            do{
                try  self.realm.write{
                    self.realm.delete(categoryForDeletion)
                    }
            }catch{
                print(error)
                    }
                  
            }*/
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
    
    
    func updateModel(at indexPath: IndexPath) {
        //update our model
        
     print("deleted")
    }
    
}

    
