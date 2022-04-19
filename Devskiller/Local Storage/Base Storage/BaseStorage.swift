//
//  BaseStorage.swift
//  GetirTodo
//
//  Created by Oladipupo Oluwatobi on 31/03/2022.
//
//
import Foundation
import CoreData

class BaseStorage: BaseStorageProtocol {
    //Generic save method for any data type
   private let photoList = PhotoList(context: PersistenceService.context)
    func savePhotoDetails(data: Data) throws {
        let photo = PhotoDetail(context: PersistenceService.context)
        photo.photodata = data
        photoList.addToPhotos(photo)
        try PersistenceService.saveContext()
    }
    //Generic Load data method for any data type
    func savePhotoList (data: Data) throws {
        self.photoList.data = data
    }
    //Generic delete method for any data type
    func loadPhotoDetails() throws -> Data? {
        let fetchRequest: NSFetchRequest<PhotoDetail> = PhotoDetail.fetchRequest()
        return try PersistenceService.context.fetch(fetchRequest).first?.photodata
    }

    func loadPhotoList() throws -> [PhotoList] {
        let fetchRequest: NSFetchRequest<PhotoList> = PhotoList.fetchRequest()
        return try PersistenceService.context.fetch(fetchRequest)

   }

  
}
