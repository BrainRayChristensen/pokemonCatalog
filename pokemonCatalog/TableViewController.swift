//
//  ViewController.swift
//  pokemonCatalog
//
//  Created by Brian Christensen on 11/28/18.
//  Copyright © 2018 Brian Christensen. All rights reserved.
//

import UIKit

//used to decode the Json object ffrom the api
struct Info: Decodable {
    let results: [Pokemon]
}

class MainScreenTableView: UITableViewController {

    var pokemonArray = [Pokemon]()
    var selectedPokemonUrl: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let urlString : String = "https://pokeapi.co/api/v2/pokemon/"
        guard let url = URL(string: urlString) else { return }
        
        getJsonData(url)
    }

    //pulls the json data from the pokemon API
    private func getJsonData(_ url: URL) {
        //pull the information from website and parse the json
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            guard let data = data else { return }
            
            do{
                let list = try JSONDecoder().decode(Info.self, from: data)
                self.pokemonArray = list.results
                self.refreshViewAfterJSONReceiced()
            }
            catch let jsonErr {
                print("Error Serializing json: ", jsonErr)
            }
            
            }.resume()
        
    }
    
    //reloads the view on the UI thread
    private func refreshViewAfterJSONReceiced(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //creates the individual cells in the table
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {return UITableViewCell()}
        cell.textLabel?.text = pokemonArray[indexPath.row].name
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonArray.count
    }
    
    //functionallity for clicking on a pokemon "row"
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //get the right info from the clicked on row for the segue
        selectedPokemonUrl = pokemonArray[indexPath.row].url
        //segue
        performSegue(withIdentifier: "segue", sender: self)
    }
    
    //prepares for segue... aka, passes info into the next created view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue"{
            let destVC = segue.destination as! DetailPageViewController
            destVC.url = selectedPokemonUrl
        }
    }
}

