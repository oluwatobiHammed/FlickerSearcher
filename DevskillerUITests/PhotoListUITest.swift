//
//  PhotoListUITest.swift
//  DevskillerUITests
//
//  Created by Oladipupo Oluwatobi on 19/07/2022.
//  Copyright © 2022 Mindera. All rights reserved.
//

import XCTest

class PhotoListUITest: XCTestCase {
    
    private var app: XCUIApplication!
    private var searchTextField: XCUIElement!
    private var collectionViews: XCUIElement!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        app = XCUIApplication()
        app.launch()
        searchTextField = app.textFields["searchTextField"]
        collectionViews = app.collectionViews["photocollectionView"]
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app = nil
        searchTextField = nil
        collectionViews = nil
    }
    
    func testPhotoListViewController_whenViewDidLoad() throws {
        // UI tests must launch the application that they test.
        
        
        let cell0 = collectionViews.children(matching: .cell).element(boundBy: 0)
        let cell3 = collectionViews.children(matching: .cell).element(boundBy: 3)
        cell3.swipeUp(velocity: .slow)
        
        XCTAssert(searchTextField.isEnabled, "search TextField is not enable for user interactions")
        XCTAssert(cell3.isEnabled, "cell3 is not enable for user interactions")
        XCTAssert(cell0.isEnabled, "cell0 is not enable for user interactions")
        
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    
    func testPhotoListViewController_CellBeenTapped() throws {
        // UI tests must launch the application that they test.
        let searchtextfieldTextField = app/*@START_MENU_TOKEN@*/.textFields["searchTextField"]/*[[".textFields[\"  search\"]",".textFields[\"searchTextField\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        searchtextfieldTextField.tap()
        collectionViews.children(matching: .cell).element(boundBy: 0).swipeDown()
        searchtextfieldTextField.tap()
        searchtextfieldTextField.tap()
        
        
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPhotoListViewController_FlowtoImageViewController() throws {
        // UI tests must launch the application that they test.
        collectionViews.children(matching: .cell).element(boundBy: 0).tap()
        XCTAssert(app.otherElements["imageViewController"].waitForExistence(timeout: 1), "The imageViewController was not created when the cell is tapped")
        
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
