//
//  TabbarViewModel.swift
//  ScrollableTabbar
//
//  Created by Ankita Kotadiya on 25/10/24.
//

import Foundation
import Combine

final class TabbarViewModel {
    @Published var products: [Product]?
    @Published var errorString: String?
    
    var tabItems: [String] = ["BEAUTY", "FRAGRANCES", "FURNITURE", "GROCERIES", "NEW IN DATE"]
    
    private var networkManager: NetworkManaging
    private var mainProducts: [Product] = []
    
    init(_networkManager: NetworkManaging = DependencyManager.networkManager) {
        self.networkManager = _networkManager
    }
    
    func getProductList() {
        networkManager.execute(Product.productList) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let page):
                self.mainProducts = page.products ?? []
                self.filterdata(type: "BEAUTY")
                
            case.failure(let error):
                self.errorString = error.localizedDescription
            }
        }
    }
    
    func getProductList() async {
        let result = await networkManager.execute(Product.productList)
        
        switch result {
        case .success(let page):
            if page.message != nil {
                self.errorString = page.message
            } else {
                self.mainProducts = page.products ?? []
                self.filterdata(type: "BEAUTY")
            }
        case .failure(let error):
            self.errorString = error.localizedDescription
        }
    }
    
    func filterdata(type: String) {
        
        if type == "NEW IN DATE" {
            self.products = mainProducts
        } else {
            let filteredData = mainProducts.filter({$0.category == type.lowercased()})
            self.products = filteredData
        }
    }
}
