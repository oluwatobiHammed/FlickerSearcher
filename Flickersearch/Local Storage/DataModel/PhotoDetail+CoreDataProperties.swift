//
//  PhotoDetail+CoreDataProperties.swift
//  Devskiller
//
//  Created by Oladipupo Oluwatobi on 18/04/2022.
//  Copyright © 2022 Mindera. All rights reserved.
//
//

import Foundation
import CoreData


extension PhotoDetail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotoDetail> {
        return NSFetchRequest<PhotoDetail>(entityName: "PhotoDetail")
    }

    @NSManaged public var photodata: Data?
    @NSManaged public var parentPhotolist: PhotoList?

}

extension PhotoDetail : Identifiable {

}
