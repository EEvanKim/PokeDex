//
//  Pokedex.swift
//  PokeDex
//
//  Created by Evan Kim (student LM) on 1/2/25.
//

import Foundation
import SwiftUI

struct FetchDataPokemons {
    var kanto: Kanto = Kanto()
    
    mutating func getData() async {
        let URLString = "https://pokeapi.co/api/v2/pokemon/?limit=151"
        
        guard let url = URL(string: URLString) else { return }
        guard let (data, _) = try? await URLSession.shared.data(from: url) else { return }
        
        guard let k = try? JSONDecoder().decode(Kanto.self, from: data) else { return }
        kanto = k
    }
    
    mutating func getSpriteData(pokeURL: String) async -> String? {
        guard !pokeURL.isEmpty else { return nil }
        
        let URLString = pokeURL
        
        guard let url = URL(string: URLString) else { return nil }
        guard let (data, _) = try? await URLSession.shared.data(from: url) else { return nil }
        
        guard let spriteData = try? JSONDecoder().decode(PokemonDetail.self, from: data) else { return nil }
        return spriteData.sprites.front_default
    }
}

struct Kanto: Codable {
    var results: [Pokemon] = []
}

struct Pokemon: Codable, Identifiable {
    var name: String
    var url: String
    
    var id: String { name }
}

struct PokemonDetail: Codable {
    var sprites: Sprite
}

struct Sprite: Codable {
    var front_default: String?
}
