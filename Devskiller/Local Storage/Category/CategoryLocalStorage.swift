//
//  CategoryLocalStorage.swift
//  GetirTodo
//
//  Created by Oladipupo Oluwatobi on 01/04/2022.
//

//import Foundation
//import RealmSwift
//
//class CategoryLocalStorage:CategoryLocalStorageProtocol {
//    let baseStorage: BaseStorageProtocol?
//    
//    init (baseStorage: BaseStorageProtocol) {
//        self.baseStorage = baseStorage
//    }
//    
//    func saveCategory(categories: CategoryModel) throws {
//       //save category in the local storage
//        try baseStorage?.save(responseType: categories)
//    }
//    
//    func loadCategories() throws -> Results<CategoryModel>? {
//        //Load  categories from the local storage
//        try baseStorage?.load(responseType: CategoryModel.self)
//    }
//    
//    func deleteCategory(categories: CategoryModel) throws {
//       //delete category in the local storage
//        try baseStorage?.delete(responseType: categories)
//    }
//    
//}
