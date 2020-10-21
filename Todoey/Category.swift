//
//  Category.swift
//  Todoey
//
//  Created by Noam Moyal on 16/07/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class Category : Object{
    
    @objc dynamic var colour : String = ""
    @objc dynamic var name : String = ""
    
    let items = List<Item>()
    
}
