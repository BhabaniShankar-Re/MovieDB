//
//  MovieDBTests.swift
//  MovieDBTests
//
//  Created by Summit on 19/12/20.
//

import XCTest
@testable import MovieDB

class ConfigurationTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let genre = Configuraition.genreName(of: 14)
        XCTAssertNotEqual(genre, "Action")
    }
    
    func testExampleOne() throws {
        let genre = Configuraition.genreName(of: 21)
        XCTAssertNil(genre)
    }
    
    func testExampleTwo() throws {
        let genre = Configuraition.genreName(of: 14)
        XCTAssertEqual(genre, "Fantasy")
    }
    
    func testExampleThree() throws {
        let genres = Configuraition.genreNames(of: [14, 80, 10749])
        XCTAssertEqual(genres, "Crime, Fantasy, Romance")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            let _ = Configuraition.genreNames(of: [14, 80, 10749])
        }
    }

}
