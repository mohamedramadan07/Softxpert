//
//  SearchViewController.swift
//  Recipe
//
//  Created by Mohamed on 3/11/20.
//  Copyright © 2020 iti-training. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController: UITableViewController {
    var searchBar: UISearchBar?
    var suggestions: [String] = []
    var searchPresenter: ISearchPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchPresenter = SearchPresenter(searchView: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchPresenter?.getSuggestions()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath)
        cell.textLabel?.text = suggestions[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let unwrappedSearchBar = searchBar else { return }
        unwrappedSearchBar.text = suggestions[indexPath.row]
        searchBarSearchButtonClicked(unwrappedSearchBar)
    }
}

extension SearchViewController: ISearchView {
    func updateData(suggestions: [String]) {
        self.suggestions = suggestions
        self.tableView.reloadData()
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar = searchBar
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchPresenter?.searchBarSearchButtonClicked(searchText: searchBar.text ?? "")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchPresenter?.searchBarTextDidChange(searchText: searchText)
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.isActive {
            searchController.searchResultsController?.view.isHidden = false
        }
    }
}
