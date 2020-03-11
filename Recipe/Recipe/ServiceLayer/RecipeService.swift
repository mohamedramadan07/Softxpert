//
//  RecipeService.swift
//  Recipe
//
//  Created by Mohamed on 3/11/20.
//  Copyright © 2020 iti-training. All rights reserved.
//

import Foundation
import ObjectMapper

class RecipeService:NetworkObserver, RealmObserver, IRecipeManager {
    
    var recipePresenter: IRecipePresenter?
    var searchPresenter: ISearchPresenter?
    var recipe: RecipeModel?
    var recipes: [RecipeModel] = []
    static let sharedInstance = RecipeService()
    
    private init(){}
    
    func getRecipesData(dataURL: String) {
        if let url = URL(string: dataURL) {
            NetworkManager.connectGetToUrl(link: url, networkObserver:self)
        }
    }
    
    func recipesFetchsuccess(data:AnyObject) {
        let arrayResponse = data["hits"] as! NSArray
        let more = data["more"] as! Bool
        let arrayObject = Mapper<RecipeModel>().mapArray(JSONArray: arrayResponse as! [[String : Any]])
        recipePresenter?.onSuccess(recipes: arrayObject, more: more)
    }
    
    func recipesFetchfailed(message:String) {
        recipePresenter?.onFail(errorMessage: message)
    }
    
    func getSuggestions(searchPresenter: ISearchPresenter) {
        self.searchPresenter = searchPresenter
        RealmManager.readFromRealm(realmObserver: self)
    }
    
    func handleSuccessWithRealm(searchHistory:[SearchModel]) {
        searchPresenter?.onSuccess(searchHistory: searchHistory)
    }
    
    func searchBarSearchButtonClicked(searchText: String) {
        RealmManager.saveToRealm(searchText: searchText)
        recipePresenter?.resetStates(search: searchText)
        recipePresenter?.getRecipes()
    }
    
  
}
