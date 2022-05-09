//
//  BaseStorageProtocol.swift
//  GetirTodo
//
//  Created by Oladipupo Oluwatobi on 31/03/2022.
//

import Foundation
import CoreData

protocol BaseStorageProtocol {
    func savePhotoDetails(data: Data) throws
    func savePhotoList (data: Data) throws
    func loadPhotoDetails() throws -> Data?
    func deletePhotoList<T:NSManagedObject>(photo: T)
//    func deletePhotoList() throws
//    func deletePhotoData() throws
    func loadPhotoList() throws -> [PhotoList] 
}



