//
//  NavigationThemeTests.swift
//  MegaController
//
//  Created by Andy Matuschak on 9/8/15.
//  Copyright © 2015 Andy Matuschak. All rights reserved.
//

@testable import MegaController
import XCTest

class NavigationThemeTests: XCTestCase {
    func testThemeForZeroTasks() {
        XCTAssertEqual(NavigationTheme(numberOfImminentTasks: 0), NavigationTheme.Normal)
    }
    
    func testThemeForAFewTasks() {
        XCTAssertEqual(NavigationTheme(numberOfImminentTasks: 4), NavigationTheme.Warning)
    }
    
    func testThemeForManyTasks() {
        XCTAssertEqual(NavigationTheme(numberOfImminentTasks: 20), NavigationTheme.Normal)
    }
}
