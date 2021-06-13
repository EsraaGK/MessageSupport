//
//  MessageSupportPresenter.swift
//  MessageSupport
//
//  Created by Esraa Gamal on 6/12/21.
//

import Foundation

class MessageSupportPresenter: SupportMessagePresenterProtocol {
    var model: SupportMessageModelProtocol?
    var view: SupportMessageViewControllerProtocol?
    
    var choosenCategory: Category?
    var choosenSubCategory: SubCategory?
    var categoreis: [Category]?
    
    func viewDidLoad() {
        guard let category = model?.getAllCategories()?.first else { return }
        choosenCategory = category
        view?.assignSelected(category)
    }
    
    func getAllCategories() {
        guard let categoreis =  model?.getAllCategories() else { return }
        self.categoreis = categoreis
        view?.showProvided(categoreis)
    }
    
    func getSubCategories() {
        guard let subCategoreis = choosenCategory?.subCategory else { return }
        view?.showProvided(subCategoreis)
    }
    
    func didSelectCategory(with name: String?) {
        choosenCategory = categoreis?.first(where: { $0.category == name })
        choosenSubCategory = choosenCategory?.subCategory?.first
        guard let choosen =  choosenCategory else { return }
        view?.assignSelected(choosen)
    }
    
    func didSelectSubCategory(with name: String?) {
        choosenSubCategory = choosenCategory?.subCategory?.first(where: { $0.name == name })
    }
}
