//
//  Results.swift
//  MarvelAPI
//
//  Created by Mark Weathers on 2/23/23.
//

import Foundation

struct APIResults: Codable {
    var status: String
    
    var data: APICharacterData
   
}

struct APICharacterData: Codable{
    var count: Int
    var results: [Results]
}


 struct Results : Codable{
    var thumbnail : ThumbNail
}
struct ThumbNail: Codable {
    
    var path: String
    var `extension` : String
    
    
}
