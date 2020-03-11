//
//  searchHistory.swift
//  Recipe
//
//  Created by Mohamed on 3/11/20.
//  Copyright © 2020 iti-training. All rights reserved.
//

import Foundation
import RealmSwift

class SearchModel:Object{
    @objc dynamic var search:String = ""
    @objc dynamic var date:Date = Date()
}
