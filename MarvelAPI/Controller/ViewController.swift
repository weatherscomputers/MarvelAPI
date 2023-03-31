//
//  ViewController.swift
//  MarvelAPI
//
//  Created by Mark Weathers on 2/23/23.
//

import UIKit
import CryptoKit

class ViewController: UIViewController {

var marvelManager = MarvelManager()
    
    @IBOutlet var characterImage: UIImageView!
    
    @IBOutlet var characterTextField: UITextField!
    
    

  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        marvelManager.delegate = self
        characterTextField.delegate = self
        
    }


    
    
}
//MARK: - MarvelManager Delegate
extension ViewController: MarvelManagerDelegate{
    func getUrl(url: String) -> URL? {
        let imageUrl = URL(string: url)
        return imageUrl
    }
    
    func updateImage(_ marvelManager: MarvelManager, results: ResultsModel) {
        
        let image = getUrl(url: results.imageString)
        characterImage.load(url: image!)
    }
    
    func didFailWithError(error: Error) {
            print(error)
    }
    
}

extension ViewController: UITextFieldDelegate{
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        characterTextField.endEditing(true)
        print(characterTextField.text!)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        characterTextField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let character = characterTextField.text{
            marvelManager.fetchCharacter(characterName: character)
            
        }
        
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if characterTextField.text != " "{
            return true
        }else {
            characterTextField.placeholder = "Search Marvel Character"
            return false
        }
    }
}

extension UIImageView{
    func load(url: URL) {
         DispatchQueue.global().async { [weak self] in
             if let data = try? Data(contentsOf: url) {
                 if let image = UIImage(data: data) {
                     DispatchQueue.main.async {
                         self?.image = image
                     }
                 }
             }
         }
     }
    
}

