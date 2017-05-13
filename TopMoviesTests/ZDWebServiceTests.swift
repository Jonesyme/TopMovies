//
//  ZDWebServiceTests.swift
//  TopMovies
//

import XCTest
@testable import TopMovies

class ZDWebServiceTests: XCTestCase {
    
    // test movie list download
    func testDownloadMovieRecordList() {
        let expect1 = expectation(description: "downloadMovieList")
        ZDWebService.sharedInstance.fetchAllMovies(success: { movieRecordList in
            XCTAssert(movieRecordList.count > 5) // assert records fetched
            expect1.fulfill()
        }, failure: { errpr in
            XCTFail() // request failed
        })
        
        waitForExpectations(timeout: 25.0) { (error) in
            if error != nil {
                XCTFail(error!.localizedDescription)
            }
        }
    }
}
