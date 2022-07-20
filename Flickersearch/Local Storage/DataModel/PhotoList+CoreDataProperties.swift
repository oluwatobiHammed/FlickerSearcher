//
//  PhotoList+CoreDataProperties.swift
//  Devskiller
//
//  Created by Oladipupo Oluwatobi on 18/04/2022.
//  Copyright © 2022 Mindera. All rights reserved.
//
//

import Foundation
import CoreData


extension PhotoList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotoList> {
        return NSFetchRequest<PhotoList>(entityName: "PhotoList")
    }

    @NSManaged public var data: Data?
    @NSManaged public var photos: NSSet?

}

// MARK: Generated accessors for photos
extension PhotoList {

    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: PhotoDetail)

    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: PhotoDetail)

    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)

    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)

}

extension PhotoList : Identifiable {

}
