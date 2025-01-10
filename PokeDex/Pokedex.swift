//
//  Pokedex.swift
//  PokeDex
//
//  Created by Evan Kim (student LM) on 1/2/25.
//

import Foundation
import SwiftUI

struct FetchDataPokemons: Codable{
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
    
    mutating func getPokedexEntry(speciesURL: String) async -> String? {
        guard !speciesURL.isEmpty else { return nil }
        
        guard let url = URL(string: speciesURL) else { return nil }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let speciesData = try JSONDecoder().decode(SpeciesDetail.self, from: data)
            
            if let flavorTextEntry = speciesData.flavor_text_entries.first(where: { $0.language.name == "en" }) {
                return flavorTextEntry.flavor_text
            }
            
            return nil
        } catch {
            print("Failed to fetch species data from \(speciesURL): \(error.localizedDescription)")
            return nil
        }
    }
    
    func getPokeDetails(detailsURL: String) async -> Int? {
        guard !detailsURL.isEmpty else { return nil }
        
        let URLString = detailsURL
        
        guard let url = URL(string: URLString) else { return nil }
        guard let (data, _) = try? await URLSession.shared.data(from: url) else { return nil }
        
        guard let spriteData = try? JSONDecoder().decode(PokemonDetail.self, from: data) else { return nil }
        return spriteData.id
    }
}

struct Kanto: Codable {
    var results: [Pokemon] = []
}

struct Pokemon: Codable, Identifiable {
    var name: String
    var url: String
    
    var id: String { name }
    var pokedexEntry: String? = nil
}

struct PokemonDetail: Codable {
    var sprites: Sprite
    var id: Int
}

struct Sprite: Codable {
    var front_default: String?
}

struct SpeciesDetail: Codable {
    var flavor_text_entries: [Flavor_Text_Entries]
}

struct Flavor_Text_Entries: Codable {
    let flavor_text: String
    let language: Language
}

struct Language: Codable {
    let name: String
}


//https://pokeapi.co/api/v2/pokemon-species/1/
