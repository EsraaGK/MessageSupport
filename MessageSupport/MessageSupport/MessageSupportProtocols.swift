//
//  MessageSupportProtocols.swift
//  MessageSupport
//
//  Created by Esraa Gamal on 6/12/21.
//

import Foundation

protocol SupportMessagePresenterProtocol {
    var view: SupportMessageViewControllerProtocol? {get set}
    var model: SupportMessageModelProtocol? {get set}
    
    func viewDidLoad()
    func getAllCategories()
    func getSubCategories()
    func didSelectCategory(with name: String?)
    func didSelectSubCategory(with name: String?)
}

protocol SupportMessageViewControllerProtocol {
    func showProvided(_ categories: [Category])
    func showProvided(_ subCategories: [SubCategory])
    func assignSelected(_ category: Category)
}

protocol SupportMessageModelProtocol {
    func getAllCategories() -> [Category]?
}
