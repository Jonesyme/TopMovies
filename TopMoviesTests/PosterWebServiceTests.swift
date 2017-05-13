//
//  PosterWebServiceTests.swift
//  TopMovies
//

import XCTest
@testable import TopMovies

class PosterWebServiceTests: XCTestCase {
    
    // test poster image download
    func testDownloadPosterImage() {
        let expect1 = expectation(description: "downloadPosterImage")
        PosterWebService.sharedInstance.fetchMoviePosterImage(movieId: 255, success: { image in
            guard let imageData = UIImagePNGRepresentation(image) else {
                XCTFail()
                return
            }
            XCTAssert(imageData.count > 5) // assert imagesize > 5 bytes
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
