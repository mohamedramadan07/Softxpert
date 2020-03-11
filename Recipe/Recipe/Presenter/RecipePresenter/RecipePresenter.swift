//
//  RecipePresenter.swift
//  Recipe
//
//  Created by Mohamed on 3/11/20.
//  Copyright © 2020 iti-training. All rights reserved.
//

import Foundation

class  RecipePresenter {
    weak var recipeView: IRecipeView?
    var more = true
    var page = 1
    var searchText = ""
    var recipes:[RecipeModel] = []
    
    init(recipeView: IRecipeView) {
        self.recipeView = recipeView
    }
}

extension RecipePresenter: IRecipePresenter {
    func defineRecipePresenter() {
        RecipeService.sharedInstance.recipePresenter = self
    }
    
    func getRecipes() {
        if more && (page < 6) {
            if page == 1 {
                recipeView?.showLoading()
            }
            let link = "https://api.edamam.com/search?q=\(searchText)@&app_id=5869454d&app_key=fb757c931bc8a4f00b72bc117b0eadd1&from=\(page*20-20)&to=\(page*20)"
            RecipeService.sharedInstance.getRecipesData(dataURL: link)
            page += 1
        }
    }
    
    func resetStates(search: String) {
        page = 1
        more = true
        recipes = []
        recipeView?.updateSearchBar(searchText: search)
        searchText = search.trimmingCharacters(in: .whitespaces)
    }
    
    func onSuccess(recipes: [RecipeModel], more: Bool) {
        self.more = more
        if page == 2 {
            recipeView?.hideLoading()
        }
        if recipes.count == 0 && page == 2 {
            recipeView?.showErrorMessage(error: "Your Keyword didnt match any result")
        } else {
            self.recipes += recipes
            recipeView?.renderRecipesWithObjects(recipes: self.recipes)
        }
    }
    
    func onFail(errorMessage: String) {
        recipeView?.showErrorMessage(error: errorMessage)
    }
    
    func setRecipe(recipe: RecipeModel) {
        RecipeService.sharedInstance.recipe = recipe
        recipeView?.goToDetails()
    }    
}



