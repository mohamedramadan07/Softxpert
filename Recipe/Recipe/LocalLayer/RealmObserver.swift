//
//  RealmObserver.swift
//  Recipe
//
//  Created by Mohamed on 3/11/20.
//  Copyright © 2020 iti-training. All rights reserved.
//

import Foundation

protocol RealmObserver {
    func handleSuccessWithRealm(searchHistory:[SearchModel])
}
