//
//  ZDWebService.swift
//  TopMovies
//

import SwiftHTTP
import JSONJoy

//
//  WebService error types
//
enum WebServiceError: Error {
    case Connection
    case Parsing
    case Unspecified
    
    var description: String {
        switch self {
        case .Connection:
            return "Unable to contact remote server. Check your internet connection."
        case .Parsing:
            return "Unable to parse JSON file."
        case .Unspecified:
            return "Unspecified connection error occured."
        }
    }
}

//
//  TopMovies WebService interface
//
class ZDWebService {
    
    private init() {} // singleton
    static let sharedInstance: ZDWebService = ZDWebService()
    
    let endpointURL = "https://interview.zocdoc.com/api/1/FEE/AllMovies"
    let authToken = "3b502b3f-b1ff-4128-bd99-626e74836d9c"
    
    // fetch AllMovies
    func fetchAllMovies(success:@escaping (_ movieList:[MovieRecord]) -> Void, failure:@escaping (_ error: WebServiceError?) -> Void) {
        do {
            let opt = try HTTP.GET(endpointURL, parameters: ["authToken" : authToken])
            opt.start { response in
                
                if let error = response.error {
                    print("WebService Error: \(error)")
                    failure(WebServiceError.Connection) // failure, connection error
                }
                
                do {
                    var movieList = Array<MovieRecord>()
                    
                    let decoder = JSONDecoder(response.data)
                    if let arr = decoder.getOptionalArray() {
                        for subDecoder in arr {
                            let movieRecord = try MovieRecord(subDecoder)
                            movieList.append(movieRecord)
                        }
                    }
                    
                    success(movieList) // success, call completiong handler
                    
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




