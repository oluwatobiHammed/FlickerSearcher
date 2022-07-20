//
//  PhotosVC+SearchBarDelegate.swift
//  Devskiller
//
//  Created by Oladipupo Oluwatobi on 20/04/2022.
//  Copyright © 2022 Mindera. All rights reserved.
//

import UIKit


// MARK: - Text Field Delegate
@available(iOS 15.0, *)
extension PhotoListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text,
              !text.isEmpty
        else { return true }
        isSearching = true
        // 1
        photoViewModel.query = text
        ActivityIndicator.shared.start(view: textField)
        handleSearch(query: text)
        self.collectionView.layoutIfNeeded()
        self.collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        textField.text = nil
        textField.resignFirstResponder()
        return true
    }
    
}
