//
//  PhotoViewDelegateProtocol.swift
//  Devskiller
//
//  Created by Oladipupo Oluwatobi on 14/04/2022.
//  Copyright © 2022 Mindera. All rights reserved.
//

import Foundation
@MainActor
protocol PhotoViewDelegateProtocol: AnyObject {
    func errorHandler(error: String)
}
