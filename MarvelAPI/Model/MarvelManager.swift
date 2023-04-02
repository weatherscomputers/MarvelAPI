//
//  MarvelManager.swift
//  MarvelAPI
//
//  Created by Mark Weathers on 2/23/23.
//

import Foundation
import CryptoSwift

protocol MarvelManagerDelegate{
    func updateImage(_ marvelManager: MarvelManager, results: ResultsModel)
    func getUrl(url: String) -> URL?
    func getDescription(_ marvelManager: MarvelManager, results: ResultsModel)
    func didFailWithError(error: Error)
}

struct MarvelManager {
    

    private var publicKey : String{
        get {
            guard let filePath = Bundle.main.path(forResource: "MARVEL API-Info", ofType: "plist")
            else{
                fatalError("Couldn't find Marvel API's Info list")
            }
            let pList = NSDictionary(contentsOfFile: filePath)
            guard let value = pList?.object(forKey: "API_KEY_PUBLIC") as! String? else {
                fatalError("Couldn't fin API_KEY_PUBLIC in plist")
            }
            return value
        }
    }
    
    private var privateKey: String{
        get{
            guard let filePath = Bundle.main.path(forResource: "MARVEL API-Info", ofType: "plist") else {
                fatalError("Couldn't locate Marvel API plist file")
            }
            let pList = NSDictionary(contentsOfFile: filePath)
            guard let value = pList?.object(forKey: "API_KEY_PRIVATE") as! String? else {
                fatalError("Could not fine API_KEY_PRIVATE in plist")
            }
            return value
        }
    }
    
    let timeStamp = "\(Int(Date().timeIntervalSince1970))"
    
    
    
    var hash: String = ""
    
  
    
    var delegate: MarvelManagerDelegate?
    
   
    func fetchCharacter(characterName: String){
        
        let hash = "\(timeStamp)\(privateKey)\(publicKey)".md5()
        let modString = "https://gateway.marvel.com/v1/public/characters?name=\(characterName)&ts=\(timeStamp)&apikey=\(publicKey)&hash=\(hash)"
        let urlString = modString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    // delegate goes here
                    return
                }
                
                if let safeData = data{
                    
                    
                    if let image = self.parseJSON(safeData){
                        
                        delegate?.updateImage(self, results: image)
                        print (image.description)
                        delegate?.getDescription(self, results: image)
                   }
                }
            }
        
            task.resume()
        }
        
    }
    
    
    func parseJSON(_ marvelData: Data) -> ResultsModel? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(APIResults.self, from: marvelData)
            
            guard var character = decodedData.data.results.first else {
                // no character found so bail out
                return nil
            }
            
            let path = character.thumbnail.path
            let `extension` = character.thumbnail.extension
            let charId = character.id
            var descript = character.description
            if character.description == ""{
                descript = "No Available Description from Marvel's API"
            }
            
            let imagePath = ResultsModel(pathString: path, xtensionString: `extension`, characterId: charId, description: descript)
            
    
            
            return imagePath
        }
        catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}// end struct closure
