//
//  RecipeSearch.swift
//  Recipe
//
//  Created by Mohamed on 3/11/20.
//  Copyright © 2020 iti-training. All rights reserved.
//

import Foundation


class SearchPresenter {
    weak var searchView: ISearchView?
    var allSuggestions: [String] = []
    var filterSuggestions: [String] = []
    
    init(searchView: ISearchView) {
        self.searchView = searchView
    }
}

extension SearchPresenter: ISearchPresenter {
    func getSuggestions() {
        allSuggestions = []
        filterSuggestions = []
        RecipeService.sharedInstance.getSuggestions(searchPresenter: self)
    }
    
    func searchBarSearchButtonClicked(searchText: String) {
        RecipeService.sharedInstance.searchBarSearchButtonClicked(searchText: searchText)
    }
    
    func searchBarTextDidChange(searchText: String) {
        if searchText == "" {
            searchView?.updateData(suggestions: allSuggestions)
        } else {
            filterSuggestions = allSuggestions.filter{$0.contains("\(searchText)")}
            searchView?.updateData(suggestions: filterSuggestions)
        }
    }
    
    func onSuccess(searchHistory: [SearchModel]) {
        for item in searchHistory {
            allSuggestions.append(item.search)
        }
        searchView?.updateData(suggestions: allSuggestions)
    }
}

