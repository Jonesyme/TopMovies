//
//  PosterWebService.swift
//  TopMovies
//

import UIKit
import SwiftHTTP
import JSONJoy

//
//  Custom movie poster API
//
class PosterWebService {
    
    private init() {} // singleton
    static let sharedInstance: PosterWebService = PosterWebService()
    
    // our custom movie poster endpoint
    let DWSEndpointURL = "http://www.dreamwaresys.com/api/posters/get.php"
    let DWSApiKey = "SVIW46DBHW636"
    
    // fetch a single movie poster image given a unique movieID value
    func fetchMoviePosterImage(movieId:Int, success:@escaping (_ posterImage:UIImage) -> Void, failure:@escaping (_ error: WebServiceError?) -> Void) {
        do {
            let paramList = ["apikey":DWSApiKey, "id":String(describing:movieId)]
            let opt = try HTTP.GET(DWSEndpointURL, parameters: paramList)
            opt.start { response in
                
                if let error = response.error {
                    print("WebService Error: \(error)")
                    failure(WebServiceError.Connection) // failure, connection error
                }
                
                do {
                    guard let image = UIImage(data:response.data) else {
                        throw WebServiceError.Parsing // failure, parsing error
                    }

                    success(image) // success, call completion handler
                    
                } catch let error {
                    print("WebService Error: \(error)")
                    failure(WebServiceError.Parsing) // failure, parsing error
                }
            }
        } catch let error {
            print("WebService Error: \(error)")
            failure(WebServiceError.Unspecified) // failure, unspecified error
        }
    }
    
}



