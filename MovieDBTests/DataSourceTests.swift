//
//  DataSourceTests.swift
//  MovieDBTests
//
//  Created by Summit on 20/12/20.
//

import XCTest
@testable import MovieDB

class DataSourceTests: XCTestCase {
    
    var dataSource: DataSource!

    override func setUpWithError() throws {
        dataSource = DataSource()
        dataSource._movieList = dummyData()
        dataSource.searchList = searchDummyData()
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
       // XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        dataSource = nil
    }

    func testExample() throws {
        dataSource.isSearching = true
        XCTAssertEqual(dataSource.searchList, dataSource.movieList)
    }
    
    func testExampleFetchData() throws {
        dataSource.isSearching = false
        XCTAssertEqual(dataSource._movieList, dataSource.movieList)
    }
    
    func testExampleSortList() throws {
        dataSource.sortMovielist(by: .mostPopular)
        XCTAssertEqual(dataSource.movieList[0], dummyData()[1])
        
        dataSource.sortMovielist(by: .topRated)
        XCTAssertEqual(dataSource.movieList[0], dummyData()[0])
    }
    
    
    
    
    
    func dummyData() -> [Movie] {
        return [ Movie(title: "First Movie", overview: "The overview of the first_movie", language: "uk", rating: 9.1, popularity: 123.0, posterUrl: "http://newposterimage.jpg", genres: [14, 23], releaseDate: "12-20-2020", posterImage: nil, thumbnailImage: nil),
                 Movie(title: "Second Movie", overview: "The overview of the second_movie", language: "uk", rating: 9.0, popularity: 663.0, posterUrl: "http://newposterimage.jpg", genres: [14, 1073], releaseDate: "12-20-2020", posterImage: nil, thumbnailImage: nil),
                 Movie(title: "Third Movie", overview: "The overview of the third_movie", language: "us", rating: 6.8, popularity: 93.0, posterUrl: "http://newposterimage.jpg", genres: [14, 23, 44], releaseDate: "12-20-2020", posterImage: nil, thumbnailImage: nil),
                 Movie(title: "Forth Movie", overview: "The overview of the forth_movie", language: "uk", rating: 2.8, popularity: 12.0, posterUrl: "http://newposterimage.jpg", genres: [14, 38], releaseDate: "19-20-2020", posterImage: nil, thumbnailImage: nil) ]
    }
    
    func searchDummyData() -> [Movie] {
        return [Movie(title: "Search Movie One", overview: "The overview of the first_movie", language: "uk", rating: 5.0, popularity: 123.0, posterUrl: "http://newposterimage.jpg", genres: [14, 23], releaseDate: "16-20-2020", posterImage: nil, thumbnailImage: nil),
                Movie(title: "Search Movie Two", overview: "The overview of the second_movie", language: "uk", rating: 7.9, popularity: 663.0, posterUrl: "http://newposterimage.jpg", genres: [14, 1073], releaseDate: "1-06-2020", posterImage: nil, thumbnailImage: nil),
                Movie(title: "Search Movie three", overview: "The overview of the third_movie", language: "us", rating: 6.8, popularity: 933.0, posterUrl: "http://newposterimage.jpg", genres: [14, 23, 44], releaseDate: "21-08-2020", posterImage: nil, thumbnailImage: nil) ]
    }

}


