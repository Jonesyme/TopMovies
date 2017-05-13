//
//  MovieRecord.swift
//  TopMovies
//

import JSONJoy
import UIKit

//
// data model for TopMovies WebService response
//
struct MovieRecord : JSONJoy {
    let rank: Int?
    let duration: String
    let description: String
    let director: String
    let genres: [String]
    let actors: [String]
    let id: Int
    let name: String
    
    init(_ decoder: JSONDecoder) throws {
        rank = decoder["Rank"].getOptional()
        duration = try decoder["Duration"].get()
        description = try decoder["Description"].get()
        director = try decoder["Director"].get()
        genres = try decoder["Genres"].get()
        actors = try decoder["Actors"].get()
        id = try decoder["Id"].get()
        name = try decoder["Name"].get()
    }

    // returns a shortened plot synopsis - used for compact views
    func truncatedDescString(maxCharacters:Int) -> String {
        var resultStr = self.description
        if resultStr.characters.count > maxCharacters {
            let index = resultStr.index(resultStr.startIndex, offsetBy: maxCharacters-3)
            resultStr = resultStr.substring(to: index) + "..."
        }
        return resultStr
    }
    
    // convert any list into a comma-delimited string of elements and truncate elements if needed
    func convertListToString(list:[Any], maxElements:Int) -> String {
        var resultStr = ""
        var count:Int = 0
        for elem in list {
            count += 1
            resultStr += String(describing: elem)
            if count == min(maxElements, list.count) {
                break; // don't add comma after n-1 element
            } else {
                resultStr += ", "
            }
        }
        return resultStr
    }
    
    // return attributed string of movie details including plot, actors, director
    func attributedMovieDescriptionString(compactVersion:Bool) -> NSAttributedString {
        // shorten fields for compact views
        var maxActors = 999
        var fieldColor:UIColor = UIColor.white
        if compactVersion {
            maxActors = 3
            fieldColor = UIColor.init(colorLiteralRed:220/255.0, green:220/255.0, blue:220/255.0, alpha:1.0)
        }
        
        // text style attributes
        //let grayAttrBold = [NSFontAttributeName : UIFont.boldSystemFont(ofSize:14), NSForegroundColorAttributeName : UIColor.lightGray]
        let descAttr = [NSFontAttributeName : UIFont.systemFont(ofSize:15), NSForegroundColorAttributeName : UIColor.init(colorLiteralRed:220/255.0, green:220/255.0, blue:220/255.0, alpha:1.0)]
        let fieldNameAttr = [NSFontAttributeName : UIFont.boldSystemFont(ofSize:15), NSForegroundColorAttributeName : fieldColor] as [String : Any]
        let fieldValueAttr = [NSFontAttributeName : UIFont.systemFont(ofSize:15), NSForegroundColorAttributeName : fieldColor] as [String : Any]
        let genreAttr = [NSFontAttributeName : UIFont.systemFont(ofSize:15), NSForegroundColorAttributeName : UIColor.init(colorLiteralRed:169/255.0, green:178/255.0, blue:235/255.0, alpha:1.0)]
        
        // generate combined movie description string
        let movieDescStr = NSMutableAttributedString(string:"")
        // description / synopsis
        movieDescStr.append(NSAttributedString(string:self.description + "\n\n", attributes:descAttr))
        // actors / starring
        movieDescStr.append(NSAttributedString(string:"Starring:  ", attributes:fieldNameAttr))
        movieDescStr.append(NSAttributedString(string:self.convertListToString(list: self.actors, maxElements:maxActors) + "\n\n", attributes:fieldValueAttr))
        // director
        movieDescStr.append(NSAttributedString(string:"Director:  ", attributes:fieldNameAttr))
        movieDescStr.append(NSAttributedString(string:self.director + "\n\n", attributes:fieldValueAttr))
        
        if !compactVersion {
            // genre
            movieDescStr.append(NSAttributedString(string:"Genre:  ", attributes:fieldNameAttr))
            movieDescStr.append(NSAttributedString(string:self.convertListToString(list: self.genres, maxElements:99) + "\n\n", attributes:genreAttr))
            // duration / runtime
            movieDescStr.append(NSAttributedString(string:"Runtime:  ", attributes:fieldNameAttr))
            movieDescStr.append(NSAttributedString(string:self.duration + "\n\n", attributes:descAttr))
        }
        return movieDescStr
    }
}




