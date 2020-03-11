//
//  RecipeViewController.swift
//  Recipe
//
//  Created by Mohamed on 3/11/20.
//  Copyright © 2020 iti-training. All rights reserved.
//

import UIKit
import SDWebImage
import NVActivityIndicatorView

class RecipesViewController: UIViewController {
    
    @IBOutlet weak var searchControllerContainer: UIView!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.isHidden = true
        }
    }
    
    var searchController: UISearchController?
    var recipePresenter: IRecipePresenter?
    var recipes:[RecipeModel] = []
    var activityIndicator:NVActivityIndicatorView?
    var waiting:UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Recipes"
        recipePresenter = RecipePresenter(recipeView: self)
        recipePresenter?.defineRecipePresenter()
        guard let stvc = self.storyboard?.instantiateViewController(withIdentifier: "STVC") else { return }
        searchController = UISearchController(searchResultsController: stvc)
        if let updater = stvc as? UISearchResultsUpdating {
            searchController?.searchResultsUpdater = updater
        }
        if let unwrappedSearchBar = searchController?.searchBar {
            searchControllerContainer.addSubview(unwrappedSearchBar)
        }
        if let delegate = stvc as? UISearchBarDelegate {
            searchController?.searchBar.delegate = delegate
        }
        searchController?.searchBar.barTintColor = .white
        searchController?.hidesNavigationBarDuringPresentation = false
    }
}

extension RecipesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RecipeTableViewCell
        cell.recipeName.text = recipes[indexPath.row].label
        cell.recipeSource.text = recipes[indexPath.row].source
        cell.recipeHealth.text = (recipes[indexPath.row].healthLabels)?.joined(separator: "-")
        cell.recipeImg.sd_setImage(with: URL(string: recipes[indexPath.row].image ?? ""), placeholderImage: UIImage(named: "ImagePlaceHolder"))
        
        if indexPath.row == recipes.count-5 {
            recipePresenter?.getRecipes()
        }
        
        return cell
    }
}

extension RecipesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        recipePresenter?.setRecipe(recipe: recipes[indexPath.row])
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (recipes.count - 5) {
            recipePresenter?.getRecipes()
        }
    }
}

extension RecipesViewController: IRecipeView {
    
    func showLoading() {
        recipes = Array()
        self.tableView.reloadData()
        self.tableView.isHidden = true
        
        if !notesLabel.isHidden {
            notesLabel.isHidden = true
        }
        addActivityIndicator()
        addWaitingLabel()
    }
    
    func hideLoading() {
        activityIndicator?.stopAnimating()
        activityIndicator?.removeFromSuperview()
        waiting?.removeFromSuperview()
        self.tableView.isHidden = false
    }
    
     func showErrorMessage(error: String) {
        activityIndicator?.stopAnimating()
        activityIndicator?.removeFromSuperview()
        waiting?.removeFromSuperview()
        tableView.isHidden = true
        notesLabel.isHidden = false
        notesLabel.text = error
    }
    
    func goToDetails() {
        guard let DTVC = self.storyboard?.instantiateViewController(withIdentifier: "DTVC") else { return }
        self.navigationController?.pushViewController(DTVC, animated: true)
    }
    
    func renderRecipesWithObjects(recipes: [RecipeModel]) {
        self.recipes = recipes
        tableView.reloadData()
    }
    
    func updateSearchBar(searchText: String) {
        searchController?.isActive = false
        searchController?.searchBar.text = searchText
    }
    
    private func addActivityIndicator() {
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0))
        activityIndicator?.color = UIColor.black
        activityIndicator?.type = .pacman
        activityIndicator?.center = CGPoint(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height/2)
        view.addSubview(activityIndicator!)
        activityIndicator?.startAnimating()
    }
    
    private func addWaitingLabel(){
        waiting = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 150.0, height: 40.0))
        waiting?.text = "Getting Recipes..."
        waiting?.textColor = UIColor.black
        waiting?.center = CGPoint(x: UIScreen.main.bounds.size.width/2, y: UIScreen.main.bounds.size.height/2 + 100)
        view.addSubview(waiting!)
    }
}
