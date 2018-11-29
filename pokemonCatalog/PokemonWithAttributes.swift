//
//  PokemonWithAttributes.swift
//  pokemonCatalog
//
//  Created by Brian Christensen on 11/28/18.
//  Copyright © 2018 Brian Christensen. All rights reserved.
//

import Foundation

struct PokemonWithAttributes : Decodable{
    let name: String?
    let height: Int?
    let weight: Int?
}
