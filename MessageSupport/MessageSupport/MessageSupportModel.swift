//
//  MessageSupportModel.swift
//  MessageSupport
//
//  Created by Esraa Gamal on 6/12/21.
//

import Foundation

class MessageSupportModel: SupportMessageModelProtocol {
    
    var presenter: SupportMessagePresenterProtocol?
    
    func getAllCategories() -> [Category]? {
           let decoder = JSONDecoder()
           guard
                let url = Bundle.main.url(forResource: "data", withExtension: "json"),
                let data = try? Data(contentsOf: url),
                let categories = try? decoder.decode([Category].self, from: data)
           else { return nil }
           return categories
    }
}
