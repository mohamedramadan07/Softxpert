//
//  BaseContract.swift
//  Recipe
//
//  Created by Mohamed on 3/11/20.
//  Copyright © 2020 iti-training. All rights reserved.
//

import Foundation

protocol IBaseView {
    func showLoading()
    func hideLoading()
    func showErrorMessage(error: String)
    func goToDetails()
}
