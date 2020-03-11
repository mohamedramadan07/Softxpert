//
//  DetailsPresenter.swift
//  Recipe
//
//  Created by Mohamed on 3/11/20.
//  Copyright © 2020 iti-training. All rights reserved.
//

import Foundation

class DetailsPresenter {
    weak var detailsView: IDetailsView? 
    
    init(detailsView: IDetailsView) {
        self.detailsView = detailsView
    }
}

extension DetailsPresenter: IDetailsPresenter {
    func getRecipe() {
        guard let unwrappedRecipe = RecipeService.sharedInstance.recipe else { return }
        detailsView?.showData(recipe: unwrappedRecipe)
    }
}
