//
//  Pokedex.swift
//  PokeDex
//
//  Created by Evan Kim (student LM) on 1/2/25.
//

import Foundation
import SwiftUI
struct FetchDataPokemons{
    var kanto: Kanto = Kanto()
    
    mutating func getData() async{
        let URLString = "https://pokeapi.co/api/v2/pokemon/?limit=151"
        
        guard let url = URL(string: URLString) else {return}
        guard let (data, _) = try? await URLSession.shared.data(from: url) else {return}
        
        guard let k = try? JSONDecoder().decode(Kanto.self, from: data) else {return}
        kanto = k
    }
}

struct Kanto: Codable{
    var results: [Pokemon] = []
}

struct Pokemon: Codable{
    var name: String?
    var url: String?
}

extension Pokemon: Identifiable{
    var id: String{name ?? ""}
}






struct FetchSpritePokemons{
    @Binding var pokeURL: String
    var sprite: getSprite = getSprite()
    
    mutating func getData() async{
        
        let URLString = "\(pokeURL)&apiKey=948d8f533bf6439d94f891fae25ccf45"
        
        guard let url = URL(string: URLString) else {return}
        guard let (data, _) = try? await URLSession.shared.data(from: url) else {return}
        
        guard let s = try? JSONDecoder().decode(getSprite.self, from: data) else {return}
        sprite = s
    }
}

struct getSprite: Codable{
    var sprites: [Sprite] = []
}

struct Sprite: Codable{
    var front_default: String?
}

struct FetchSpriteokemons{
    var sprite: getSprite = getSprite()
    
    mutating func getData() async{
        guard let pokemon = Pokemon().url else {return}
        
        let URLString = "\(pokemon)&apiKey=948d8f533bf6439d94f891fae25ccf45"
        
        guard let url = URL(string: URLString) else {return}
        guard let (data, _) = try? await URLSession.shared.data(from: url) else {return}
        
        guard let s = try? JSONDecoder().decode(getSprite.self, from: data) else {return}
        sprite = s
    }
}
