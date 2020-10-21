//
//  Item.swift
//  Todoey
//
//  Created by Noam Moyal on 02/07/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class Item : Object {
   @objc dynamic var title : String = ""
   @objc dynamic var done : Bool = false
   @objc dynamic var dateCreated : Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    

 }














/* lesson 279 - we use this class again for real so just keep this to remember how was the first time we used it
import Foundation

class Item : Codable{
    
    var title : String = ""
    var done : Bool = false

}
 lesson 266 we used dataModel for create classes
*/
