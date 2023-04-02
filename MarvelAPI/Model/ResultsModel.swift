//
//  ResultsModel.swift
//  MarvelAPI
//
//  Created by Mark Weathers on 2/23/23.
//

import Foundation

struct ResultsModel {
    
    let pathString: String?
    let xtensionString: String?
    let characterId: Int?
    let description: String?
    
    var imageString: String {
        let imagePath = "\(pathString!).\(xtensionString!)"
        
        return imagePath
    }
}
