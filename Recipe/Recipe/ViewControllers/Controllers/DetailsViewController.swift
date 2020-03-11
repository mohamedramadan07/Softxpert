//
//  DetailsViewController.swift
//  Recipe
//
//  Created by Mohamed on 3/11/20.
//  Copyright © 2020 iti-training. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

class DetailsTableViewController: UITableViewController {
    var recipe: RecipeModel?
    var detailsPresenter: IDetailsPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsPresenter = DetailsPresenter(detailsView: self)
        detailsPresenter?.getRecipe()
    }
}

extension DetailsTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let unwrappedRecipe = recipe, let unwrappedIngredientLines = unwrappedRecipe.ingredientLines {
            return (4 + unwrappedIngredientLines.count)
        } else {
            return 0
        }
    }
    
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let unwrappedRecipe = recipe else { return UITableViewCell() }
    if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! DetailsImgTableViewCell
            cell.recipeDetImg.sd_setImage(with: URL(string: unwrappedRecipe.image ?? ""), placeholderImage: UIImage(named: "placeHolder"))
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! DetailsTitleTableViewCell
            cell.recipeDetTitle.text = unwrappedRecipe.label
            return cell
        } else if(indexPath.row == 2){
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell3", for: indexPath) as! DetailsIngredientsTableViewCell
            cell.recipeDetIngredient .text = unwrappedRecipe.label
            return cell
        } else if indexPath.row == (3 + (unwrappedRecipe.ingredientLines?.count ?? 0)){
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell5", for: indexPath) as! DetailsLinkTableViewCell
            cell.recipeDetLink.text = unwrappedRecipe.uri
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openLink)))
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell4", for: indexPath) as! DetailsSingleIngTableViewCell
            cell.recipeDetSingleIng.text = unwrappedRecipe.ingredientLines?[indexPath.row-3];
            return cell
        }
    }
}

extension DetailsTableViewController: IDetailsView {
    func showData(recipe: RecipeModel) {
        self.recipe = recipe
        self.tableView.reloadData()
    }
    
    @objc func openLink(){
        if let unwrappedRecipe = recipe, let unwrappedURI = unwrappedRecipe.uri {
            let url = URL(string: unwrappedURI)
            if let urlLink = url {
                let safari = SFSafariViewController.init(url: urlLink)
                self.navigationController?.present(safari, animated: true, completion: nil)
            }
        }
    }
}

extension DetailsTableViewController: SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}


