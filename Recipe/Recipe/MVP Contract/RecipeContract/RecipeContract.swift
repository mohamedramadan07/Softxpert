//
//  RecipeContract.swift
//  Recipe
//
//  Created by Mohamed on 3/11/20.
//  Copyright © 2020 iti-training. All rights reserved.
//

import Foundation

protocol IRecipeView: class, IBaseView {
    func renderRecipesWithObjects(recipes: [RecipeModel])
    func updateSearchBar(searchText: String)
}

protocol IRecipePresenter {
    func getRecipes()
    func onSuccess(recipes: [RecipeModel], more: Bool)
    func onFail(errorMessage: String)
    func defineRecipePresenter()
    func setRecipe(recipe: RecipeModel)
    func resetStates(search: String)
}

protocol ISearchView: class {
    func updateData(suggestions: [String])
}

protocol ISearchPresenter {
    func getSuggestions()
    func searchBarSearchButtonClicked(searchText: String)
    func searchBarTextDidChange(searchText: String)
    func onSuccess(searchHistory: [SearchModel])
}

protocol IDetailsView: class {
    func showData(recipe: RecipeModel)
}

protocol IDetailsPresenter {
    func getRecipe()
}

protocol IRecipeManager {
    func getRecipesData(dataURL: String)
    func getSuggestions(searchPresenter: ISearchPresenter)
    func searchBarSearchButtonClicked(searchText: String)
}
