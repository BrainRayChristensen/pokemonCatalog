//
//  DetailPageViewController.swift
//  pokemonCatalog
//
//  Created by Brian Christensen on 11/28/18.
//  Copyright © 2018 Brian Christensen. All rights reserved.
//

import UIKit

class DetailPageViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    
    var url: String?
    var pokemonData: PokemonWithAttributes?
    
    var name: String = ""
    var weight: Int = 0
    var height: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let unwrappedUrlString = url else { return }
        guard let url = URL(string: unwrappedUrlString) else { return }
        
        getJsonData(url)
        // Do any additional setup after loading the view.
    }
    
    //pull the information from website and parse the json
    private func getJsonData(_ url: URL) {
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            guard let data = data else { return }
            
            do{
                let INVALID_NUMBER: Int = -1
                let pokemonData = try JSONDecoder().decode(PokemonWithAttributes.self, from: data)
                
                self.name = pokemonData.name ?? "Name was empty"
                self.weight = pokemonData.weight ?? INVALID_NUMBER
                self.height = pokemonData.height ?? INVALID_NUMBER
                
                self.refreshViewAfterJSONReceiced()
            }
            catch let jsonErr {
                print("Error Serializing json: ", jsonErr)
            }
            
            }.resume()
    }
    
    private func refreshViewAfterJSONReceiced(){
        DispatchQueue.main.async {
            self.nameLabel.text = self.name
            self.weightLabel.text = "Weight: " + "\(String(describing: self.weight))"
            self.heightLabel.text = "Height: " + "\(String(describing: self.height))"
        }
    }

}
