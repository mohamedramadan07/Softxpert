//
//  RealmManager.swift
//  Recipe
//
//  Created by Mohamed on 3/11/20.
//  Copyright © 2020 iti-training. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager{
    static var realmObserverDelegate:RealmObserver?
    
    static func saveToRealm(searchText: String){
        let realm = try! Realm()
        
        let results = realm.objects(SearchModel.self).filter("search = '\(searchText)'")
        let results2 = realm.objects(SearchModel.self).sorted(byKeyPath: "date", ascending: false)
        try! realm.write {
            if results.count > 0 {
                results.first?.setValue(Date(), forKey: "date")
            }else if results2.count < 10 {
                let searchModel = SearchModel()
                searchModel.search = searchText
                searchModel.date = Date()
                realm.add(searchModel)
            }else{
                results2.last?.setValue(searchText, forKey: "search")
                results2.last?.setValue(Date(), forKey: "date")
            }
        }
    }
    
    static func readFromRealm(realmObserver:RealmObserver){
        realmObserverDelegate = realmObserver
        let realm = try! Realm()
        let results = realm.objects(SearchModel.self).sorted(byKeyPath: "date", ascending: false)
        if results.count > 0 {
            realmObserverDelegate?.handleSuccessWithRealm(searchHistory:Array(results))
        }else {
            realmObserverDelegate?.handleSuccessWithRealm(searchHistory: [])
        }
    }
}
